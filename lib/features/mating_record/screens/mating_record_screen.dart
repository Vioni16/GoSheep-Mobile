import 'dart:async';

import 'package:flutter/material.dart';
import 'package:gosheep_mobile/core/enums/mating_result_enum.dart';
import 'package:gosheep_mobile/core/widgets/app_banner.dart';
import 'package:gosheep_mobile/core/widgets/app_refresh_indicator.dart';
import 'package:gosheep_mobile/core/widgets/async_state_sliver.dart';
import 'package:gosheep_mobile/core/widgets/empty_data.dart';
import 'package:gosheep_mobile/core/widgets/gender_badge.dart';
import 'package:gosheep_mobile/core/widgets/no_connection.dart';
import 'package:gosheep_mobile/core/widgets/summary_card.dart';
import 'package:gosheep_mobile/data/models/mating_record.dart';
import 'package:gosheep_mobile/core/widgets/pagination_loading_footer.dart';
import 'package:gosheep_mobile/data/providers/mating_record_provider.dart';
import 'package:gosheep_mobile/data/providers/statistic_provider.dart';
import 'package:gosheep_mobile/features/mating_record/widgets/mating_record_card.dart';
import 'package:gosheep_mobile/features/mating_record/widgets/mating_record_card_skeleton.dart';
import 'package:gosheep_mobile/core/widgets/filter_pill.dart';
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
          create: (_) => StatisticProvider()..fetchMatingRecStats(),
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

  final _search = TextEditingController();
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
        context.read<MatingRecordProvider>().searchMatingRec(_search.text);
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
    final provider = context.read<MatingRecordProvider>();
    final pos = _scrollController.position;

    if (pos.maxScrollExtent == 0) return;
    if (provider.error?.isNotEmpty == true) return;

    if (pos.pixels >= pos.maxScrollExtent - 200) {
      provider.fetchMore();
    }
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<MatingRecordProvider>();
    final recordList = _filteredByResult(provider.matingRecords);
    final isSearching = provider.isSearching;

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
            physics: const AlwaysScrollableScrollPhysics(
              parent: BouncingScrollPhysics(),
            ),
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
                  child: Consumer<StatisticProvider>(
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
                                child: SummaryCard(
                                  label: MatingResult.pregnant.label,
                                  value: '${stats?.pregnantTotal ?? '-'}',
                                  isLoading: isLoading,
                                ),
                              ),

                              const SizedBox(width: 10),

                              Expanded(
                                child: SummaryCard(
                                  label: MatingResult.unknown.label,
                                  value: '${stats?.unknownTotal ?? '-'}',
                                  isLoading: isLoading,
                                ),
                              ),
                            ],
                          ),

                          Row(
                            children: [
                              Expanded(
                                child: SummaryCard(
                                  label: MatingResult.failed.label,
                                  value: '${stats?.failedTotal ?? '-'}',
                                  isLoading: isLoading,
                                ),
                              ),

                              const SizedBox(width: 10),

                              Expanded(
                                child: SummaryCard(
                                  label: MatingResult.notPregnant.label,
                                  value: '${stats?.notPregnantTotal ?? '-'}',
                                  isLoading: isLoading,
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

              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(16, 0, 16, 14),
                  child: switch (_filter) {
                    null => const AppBanner(
                      backgroundColor: Colors.black,
                      pillLabel: 'Semua Data',
                      title: 'Seluruh Riwayat\nPerkawinan',
                      subtitle: 'Menampilkan semua catatan breeding domba',
                      decorIcon: Icons.list_alt_rounded,
                    ),
                    MatingResult.pregnant => const AppBanner(
                      backgroundColor: Color(0xFF2E7D52),
                      pillLabel: 'Hasil Positif',
                      title: 'Domba\nBerhasil Bunting',
                      subtitle:
                          'Proses perkawinan berhasil dan domba sedang bunting',
                      decorIcon: Icons.favorite_rounded,
                    ),
                    MatingResult.notPregnant => const AppBanner(
                      backgroundColor: Color(0xFFB8860B),
                      pillLabel: 'Tidak Bunting',
                      title: 'Perkawinan\nTidak Berhasil',
                      subtitle: 'Domba tidak menunjukkan tanda kebuntingan',
                      decorIcon: Icons.close_rounded,
                    ),
                    MatingResult.failed => AppBanner(
                      backgroundColor: Colors.red.shade700,
                      pillLabel: 'Gagal',
                      title: 'Perkawinan\nGagal Dilakukan',
                      subtitle: 'Proses perkawinan tidak dapat diselesaikan',
                      decorIcon: Icons.warning_rounded,
                    ),
                    MatingResult.unknown => const AppBanner(
                      backgroundColor: Color(0xFF546E7A),
                      pillLabel: 'Belum Diketahui',
                      title: 'Hasil Masih\nDalam Pemantauan',
                      subtitle: 'Hasil perkawinan belum dapat dipastikan',
                      decorIcon: Icons.hourglass_empty_rounded,
                    ),
                  },
                ),
              ),

              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(16, 0, 16, 12),
                  child: Row(
                    children: [
                      const Expanded(
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
                      GenderBadge(gender: 'male'),
                      const SizedBox(width: 4),
                      const Text(
                        'Jantan',
                        style: TextStyle(fontSize: 11, color: Colors.black54),
                      ),
                      const SizedBox(width: 10),
                      GenderBadge(gender: 'female'),
                      const SizedBox(width: 4),
                      const Text(
                        'Betina',
                        style: TextStyle(fontSize: 11, color: Colors.black54),
                      ),
                    ],
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
                  child: NoConnection(
                    onRetry: [
                      provider.refresh,
                      () => context
                          .read<StatisticProvider>()
                          .fetchMatingRecStats(),
                    ],
                    description: err,
                  ),
                ),
                onEmpty: () => SliverToBoxAdapter(
                  child: EmptyData(
                    title: isSearching
                        ? 'Riwayat Tidak Ditemukan'
                        : 'Riwayat Perkawinan Kosong',
                    description: isSearching
                        ? 'Tidak ada domba dengan Eartag tersebut'
                        : ' Yuk, tambahkan catatan perkawinan pertamamu!',
                  ),
                ),
                onSuccess: (data) => SliverPadding(
                  padding: const EdgeInsets.fromLTRB(16, 0, 16, 24),
                  sliver: SliverList.builder(
                    itemBuilder: (_, index) {
                      if (index == data.length) {
                        return PaginationLoadingFooter(hasMore: provider.hasMore);
                      }
                      return MatingRecordCard(matingRecord: data[index]);
                    },
                    itemCount: data.length + 1,
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
