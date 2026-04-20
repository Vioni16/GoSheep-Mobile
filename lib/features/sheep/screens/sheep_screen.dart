import 'package:flutter/material.dart';
import 'package:gosheep_mobile/core/utils/format_helper.dart';
import 'package:gosheep_mobile/core/widgets/app_refresh_indicator.dart';
import 'package:gosheep_mobile/core/widgets/async_state_sliver.dart';
import 'package:gosheep_mobile/core/widgets/empty_data.dart';
import 'package:gosheep_mobile/core/widgets/no_connection.dart';
import 'package:gosheep_mobile/core/widgets/toast_widget.dart';
import 'package:gosheep_mobile/data/providers/sheep_stats_provider.dart';
import 'package:gosheep_mobile/features/sheep/screens/sheep_detail_screen.dart';
import 'package:provider/provider.dart';
import 'package:gosheep_mobile/features/sheep/widgets/add_sheep_sheet.dart';
import 'package:gosheep_mobile/features/sheep/widgets/filter_pill.dart';
import 'package:gosheep_mobile/features/sheep/widgets/sheep_card.dart';
import 'package:gosheep_mobile/features/sheep/widgets/stat_card.dart';

import '../../../data/models/sheep.dart';
import '../../../data/providers/sheep_provider.dart';
import '../widgets/sheep_card_skeleton.dart';

const _breedList = ['Merino', 'Garut', 'Texel', 'Dorper', 'Suffolk'];

class SheepScreen extends StatelessWidget {
  const SheepScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => SheepProvider()..fetchInitial(),
        ),
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
  final _search = TextEditingController();
  final _scrollController = ScrollController();

  String _filter = 'all';

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
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
    if (pos.pixels >= pos.maxScrollExtent - 200) {
      context.read<SheepProvider>().fetchMore();
    }
  }

  List<Sheep> _filtered(List<Sheep> list) {
    final q = _search.text.toLowerCase();
    return list.where((s) {
      final matchStatus = _filter == 'all' || s.statusUi == _filter;
      final matchQuery = q.isEmpty || s.earTag.toLowerCase().contains(q);
      return matchStatus && matchQuery;
    }).toList();
  }

  void _openAdd() => showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    builder: (_) => AddSheepSheet(breedList: _breedList, onAdd: () {}),
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
    final sheepList = _filtered(provider.sheepList);

    return SafeArea(
      child: AppRefreshIndicator(
        onRefresh: provider.refresh,
        child: CustomScrollView(
          controller: _scrollController,
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
                    final atRisk = stats?.atRiskTotal ?? 0;
                    final sick = stats?.sickTotal ?? 0;

                    return Row(
                      children: [
                        StatCard(
                          label: 'Sehat',
                          value: isLoading ? '-' : '$healthy',
                          valueColor: const Color(0xFF3B6D11),
                        ),
                        const SizedBox(width: 10),
                        StatCard(
                          label: 'Berisiko',
                          value: isLoading ? '-' : '$atRisk',
                          valueColor: const Color(0xFFF5D48A),
                        ),
                        const SizedBox(width: 10),
                        StatCard(
                          label: 'Sakit',
                          value: isLoading ? '-' : '$sick',
                          valueColor: const Color(0xFFA32D2D),
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
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Row(
                    children: [
                      const Icon(Icons.search_rounded, size: 18),
                      const SizedBox(width: 8),
                      Expanded(
                        child: TextField(
                          controller: _search,
                          onChanged: (_) => setState(() {}),
                          decoration: const InputDecoration(
                            hintText: 'Cari ID domba...',
                            border: InputBorder.none,
                          ),
                        ),
                      ),
                    ],
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
                        ('Berisiko', 'at_risk'),
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
                    : EmptyData(),
              ),
              onEmpty: () => const SliverToBoxAdapter(
                child: EmptyData(description: 'Belum ada domba yang terdaftar'),
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