import 'dart:async';

import 'package:flutter/material.dart';
import 'package:gosheep_mobile/core/widgets/app_banner.dart';
import 'package:gosheep_mobile/core/widgets/app_refresh_indicator.dart';
import 'package:gosheep_mobile/core/widgets/async_state_sliver.dart';
import 'package:gosheep_mobile/core/widgets/empty_data.dart';
import 'package:gosheep_mobile/core/widgets/filter_pill.dart';
import 'package:gosheep_mobile/core/widgets/no_connection.dart';
import 'package:gosheep_mobile/core/widgets/pagination_loading_footer.dart';
import 'package:gosheep_mobile/core/widgets/summary_card.dart';
import 'package:gosheep_mobile/data/models/inactive_sheep.dart';
import 'package:gosheep_mobile/data/providers/inactive_sheep_provider.dart';
import 'package:gosheep_mobile/features/sheep/widgets/sheep_card_skeleton.dart';
import 'package:provider/provider.dart';
import '../widgets/inactive_sheep_card.dart';

class InactiveSheepScreen extends StatelessWidget {
  const InactiveSheepScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => InactiveSheepProvider()..fetchInitial(),
        ),
      ],
      child: const _InactiveSheepView(),
    );
  }
}

class _InactiveSheepView extends StatefulWidget {
  const _InactiveSheepView();

  @override
  State<_InactiveSheepView> createState() => _InactiveSheepViewState();
}

class _InactiveSheepViewState extends State<_InactiveSheepView> {
  String _activeFilter = 'all';
  final _searchController = TextEditingController();
  final _scrollController = ScrollController();
  Timer? _debounce;

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
    _searchController.addListener(_onSearchChanged);
  }

  @override
  void dispose() {
    _debounce?.cancel();
    _scrollController.removeListener(_onScroll);
    _scrollController.dispose();
    _searchController.dispose();
    super.dispose();
  }

  void _onScroll() {
    final provider = context.read<InactiveSheepProvider>();
    final pos = _scrollController.position;

    if (pos.maxScrollExtent == 0) return;
    if (provider.error?.isNotEmpty == true) return;
    if (provider.inactiveSheepList.isEmpty) return;

    if (pos.pixels >= pos.maxScrollExtent - 200) {
      provider.fetchMore();
    }
  }

  void _onSearchChanged() {
    if (_debounce?.isActive ?? false) {
      _debounce!.cancel();
    }
    _debounce = Timer(const Duration(milliseconds: 300), () {
      context.read<InactiveSheepProvider>().searchInactiveSheep(
        _searchController.text,
      );
    });
  }

  List<InactiveSheep> _filteredByStatus(List<InactiveSheep> list) {
    if (_activeFilter == 'all') {
      return list;
    }
    return list.where((sheep) => sheep.status.name == _activeFilter).toList();
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<InactiveSheepProvider>();
    final filteredList = _filteredByStatus(provider.inactiveSheepList);
    final isSearching = provider.isSearching;

    final showPlaceholder =
        provider.isLoading && provider.inactiveSheepList.isEmpty;

    return Scaffold(
      backgroundColor: const Color(0xFFF5F4F0),
      appBar: AppBar(
        foregroundColor: Colors.white,
        backgroundColor: Theme.of(context).colorScheme.primary,
        centerTitle: true,
        title: const Text(
          'Ternak Nonaktif',
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
                        'Statistik Domba Nonaktif',
                        style: Theme.of(context).textTheme.headlineSmall
                            ?.copyWith(fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 4),
                      const Text(
                        'Pantau domba yang sudah dijual, mati, atau tidak aktif lagi.',
                        style: TextStyle(color: Colors.grey, fontSize: 13),
                      ),
                    ],
                  ),
                ),
              ),

              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(16, 0, 16, 0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            child: SummaryCard(
                              label: 'Dijual',
                              value: showPlaceholder
                                  ? '-'
                                  : '${provider.soldCount}',
                            ),
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                            child: SummaryCard(
                              label: 'Mati',
                              value: showPlaceholder
                                  ? '-'
                                  : '${provider.deadCount}',
                            ),
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                            child: SummaryCard(
                              label: 'Nonaktif',
                              value: showPlaceholder
                                  ? '-'
                                  : '${provider.inactiveCount}',
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Padding(
                        padding: const EdgeInsets.only(left: 4),
                        child: Text(
                          '* Kategori Nonaktif termasuk ternak yang terlalu tua, tidak produktif.',
                          style: TextStyle(
                            fontSize: 11,
                            color: Colors.grey.shade600,
                            fontStyle: FontStyle.italic,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(16, 10, 16, 0),
                  child: SearchBar(
                    controller: _searchController,
                    hintText: 'Cari Eartag domba...',
                    leading: const Icon(Icons.search_rounded),
                    elevation: const WidgetStatePropertyAll(0),
                    backgroundColor: const WidgetStatePropertyAll(Colors.white),
                    shape: WidgetStatePropertyAll(
                      RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    trailing: [
                      if (_searchController.text.isNotEmpty)
                        IconButton(
                          icon: const Icon(Icons.close),
                          onPressed: () {
                            _searchController.clear();
                          },
                        ),
                    ],
                  ),
                ),
              ),

              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(16, 12, 16, 0),
                  child: SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: [
                        FilterPill(
                          label: 'Semua',
                          active: _activeFilter == 'all',
                          onTap: () => setState(() => _activeFilter == 'all'),
                        ),
                        const SizedBox(width: 8),
                        FilterPill(
                          label: 'Dijual',
                          active: _activeFilter == 'sold',
                          onTap: () => setState(() => _activeFilter == 'sold'),
                        ),
                        const SizedBox(width: 8),
                        FilterPill(
                          label: 'Mati',
                          active: _activeFilter == 'dead',
                          onTap: () => setState(() => _activeFilter == 'dead'),
                        ),
                        const SizedBox(width: 8),
                        FilterPill(
                          label: 'Nonaktif',
                          active: _activeFilter == 'inactive',
                          onTap: () =>
                              setState(() => _activeFilter == 'inactive'),
                        ),
                      ],
                    ),
                  ),
                ),
              ),

              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(16, 16, 16, 14),
                  child: switch (_activeFilter) {
                    'all' => const AppBanner(
                      backgroundColor: Colors.black,
                      pillLabel: 'Tidak aktif',
                      title: 'Seluruh riwayat',
                      subtitle: 'Domba dijual, mati, atau sudah nonaktif',
                      decorIcon: Icons.history_rounded,
                    ),
                    'sold' => const AppBanner(
                      backgroundColor: Color(0xFF0F5132),
                      pillLabel: 'Sudah dijual',
                      title: 'Domba dijual',
                      subtitle: 'Tercatat sudah berpindah kepemilikan',
                      decorIcon: Icons.sell_rounded,
                    ),
                    'dead' => const AppBanner(
                      backgroundColor: Color(0xFFB71C1C),
                      pillLabel: 'Sudah mati',
                      title: 'Domba mati',
                      subtitle: 'Catatan domba yang tidak lagi hidup',
                      decorIcon: Icons.heart_broken_rounded,
                    ),
                    'inactive' => const AppBanner(
                      backgroundColor: Color(0xFFB8860B),
                      pillLabel: 'Nonaktif',
                      title: 'Domba nonaktif',
                      subtitle: 'Terlalu tua atau tidak lagi produktif',
                      decorIcon: Icons.do_not_disturb_on_rounded,
                    ),
                    _ => const SizedBox.shrink(),
                  },
                ),
              ),

              const SliverToBoxAdapter(
                child: Padding(
                  padding: EdgeInsets.fromLTRB(16, 0, 16, 12),
                  child: Text(
                    'DATA TERNAK NONAKTIF',
                    style: TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w700,
                      color: Colors.black54,
                      letterSpacing: 1.2,
                    ),
                  ),
                ),
              ),

              AsyncStateSliver<InactiveSheep>(
                isLoading: provider.isLoading,
                error: provider.error,
                data: filteredList,
                onLoading: () => SliverPadding(
                  padding: const EdgeInsets.fromLTRB(16, 0, 16, 24),
                  sliver: SliverList.builder(
                    itemBuilder: (_, __) => const SheepCardSkeleton(),
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
                        ? 'Domba Tidak Ditemukan'
                        : 'Tidak Ada Domba Nonaktif',
                    description: isSearching
                        ? 'Tidak ada domba nonaktif dengan Eartag tersebut'
                        : 'Belum ada data riwayat domba nonaktif.',
                  ),
                ),
                onSuccess: (data) => SliverPadding(
                  padding: const EdgeInsets.fromLTRB(16, 0, 16, 32),
                  sliver: SliverList.builder(
                    itemBuilder: (context, index) {
                      if (index == data.length) {
                        return PaginationLoadingFooter(
                          hasMore: provider.hasMore,
                        );
                      }
                      return InactiveSheepCard(sheep: data[index]);
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
