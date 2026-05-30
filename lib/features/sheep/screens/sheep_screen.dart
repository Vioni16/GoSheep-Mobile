import 'dart:async';

import 'package:flutter/material.dart';
import 'package:gosheep_mobile/core/theme/theme.dart';
import 'package:gosheep_mobile/core/utils/format_helper.dart';
import 'package:gosheep_mobile/core/widgets/app_banner.dart';
import 'package:gosheep_mobile/core/widgets/app_refresh_indicator.dart';
import 'package:gosheep_mobile/core/widgets/async_state_sliver.dart';
import 'package:gosheep_mobile/core/widgets/empty_data.dart';
import 'package:gosheep_mobile/core/widgets/no_connection.dart';
import 'package:gosheep_mobile/core/widgets/toast_widget.dart';
import 'package:gosheep_mobile/data/providers/sheep_form_option_provider.dart';
import 'package:gosheep_mobile/data/providers/sheep_stats_provider.dart';
import 'package:gosheep_mobile/features/healt_history/screens/healt_history_screen.dart';
import 'package:gosheep_mobile/features/sheep/screens/sheep_detail_screen.dart';
import 'package:provider/provider.dart';
import 'package:gosheep_mobile/features/sheep/widgets/add_sheep_sheet.dart';
import 'package:gosheep_mobile/core/widgets/filter_pill.dart';
import 'package:gosheep_mobile/features/sheep/widgets/sheep_card.dart';
import 'package:gosheep_mobile/core/widgets/summary_card.dart';

import '../../../data/models/sheep.dart';
import '../../../data/providers/sheep_provider.dart';
import '../widgets/sheep_card_skeleton.dart';

class SheepScreen extends StatelessWidget {
  const SheepScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => SheepProvider()..fetchInitial()),
        ChangeNotifierProvider(
          create: (_) => SheepStatsProvider()..fetchHealthStats(),
        ),
      ],
      child: const _SheepScreenView(),
    );
  }
}

class _SheepScreenView extends StatefulWidget {
  const _SheepScreenView();

  @override
  State<_SheepScreenView> createState() => _SheepScreenViewState();
}

class _SheepScreenViewState extends State<_SheepScreenView> {
  List<Sheep> _filteredByStatus(List<Sheep> list) {
    if (_filter == 'all') {
      return list;
    }

    if (_filter == 'stress_monitor') {
      return list
          .where((sheep) => sheep.currentEnvironmentCond != null)
          .toList();
    }

    return list.where((sheep) => sheep.statusUi == _filter).toList();
  }

  final _search = TextEditingController();
  final _scrollController = ScrollController();

  String _filter = 'all';
  Timer? _debounce;

  @override
  void initState() {
    super.initState();

    _scrollController.addListener(_onScroll);

    _search.addListener(() {
      if (_debounce?.isActive ?? false) {
        _debounce!.cancel();
      }

      _debounce = Timer(const Duration(milliseconds: 300), () {
        context.read<SheepProvider>().searchSheep(_search.text);
      });
    });
  }

  @override
  void dispose() {
    _search.dispose();

    _scrollController
      ..removeListener(_onScroll)
      ..dispose();

    super.dispose();
  }

  void _onScroll() {
    final pos = _scrollController.position;

    if (pos.maxScrollExtent == 0) return;

    if (pos.pixels >= pos.maxScrollExtent - 200) {
      context.read<SheepProvider>().fetchMore();
    }
  }

  void _openAdd() => showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    builder: (_) {
      return MultiProvider(
        providers: [
          ChangeNotifierProvider.value(value: context.read<SheepProvider>()),

          ChangeNotifierProvider(create: (_) => SheepFormOptionProvider()),
        ],
        child: const AddSheepSheet(),
      );
    },
  );

  Future<void> _handleConfirmDelete(
    BuildContext context,
    int sheepId,
    String sheepEarTag,
  ) async {
    if (!context.mounted) return;

    final sheepProvider = context.read<SheepProvider>();
    final success = await sheepProvider.deleteSheep(sheepId);

    if (!context.mounted) return;

    if (success) {
      await context.read<SheepStatsProvider>().fetchHealthStats();

      ToastService.show(
        context,
        sheepProvider.message,
        title: 'Berhasil!\n$sheepEarTag',
        type: ToastType.success,
      );
    } else {
      ToastService.show(
        context,
        sheepProvider.error ?? "Gagal menghapus domba",
        title: 'Gagal Menghapus Domba!',
        type: ToastType.error,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<SheepProvider>();
    final sheepList = _filteredByStatus(provider.sheepList);
    final isSearching = provider.isSearching;

    return SafeArea(
      child: AppRefreshIndicator(
        onRefresh: provider.refresh,
        child: CustomScrollView(
          controller: _scrollController,
          physics: const AlwaysScrollableScrollPhysics(),
          slivers: [
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(16, 16, 16, 14),
                child: Row(
                  children: [
                    const Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Data Domba',
                            style: TextStyle(
                              fontSize: 22,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          SizedBox(height: 2),
                          Text(
                            'Peternakan Maju Jaya',
                            style: TextStyle(
                              fontSize: 13,
                              color: Colors.black54,
                            ),
                          ),
                        ],
                      ),
                    ),
                    GestureDetector(
                      onTap: _openAdd,
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 14,
                          vertical: 10,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.black,
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: const Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(Icons.add, color: Colors.white, size: 16),
                            SizedBox(width: 6),
                            Text(
                              'Tambah',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 13,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),

            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(16, 0, 16, 14),
                child: Consumer<SheepStatsProvider>(
                  builder: (context, statsProvider, _) {
                    final stats = statsProvider.healthStats;
                    final isLoading = statsProvider.isLoading;

                    final healthy = stats?.healthyTotal ?? 0;
                    final sick = stats?.sickTotal ?? 0;

                    return Row(
                      children: [
                        Expanded(
                          child: SummaryCard(
                            label: 'Sehat',
                            value: isLoading ? '-' : '$healthy',
                          ),
                        ),
                        const SizedBox(width: 10),
                        const SizedBox(width: 10),
                        Expanded(
                          child: SummaryCard(
                            label: 'Sakit',
                            value: isLoading ? '-' : '$sick',
                          ),
                        ),
                      ],
                    );
                  },
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
                      for (final (label, value) in const [
                        ('Semua', 'all'),
                        ('Sehat', 'sehat'),
                        ('Sakit', 'sakit'),
                        ('Stress Monitor', 'stress_monitor'),
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

            const SliverToBoxAdapter(
              child: Padding(
                padding: EdgeInsets.fromLTRB(16, 0, 16, 12),
                child: Text(
                  'DAFTAR TERNAK',
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
                padding: const EdgeInsets.fromLTRB(16, 0, 16, 14),
                child: switch (_filter) {
                  'all' => const AppBanner(
                    backgroundColor: Colors.black,
                    pillLabel: 'Semua Data',
                    title: 'Seluruh Ternak',
                    subtitle: 'Menampilkan semua domba\nyang terdaftar',
                    decorIcon: Icons.format_list_bulleted_rounded,
                  ),
                  'sehat' => const AppBanner(
                    backgroundColor: Color(0xFF2E7D52),
                    pillLabel: 'Kondisi Baik',
                    title: 'Domba Sehat',
                    subtitle: 'Tidak ada keluhan,\nkondisi prima',
                    decorIcon: Icons.favorite_rounded,
                  ),
                  'sakit' => AppBanner(
                    backgroundColor: AppTheme.primaryGreen,
                    pillLabel: 'Perlu Tindakan',
                    title: 'Butuh Pemeriksaan\nLanjutan',
                    subtitle: 'Lihat kondisi & riwayat kesehatan domba',
                    decorIcon: Icons.medical_services_rounded,
                    buttonLabel: 'Lihat Detail',
                    onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => const HealthHistoryScreen(),
                      ),
                    ),
                  ),
                  'stress_monitor' => const AppBanner(
                    backgroundColor: Color(0xFFB8860B),
                    pillLabel: 'Monitoring Aktif',
                    title: 'Pemantauan\nStres Domba',
                    subtitle: 'Domba dengan data kondisi lingkungan aktif',
                    decorIcon: Icons.sensors_rounded,
                  ),
                  _ => const SizedBox.shrink(),
                },
              ),
            ),
            AsyncStateSliver<Sheep>(
              isLoading: provider.isLoading,
              error: provider.error,
              data: sheepList,
              onLoading: () => SliverPadding(
                padding: const EdgeInsets.fromLTRB(16, 0, 16, 24),
                sliver: SliverList.builder(
                  itemBuilder: (_, __) => const SheepCardSkeleton(),
                  itemCount: 6,
                ),
              ),
              onError: (err) => SliverToBoxAdapter(
                child: FormatHelper.isNoConnection(err)
                    ? NoConnection(onRetry: provider.refresh)
                    : EmptyData(
                        title: 'Terjadi Kesalahan!',
                        description: err,
                        onRetry: provider.refresh,
                      ),
              ),
              onEmpty: () => SliverToBoxAdapter(
                child: EmptyData(
                  title: isSearching
                      ? 'Domba Tidak Ditemukan'
                      : 'Belum Ada Data',
                  description: isSearching
                      ? 'Tidak ada domba dengan Eartag tersebut'
                      : 'Belum ada domba yang terdaftar',
                ),
              ),
              onSuccess: (data) => SliverPadding(
                padding: const EdgeInsets.fromLTRB(16, 0, 16, 24),
                sliver: SliverList.builder(
                  itemBuilder: (_, index) => SheepCard(
                    onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => SheepDetailScreen(
                          id: data[index].id,
                          initialData: data[index],
                        ),
                      ),
                    ),
                    sheep: data[index],
                    showEnvironmentStatus: _filter == 'stress_monitor',
                    onConfirmDelete: (context) => _handleConfirmDelete(
                      context,
                      data[index].id,
                      data[index].earTag,
                    ),
                  ),
                  itemCount: data.length,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
