import 'dart:async';

import 'package:flutter/material.dart';
import 'package:gosheep_mobile/core/widgets/app_banner.dart';
import 'package:gosheep_mobile/core/widgets/async_state_sliver.dart';
import 'package:gosheep_mobile/core/widgets/empty_data.dart';
import 'package:gosheep_mobile/core/widgets/no_connection.dart';
import 'package:gosheep_mobile/data/providers/statistic_provider.dart';
import 'package:gosheep_mobile/data/providers/weight_provider.dart';
import 'package:gosheep_mobile/features/health_record/widgets/health_overview_card_skeleton.dart';
import 'package:gosheep_mobile/features/weight_record/widgets/weight_card.dart';
import 'package:gosheep_mobile/features/weight_record/widgets/weight_chart_card.dart';
import 'package:provider/provider.dart';

class WeightScreen extends StatelessWidget {
  const WeightScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => WeightProvider()..fetchInitial()),
        ChangeNotifierProvider(
          create: (_) => StatisticProvider()..fetchAllWeightStatistics(),
        ),
      ],
      child: const _WeightScreenView(),
    );
  }
}

class _WeightScreenView extends StatefulWidget {
  const _WeightScreenView();

  @override
  State<_WeightScreenView> createState() => _WeightScreenViewState();
}

class _WeightScreenViewState extends State<_WeightScreenView> {
  final _scrollController = ScrollController();
  final _search = TextEditingController();

  Timer? _debounce;
  late int _selectedYear;

  @override
  void initState() {
    super.initState();
    _selectedYear = DateTime.now().year;

    _scrollController.addListener(_onScroll);

    _search.addListener(() {
      if (_debounce?.isActive ?? false) _debounce!.cancel();

      _debounce = Timer(const Duration(milliseconds: 300), () {
        context.read<WeightProvider>().search(_search.text);
      });
    });
  }

  void _onScroll() {
    final provider = context.read<WeightProvider>();
    final pos = _scrollController.position;

    if (pos.maxScrollExtent == 0) return;
    if (provider.error?.isNotEmpty == true) return;
    if (provider.weights.isEmpty) return;

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

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<WeightProvider>();
    final isSearching = provider.isSearching;
    final data = provider.weights;

    return Scaffold(
      appBar: AppBar(
        foregroundColor: Colors.white,
        backgroundColor: Theme.of(context).colorScheme.primary,
        centerTitle: true,
        title: const Text(
          'Berat Badan Domba',
          style: TextStyle(fontWeight: FontWeight.w700, fontSize: 18),
        ),
      ),
      body: CustomScrollView(
        controller: _scrollController,
        physics: const AlwaysScrollableScrollPhysics(),
        slivers: [
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Pantau Berat Badan Dombamu',
                    style: TextStyle(fontSize: 22, fontWeight: FontWeight.w700),
                  ),
                  const SizedBox(height: 4),
                  const Text(
                    'Catat dan pantau berat badan dombamu secara rutin untuk memastikan kesehatannya tetap optimal.',
                    style: TextStyle(color: Colors.grey),
                  ),

                  const SizedBox(height: 16),
                  Consumer<StatisticProvider>(
                    builder: (context, statProvider, _) => WeightChart(
                      statistic: statProvider.weightStatistic,
                      selectedYear: _selectedYear,
                      isLoading: provider.isLoading,
                      onYearChanged: (year) {
                        setState(() => _selectedYear = year);
                        context
                            .read<StatisticProvider>()
                            .fetchAllWeightStatistics(year: year);
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),

          const SliverToBoxAdapter(
            child: Padding(
              padding: EdgeInsets.fromLTRB(16, 0, 16, 12),
              child: Text(
                'BERAT BADAN DOMBA',
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
              padding: const EdgeInsets.fromLTRB(16, 0, 16, 12),
              child: AppBanner(
                backgroundColor: Theme.of(context).colorScheme.primary,
                pillLabel: 'Semua Data',
                title: 'Semua Data Berat Badan Domba Tersedia di Sini',
                subtitle: 'Menampilkan seluruh catatan berat badan domba',
                decorIcon: Icons.list_alt_rounded,
              ),
            ),
          ),

          AsyncStateSliver(
            isLoading: provider.isLoading,
            error: provider.error,
            data: data,
            onError: (err) => SliverToBoxAdapter(
              child: NoConnection(
                description: err,
                onRetry: [
                  provider.refresh,
                  () => context
                      .read<StatisticProvider>()
                      .refreshAllWeightStatistics(year: _selectedYear),
                ],
              ),
            ),
            onLoading: () => SliverPadding(
              padding: const EdgeInsets.fromLTRB(16, 0, 16, 24),
              sliver: SliverList.builder(
                itemBuilder: (_, __) => const HealthOverviewCardSkeleton(),
                itemCount: 6,
              ),
            ),
            onEmpty: () => SliverToBoxAdapter(
              child: EmptyData(
                title: isSearching
                    ? 'Domba Tidak Ditemukan'
                    : 'Catatan Berat Badan Belum Tersedia',
                description: isSearching
                    ? 'Tidak ada domba dengan Eartag tersebut'
                    : 'Tambahkan domba dan pantau berat badan secara rutin',
              ),
            ),
            onSuccess: (data) => SliverPadding(
              padding: const EdgeInsets.fromLTRB(16, 0, 16, 24),
              sliver: SliverList.builder(
                itemCount: data.length,
                itemBuilder: (_, i) => WeightCard(sheepWeightOverview: data[i]),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
