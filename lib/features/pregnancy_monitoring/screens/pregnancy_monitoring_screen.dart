import 'dart:async';

import 'package:flutter/material.dart';
import 'package:gosheep_mobile/core/widgets/app_banner.dart';
import 'package:gosheep_mobile/core/widgets/app_refresh_indicator.dart';
import 'package:gosheep_mobile/core/widgets/async_state_sliver.dart';
import 'package:gosheep_mobile/core/widgets/empty_data.dart';
import 'package:gosheep_mobile/core/widgets/filter_pill.dart';
import 'package:gosheep_mobile/core/widgets/no_connection.dart';
import 'package:gosheep_mobile/core/widgets/summary_card.dart';
import 'package:gosheep_mobile/data/models/pregnancy.dart';
import 'package:gosheep_mobile/data/providers/pregnant_sheep_provider.dart';
import 'package:gosheep_mobile/features/pregnancy_monitoring/widgets/pregnancy_monitoring_card.dart';
import 'package:gosheep_mobile/features/pregnancy_monitoring/widgets/pregnancy_monitoring_card_skeleton.dart';
import 'package:provider/provider.dart';

class PregnancyMonitoringScreen extends StatelessWidget {
  const PregnancyMonitoringScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => PregnantSheepProvider()
        ..fetchInitial()
        ..fetchSummary(),
      child: const _PregnancyMonitoringView(),
    );
  }
}

class _PregnancyMonitoringView extends StatefulWidget {
  const _PregnancyMonitoringView();

  @override
  State<_PregnancyMonitoringView> createState() =>
      _PregnancyMonitoringViewState();
}

class _PregnancyMonitoringViewState extends State<_PregnancyMonitoringView> {
  final _scrollController = ScrollController();
  String? _filter;

  final _search = TextEditingController();
  Timer? _debounce;

  List<Pregnancy> _filteredByStatus(List<Pregnancy> list) {
    if (_filter == null) return list;
    return list.where((p) => p.status == _filter).toList();
  }

  @override
  void initState() {
    super.initState();

    _scrollController.addListener(_onScroll);

    _search.addListener(() {
      if (_debounce?.isActive ?? false) {
        _debounce!.cancel();
      }

      _debounce = Timer(const Duration(milliseconds: 300), () {
        context.read<PregnantSheepProvider>().searchPregnancies(_search.text);
      });
    });
  }

  @override
  void dispose() {
    _debounce?.cancel();
    _search.dispose();
    _scrollController
      ..removeListener(_onScroll)
      ..dispose();
    super.dispose();
  }

  void _onScroll() {
    final provider = context.read<PregnantSheepProvider>();
    final pos = _scrollController.position;

    if (pos.maxScrollExtent == 0) return;
    if (provider.error?.isNotEmpty == true) return;
    if (provider.pregnancies.isEmpty) return;

    if (pos.pixels >= pos.maxScrollExtent - 200) {
      provider.fetchMore();
    }
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<PregnantSheepProvider>();
    final listData = _filteredByStatus(provider.pregnancies);
    final isSearching = provider.isSearching;
    final stats = provider.stats;
    final isStatsLoading = provider.isStatsLoading;

    return Scaffold(
      appBar: AppBar(
        foregroundColor: Colors.white,
        backgroundColor: Theme.of(context).colorScheme.primary,
        centerTitle: true,
        title: const Text(
          'Monitoring Kebuntingan',
          style: TextStyle(fontWeight: FontWeight.w700, fontSize: 18),
        ),
      ),
      body: SafeArea(
        child: AppRefreshIndicator(
          onRefresh: provider.refresh,
          child: CustomScrollView(
            controller: _scrollController,
            physics: const AlwaysScrollableScrollPhysics(
              parent: BouncingScrollPhysics(),
            ),
            slivers: [
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Statistik Kebuntingan",
                        style: Theme.of(context).textTheme.headlineSmall
                            ?.copyWith(fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 4),
                      const Text(
                        "Pantau masa kebuntingan dan kelahiran domba",
                        style: TextStyle(color: Colors.grey, fontSize: 13),
                      ),
                    ],
                  ),
                ),
              ),

              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(16, 0, 16, 14),
                  child: Row(
                    children: [
                      Expanded(
                        child: SummaryCard(
                          label: "Bunting",
                          value: '${stats?.pregnantSheep ?? '-'}',
                          isLoading: isStatsLoading,
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: SummaryCard(
                          label: "Melahirkan",
                          value: '${stats?.gaveBirth ?? '-'}',
                          isLoading: isStatsLoading,
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: SummaryCard(
                          label: "Keguguran",
                          value: '${stats?.miscarriages ?? '-'}',
                          isLoading: isStatsLoading,
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(16, 0, 16, 10),
                  child: SearchBar(
                    controller: _search,
                    hintText: 'Cari Eartag domba...',
                    leading: const Icon(Icons.search_rounded),
                    elevation: WidgetStateProperty.all(0),
                    backgroundColor: WidgetStateProperty.all(Colors.white),
                    shape: WidgetStateProperty.all(
                      RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    trailing: [
                      if (_search.text.isNotEmpty)
                        IconButton(
                          icon: const Icon(Icons.close),
                          onPressed: () => _search.clear(),
                        ),
                    ],
                  ),
                ),
              ),

              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(16, 0, 16, 18),
                  child: SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: [
                        FilterPill(
                          label: 'Semua',
                          active: _filter == null,
                          onTap: () => setState(() => _filter = null),
                        ),
                        const SizedBox(width: 8),
                        FilterPill(
                          label: 'Bunting',
                          active: _filter == 'ongoing',
                          onTap: () => setState(() => _filter = 'ongoing'),
                        ),
                        const SizedBox(width: 8),
                        FilterPill(
                          label: 'Melahirkan',
                          active: _filter == 'birthed',
                          onTap: () => setState(() => _filter = 'birthed'),
                        ),
                        const SizedBox(width: 8),
                        FilterPill(
                          label: 'Keguguran',
                          active: _filter == 'miscarried',
                          onTap: () => setState(() => _filter = 'miscarried'),
                        ),
                      ],
                    ),
                  ),
                ),
              ),

              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(16, 0, 16, 14),
                  child: switch (_filter) {
                    'ongoing' => const AppBanner(
                      backgroundColor: Color(0xFF2E7D52),
                      pillLabel: 'Ongoing',
                      title: 'Domba Sedang\nDalam Masa Kebuntingan',
                      subtitle: 'Indukan memerlukan pengawasan nutrisi ekstra',
                      decorIcon: Icons.favorite_rounded,
                    ),
                    'birthed' => const AppBanner(
                      backgroundColor: Color(0xFF1E88E5),
                      pillLabel: 'Melahirkan',
                      title: 'Proses Kelahiran\nSelesai',
                      subtitle: 'Catatan anakan baru telah berhasil terdata',
                      decorIcon: Icons.child_care_rounded,
                    ),
                    'miscarried' => AppBanner(
                      backgroundColor: Colors.red.shade700,
                      pillLabel: 'Keguguran',
                      title: 'Kebuntingan Gagal\n/ Keguguran',
                      subtitle: 'Evaluasi kondisi fisik dan kesehatan indukan',
                      decorIcon: Icons.warning_rounded,
                    ),
                    null || _ => const AppBanner(
                      backgroundColor: Colors.black,
                      pillLabel: 'Semua Status',
                      title: 'Seluruh Data\nKebuntingan',
                      subtitle: 'Menampilkan semua masa pemantauan indukan',
                      decorIcon: Icons.list_alt_rounded,
                    ),
                  },
                ),
              ),

              const SliverToBoxAdapter(
                child: Padding(
                  padding: EdgeInsets.fromLTRB(16, 0, 16, 12),
                  child: Text(
                    'DATA MONITORING KEBUNTINGAN',
                    style: TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w700,
                      color: Colors.black54,
                      letterSpacing: 1.2,
                    ),
                  ),
                ),
              ),

              AsyncStateSliver<Pregnancy>(
                isLoading: provider.isLoading,
                error: provider.error,
                data: listData,
                onLoading: () => SliverPadding(
                  padding: const EdgeInsets.fromLTRB(16, 0, 16, 24),
                  sliver: SliverList.builder(
                    itemBuilder: (_, __) =>
                        const PregnancyMonitoringCardSkeleton(),
                    itemCount: 6,
                  ),
                ),
                onError: (err) => SliverToBoxAdapter(
                  child: NoConnection(
                    onRetry: [provider.refresh],
                    description: err,
                  ),
                ),
                onEmpty: () => SliverToBoxAdapter(
                  child: EmptyData(
                    title: isSearching
                        ? 'Data Tidak Ditemukan'
                        : 'Data Kebuntingan Kosong',
                    description: isSearching
                        ? 'Tidak ada domba dengan Eartag tersebut'
                        : 'Belum ada data kebuntingan tercatat',
                  ),
                ),
                onSuccess: (data) => SliverPadding(
                  padding: const EdgeInsets.fromLTRB(16, 0, 16, 24),
                  sliver: SliverList.builder(
                    itemCount: data.length,
                    itemBuilder: (_, index) =>
                        PregnancyMonitoringCard(pregnancy: data[index]),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
