import 'dart:async';

import 'package:flutter/material.dart';
import 'package:gosheep_mobile/core/utils/sheep_status_util.dart';
import 'package:gosheep_mobile/core/widgets/app_banner.dart';
import 'package:gosheep_mobile/core/widgets/app_refresh_indicator.dart';
import 'package:gosheep_mobile/core/widgets/async_state_sliver.dart';
import 'package:gosheep_mobile/core/widgets/empty_data.dart';
import 'package:gosheep_mobile/core/widgets/filter_pill.dart';
import 'package:gosheep_mobile/core/widgets/no_connection.dart';
import 'package:gosheep_mobile/core/widgets/summary_card.dart';
import 'package:gosheep_mobile/data/providers/health_provider.dart';
import 'package:gosheep_mobile/data/providers/statistic_provider.dart';
import 'package:gosheep_mobile/features/health_record/widgets/health_chart_card.dart';
import 'package:gosheep_mobile/features/health_record/widgets/health_overview_card.dart';
import 'package:gosheep_mobile/features/health_record/widgets/health_overview_card_skeleton.dart';
import 'package:provider/provider.dart';

class HealthScreen extends StatelessWidget {
  const HealthScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => StatisticProvider()..fetchHealthRecordStatistics(),
        ),
        ChangeNotifierProvider(create: (_) => HealthProvider()..fetchInitial()),
      ],
      child: const _HealthScreenView(),
    );
  }
}

class _HealthScreenView extends StatefulWidget {
  const _HealthScreenView();

  @override
  State<_HealthScreenView> createState() => _HealthScreenViewState();
}

class _HealthScreenViewState extends State<_HealthScreenView> {
  final _scrollController = ScrollController();
  final _search = TextEditingController();

  Timer? _debounce;

  String _filter = 'all';

  static const Map<String, List<String>> severityGroup = {
    'safe': ['normal'],
    'warning': ['ringan', 'sedang'],
    'critical': ['berat'],
  };

  @override
  void initState() {
    super.initState();

    _scrollController.addListener(_onScroll);

    _search.addListener(() {
      if (_debounce?.isActive ?? false) _debounce!.cancel();

      _debounce = Timer(const Duration(milliseconds: 300), () {
        context.read<HealthProvider>().search(_search.text);
      });
    });
  }

  void _onScroll() {
    final provider = context.read<HealthProvider>();
    final pos = _scrollController.position;

    if (pos.maxScrollExtent == 0) return;
    if (provider.error?.isNotEmpty == true) return;
    if (provider.healths.isEmpty) return;

    if (pos.pixels >= pos.maxScrollExtent - 200) {
      provider.fetchMore();
    }
  }

  @override
  void dispose() {
    _debounce?.cancel();
    _search.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  List filtered(List list) {
    if (_filter == 'all') return list;

    final allowed = severityGroup[_filter] ?? [];

    return list
        .where((e) => allowed.contains(e.latestHealth.severity))
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<HealthProvider>();
    final isSearching = provider.isSearching;

    final data = filtered(provider.healths);

    return Scaffold(
      body: AppRefreshIndicator(
        onRefresh: provider.refresh,
        child: CustomScrollView(
          controller: _scrollController,
          physics: const AlwaysScrollableScrollPhysics(),
          slivers: [
            SliverAppBar(
              pinned: true,
              expandedHeight: 60,
              centerTitle: true,
              backgroundColor: Theme.of(context).colorScheme.primary,
              foregroundColor: Colors.white,
              title: const Text(
                "Kesehatan",
                style: TextStyle(fontWeight: FontWeight.w700, fontSize: 18),
              ),
            ),

            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(16, 16, 16, 10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Pantau Kesehatan',
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: 4),
                    const Text(
                      'Kelola kondisi kesehatan domba',
                      style: TextStyle(color: Colors.grey),
                    ),

                    const SizedBox(height: 16),

                    Consumer<StatisticProvider>(
                      builder: (context, provider, child) {
                        final bool isLoading = provider.isLoading;
                        return Column(
                          children: [
                            HealthChartCard(
                              statistic: provider.healthRecordStatistic,
                              isLoading: isLoading,
                            ),
                            const SizedBox(height: 12),
                            Row(
                              children: [
                                Expanded(
                                  child: SizedBox(
                                    height: 100,
                                    child: SummaryCard(
                                      label: 'Total Catatan',
                                      value:
                                          '${provider.healthRecordStatistic?.totalRecords ?? 0}',
                                      description: 'Seluruh Riwayat',
                                      fontSize: 18,
                                      isLoading: isLoading,
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 10),
                                Expanded(
                                  child: SizedBox(
                                    height: 100,
                                    child: SummaryCard(
                                      label: 'Kategori Terbanyak',
                                      value:
                                          SheepStatusUtil.healthCategoryLabel(
                                            provider
                                                    .healthRecordStatistic
                                                    ?.topCategoryName ??
                                                '-',
                                          ),
                                      description:
                                          '${provider.healthRecordStatistic?.topCategoryTotal ?? 0} Catatan (30 Hari)',
                                      fontSize: 18,
                                      isLoading: isLoading,
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 10),
                                Expanded(
                                  child: SizedBox(
                                    height: 100,
                                    child: SummaryCard(
                                      label: 'Catatan Baru',
                                      value:
                                          '${provider.healthRecordStatistic?.recordsThisWeek ?? 0}',
                                      description: 'Minggu ini',
                                      fontSize: 18,
                                      isLoading: isLoading,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        );
                      },
                    ),
                  ],
                ),
              ),
            ),

            const SliverToBoxAdapter(
              child: Padding(
                padding: EdgeInsets.fromLTRB(16, 0, 16, 12),
                child: Text(
                  'KESEHATAN TERNAK',
                  style: TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w700,
                    color: Colors.black54,
                    letterSpacing: 1.2,
                  ),
                ),
              ),
            ),

            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(16, 0, 16, 10),
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: [
                      for (final (label, value) in const [
                        ('Semua', 'all'),
                        ('Aman', 'safe'),
                        ('Waspada', 'warning'),
                        ('Kritis', 'critical'),
                      ]) ...[
                        FilterPill(
                          label: label,
                          active: _filter == value,
                          onTap: () => setState(() => _filter = value),
                        ),
                        const SizedBox(width: 8),
                      ],
                    ],
                  ),
                ),
              ),
            ),

            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(16, 0, 16, 12),
                child: switch (_filter) {
                  'all' => const AppBanner(
                    backgroundColor: Colors.black,
                    pillLabel: 'Semua Data',
                    title: 'Semua Data Kesehatan',
                    subtitle: 'Menampilkan seluruh catatan kesehatan',
                    decorIcon: Icons.list_alt_rounded,
                  ),
                  'safe' => const AppBanner(
                    backgroundColor: Color(0xFF2E7D52),
                    pillLabel: 'Aman',
                    title: 'Kondisi Stabil',
                    subtitle: 'Tidak ada kondisi berbahaya',
                    decorIcon: Icons.verified_rounded,
                  ),
                  'warning' => const AppBanner(
                    backgroundColor: Color(0xFFB8860B),
                    pillLabel: 'Waspada',
                    title: 'Perlu Pemantauan',
                    subtitle: 'Beberapa kondisi perlu diperhatikan',
                    decorIcon: Icons.warning_amber_rounded,
                  ),
                  'critical' => const AppBanner(
                    backgroundColor: Colors.red,
                    pillLabel: 'Kritis',
                    title: 'Kondisi Darurat',
                    subtitle: 'Segera lakukan tindakan',
                    decorIcon: Icons.emergency_rounded,
                  ),
                  _ => const SizedBox.shrink(),
                },
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
                        onPressed: () {
                          _search.clear();
                        },
                      ),
                  ],
                ),
              ),
            ),

            AsyncStateSliver(
              isLoading: provider.isLoading,
              error: provider.error,
              data: data,
              onLoading: () => SliverPadding(
                padding: const EdgeInsets.fromLTRB(16, 0, 16, 24),
                sliver: SliverList.builder(
                  itemBuilder: (_, __) => const HealthOverviewCardSkeleton(),
                  itemCount: 6,
                ),
              ),
              onError: (err) => SliverToBoxAdapter(
                child: NoConnection(
                  description: err,
                  onRetry: [
                    provider.refresh,
                    () => context.read<StatisticProvider>().fetchHealthStats(),
                  ],
                ),
              ),
              onEmpty: () => SliverToBoxAdapter(
                child: EmptyData(
                  title: isSearching
                      ? 'Domba Tidak Ditemukan'
                      : 'Catatan Kesehatan Belum Tersedia',
                  description: isSearching
                      ? 'Tidak ada domba dengan Eartag tersebut'
                      : 'Tambahkan domba dan pantau kesehatannya secara rutin',
                ),
              ),
              onSuccess: (data) => SliverPadding(
                padding: const EdgeInsets.fromLTRB(16, 0, 16, 24),
                sliver: SliverList.builder(
                  itemCount: data.length,
                  itemBuilder: (_, i) =>
                      HealthOverviewCard(healthOverview: data[i]),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
