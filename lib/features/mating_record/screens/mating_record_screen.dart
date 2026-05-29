import 'package:flutter/material.dart';
import 'package:gosheep_mobile/core/enums/mating_result_enum.dart';
import 'package:gosheep_mobile/core/utils/format_helper.dart';
import 'package:gosheep_mobile/core/widgets/app_refresh_indicator.dart';
import 'package:gosheep_mobile/core/widgets/async_state_sliver.dart';
import 'package:gosheep_mobile/core/widgets/empty_data.dart';
import 'package:gosheep_mobile/core/widgets/no_connection.dart';
import 'package:gosheep_mobile/core/widgets/stat_card.dart';
import 'package:gosheep_mobile/data/models/mating_record.dart';
import 'package:gosheep_mobile/data/providers/mating_record_provider.dart';
import 'package:gosheep_mobile/data/providers/sheep_stats_provider.dart';
import 'package:gosheep_mobile/features/mating_record/widgets/mating_record_card.dart';
import 'package:gosheep_mobile/features/mating_record/widgets/mating_record_card_skeleton.dart';
import 'package:gosheep_mobile/features/sheep/widgets/filter_pill.dart';
import 'package:provider/provider.dart';

class MatingRecordScreen extends StatelessWidget {
  const MatingRecordScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => MatingRecordProvider()..fetchInitial(),
        ),
        ChangeNotifierProvider(
          create: (_) => SheepStatsProvider()..fetchMatingRecStats(),
        ),
      ],
      child: const _MatingRecordView(),
    );
  }
}

class _MatingRecordView extends StatefulWidget {
  const _MatingRecordView();

  @override
  State<_MatingRecordView> createState() => _MatingRecordViewState();
}

class _MatingRecordViewState extends State<_MatingRecordView> {
  List<MatingRecord> _filteredByResult(List<MatingRecord> list) {
    if (_filter == null) {
      return list;
    }

    return list.where((record) => record.result == _filter).toList();
  }

  final _scrollController = ScrollController();
  MatingResult? _filter;

  @override
  void initState() {
    super.initState();

    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _scrollController
      ..removeListener(_onScroll)
      ..dispose();

    super.dispose();
  }

  void _onScroll() {
    final pos = _scrollController.position;

    if (pos.pixels >= pos.maxScrollExtent - 200) {
      context.read<MatingRecordProvider>().fetchMore();
    }
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<MatingRecordProvider>();
    final recordList = _filteredByResult(provider.matingRecords);

    return Scaffold(
      appBar: AppBar(
        foregroundColor: Colors.white,
        backgroundColor: Theme.of(context).colorScheme.primary,
        centerTitle: true,
        title: const Text(
          'Riwayat Kawin',
          style: TextStyle(fontWeight: FontWeight.w700, fontSize: 18),
        ),
      ),
      body: SafeArea(
        child: AppRefreshIndicator(
          onRefresh: provider.refresh,
          child: CustomScrollView(
            controller: _scrollController,
            slivers: [
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Statistik Hasil Breeding",
                            style: Theme.of(context).textTheme.headlineSmall
                                ?.copyWith(fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(height: 4),
                          const Text(
                            "Pantau hasil perkawinan domba",
                            style: TextStyle(color: Colors.grey, fontSize: 13),
                          ),
                        ],
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
                      final stats = statsProvider.matingRecordStats;
                      final isLoading = statsProvider.isLoading;

                      return Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        spacing: 10,
                        children: [
                          Row(
                            children: [
                              Expanded(
                                child: StatCard(
                                  label: MatingResult.pregnant.label,
                                  value: isLoading
                                      ? '-'
                                      : '${stats?.pregnantTotal ?? '-'}',
                                ),
                              ),

                              const SizedBox(width: 10),

                              Expanded(
                                child: StatCard(
                                  label: MatingResult.unknown.label,
                                  value: isLoading
                                      ? '-'
                                      : '${stats?.unknownTotal ?? '-'}',
                                ),
                              ),
                            ],
                          ),

                          Row(
                            children: [
                              Expanded(
                                child: StatCard(
                                  label: MatingResult.failed.label,
                                  value: isLoading
                                      ? '-'
                                      : '${stats?.failedTotal ?? '-'}',
                                ),
                              ),

                              const SizedBox(width: 10),

                              Expanded(
                                child: StatCard(
                                  label: MatingResult.notPregnant.label,
                                  value: isLoading
                                      ? '-'
                                      : '${stats?.notPregnantTotal ?? '-'}',
                                ),
                              ),
                            ],
                          ),
                        ],
                      );
                    },
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
                          onTap: () {
                            setState(() {
                              _filter = null;
                            });
                          },
                        ),

                        const SizedBox(width: 8),

                        for (final result in MatingResult.values) ...[
                          FilterPill(
                            label: result.label,
                            active: _filter == result,
                            onTap: () {
                              setState(() {
                                _filter = result;
                              });
                            },
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
                    'RIWAYAT BREEDING TERNAK',
                    style: TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w700,
                      color: Colors.black54,
                      letterSpacing: 1.2,
                    ),
                  ),
                ),
              ),

              AsyncStateSliver(
                isLoading: provider.isLoading,
                error: provider.error,
                data: recordList,
                onLoading: () => SliverPadding(
                  padding: const EdgeInsets.fromLTRB(16, 0, 16, 24),
                  sliver: SliverList.builder(
                    itemBuilder: (_, __) => const MatingRecordCardSkeleton(),
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
                    title: 'Belum Ada Data',
                    description: 'Belum ada perkawinan domba',
                  ),
                ),
                onSuccess: (data) => SliverPadding(
                  padding: EdgeInsets.fromLTRB(16, 0, 16, 24),
                  sliver: SliverList.builder(
                    itemBuilder: (_, index) =>
                        MatingRecordCard(matingRecord: data[index]),
                    itemCount: data.length,
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
