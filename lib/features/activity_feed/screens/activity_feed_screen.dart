import 'package:flutter/material.dart';
import 'package:gosheep_mobile/core/widgets/app_banner.dart';
import 'package:gosheep_mobile/core/widgets/app_refresh_indicator.dart';
import 'package:gosheep_mobile/core/widgets/async_state_sliver.dart';
import 'package:gosheep_mobile/core/widgets/empty_data.dart';
import 'package:gosheep_mobile/core/widgets/no_connection.dart';
import 'package:gosheep_mobile/core/widgets/pagination_loading_footer.dart';
import 'package:gosheep_mobile/core/widgets/toast_widget.dart';
import 'package:gosheep_mobile/data/models/activity_feed.dart';
import 'package:gosheep_mobile/data/providers/activity_feed_provider.dart';
import 'package:gosheep_mobile/features/activity_feed/widgets/activity_feed_card.dart';
import 'package:gosheep_mobile/features/health_record/screens/health_record_screen.dart';
import 'package:gosheep_mobile/features/sheep/screens/sheep_detail_screen.dart';
import 'package:gosheep_mobile/data/services/mating_record_service.dart';
import 'package:gosheep_mobile/features/mating_record/screens/mating_check_screen.dart';
import 'package:gosheep_mobile/features/weight_record/screens/weight_record_screen.dart';
import 'package:provider/provider.dart';

class ActivityFeedScreen extends StatelessWidget {
  const ActivityFeedScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => ActivityFeedProvider()..fetchInitial(),
      child: const _ActivityFeedScreenView(),
    );
  }
}

class _ActivityFeedScreenView extends StatefulWidget {
  const _ActivityFeedScreenView();

  @override
  State<_ActivityFeedScreenView> createState() =>
      _ActivityFeedScreenViewState();
}

class _ActivityFeedScreenViewState extends State<_ActivityFeedScreenView> {
  final _scrollController = ScrollController();

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
    final provider = context.read<ActivityFeedProvider>();
    final pos = _scrollController.position;

    if (pos.maxScrollExtent == 0) return;
    if (provider.error?.isNotEmpty == true) return;
    if (provider.feeds.isEmpty) return;

    if (pos.pixels >= pos.maxScrollExtent - 200) {
      provider.fetchMore();
    }
  }

  Future<void> _navigateFromActivity(ActivityFeed activity) async {
    if (!activity.canNavigate) return;

    switch (activity.entity) {
      case 'sheep':
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => SheepDetailScreen(id: activity.loggableId),
          ),
        );
      case 'health_record':
        final props = activity.properties;
        final sheepId = props is CreatedProperties
            ? int.tryParse(props.get('sheep_id') ?? '')
            : null;
        final eartag = props is CreatedProperties
            ? (props.get('sheep_eartag') ?? '-')
            : '-';
        final gender = props is CreatedProperties
            ? (props.get('sheep_gender') ?? '-')
            : '-';

        if (sheepId == null) return;

        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => HealthRecordScreen(
              sheepId: sheepId,
              earTag: eartag,
              gender: gender,
            ),
          ),
        );

      case 'weight_record':
        final props = activity.properties;
        final sheepId = props is CreatedProperties
            ? int.tryParse(props.get('sheep_id') ?? '')
            : null;
        final eartag = props is CreatedProperties
            ? (props.get('sheep_eartag') ?? '-')
            : '-';
        final gender = props is CreatedProperties
            ? (props.get('sheep_gender') ?? '-')
            : '-';

        if (sheepId == null) return;

        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => WeightRecordScreen(
              sheepId: sheepId,
              earTag: eartag,
              gender: gender,
            ),
          ),
        );

      case 'mating_check':
        final props = activity.properties;
        final matingRecordId = props is CreatedProperties
            ? int.tryParse(props.get('mating_record_id') ?? '')
            : null;
        if (matingRecordId == null) return;

        showDialog(
          context: context,
          barrierDismissible: false,
          builder: (_) => const Center(child: CircularProgressIndicator()),
        );

        try {
          final matingRecord = await MatingRecordService().getMatingRecordById(
            matingRecordId,
          );
          if (!mounted) return;
          Navigator.pop(context);

          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => MatingCheckScreen(
                matingRecordId: matingRecord.id,
                ramEarTag: matingRecord.ramEarTag,
                eweEarTag: matingRecord.eweEarTag,
                result: matingRecord.result,
              ),
            ),
          );
        } catch (e) {
          if (mounted) {
            Navigator.pop(context);
            ToastService.show(
              context,
              'Gagal mengambil data perkawinan.',
              title: 'Terjadi Kesalahan',
            );
          }
        }
    }
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<ActivityFeedProvider>();

    return Scaffold(
      body: AppRefreshIndicator(
        onRefresh: provider.refresh,
        child: CustomScrollView(
          controller: _scrollController,
          physics: const AlwaysScrollableScrollPhysics(
            parent: BouncingScrollPhysics(),
          ),
          slivers: [
            SliverAppBar(
              pinned: true,
              expandedHeight: 60,
              centerTitle: true,
              backgroundColor: Theme.of(context).colorScheme.primary,
              foregroundColor: Colors.white,
              title: const Text(
                'Activity Feed',
                style: TextStyle(fontWeight: FontWeight.w700, fontSize: 18),
              ),
            ),

            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(16, 16, 16, 14),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Aktivitas',
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      'Seluruh aktivitas terkini di peternakan',
                      style: TextStyle(
                        fontSize: 13,
                        color: Colors.grey.shade500,
                      ),
                    ),
                    const SizedBox(height: 12),
                    const AppBanner(
                      backgroundColor: Color(0xFF1B5E20),
                      pillLabel: 'Live Feed',
                      title: 'Semua Aktivitas Tercatat Di Sini',
                      subtitle:
                          'Pantau Perubahan Data Domba, Kandang, Kesehatan, dan Aktivitas Lainnya',
                      decorIcon: Icons.feed_sharp,
                    ),
                  ],
                ),
              ),
            ),

            const SliverToBoxAdapter(
              child: Padding(
                padding: EdgeInsets.fromLTRB(16, 0, 16, 12),
                child: Text(
                  'AKTIVITAS TERKINI',
                  style: TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w700,
                    color: Colors.black54,
                    letterSpacing: 1.2,
                  ),
                ),
              ),
            ),

            AsyncStateSliver<ActivityFeed>(
              isLoading: provider.isLoading,
              error: provider.error,
              data: provider.feeds,
              onLoading: () => const SliverPadding(
                padding: EdgeInsets.fromLTRB(16, 0, 16, 24),
                sliver: _FeedSkeleton(),
              ),
              onError: (err) => SliverToBoxAdapter(
                child: NoConnection(
                  onRetry: [provider.refresh],
                  description: err,
                ),
              ),
              onEmpty: () => const SliverToBoxAdapter(
                child: EmptyData(
                  title: 'Belum Ada Aktivitas',
                  description: 'Aktivitas akan muncul saat ada perubahan data',
                ),
              ),
              onSuccess: (_) {
                final grouped = provider.groupedFeeds;
                final dateKeys = grouped.keys.toList();

                return SliverPadding(
                  padding: const EdgeInsets.fromLTRB(16, 0, 16, 24),
                  sliver: SliverList.builder(
                    itemCount: dateKeys.length + 1,
                    itemBuilder: (_, i) {
                      if (i == dateKeys.length) {
                        return PaginationLoadingFooter(
                          hasMore: provider.hasMore,
                        );
                      }
                      final key = dateKeys[i];
                      final items = grouped[key]!;
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _DateSeparator(label: key),
                          const SizedBox(height: 12),
                          ...items.map(
                            (activity) => ActivityFeedCard(
                              activity: activity,
                              onTap: () => _navigateFromActivity(activity),
                            ),
                          ),
                        ],
                      );
                    },
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}

class _DateSeparator extends StatelessWidget {
  final String label;
  const _DateSeparator({required this.label});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Text(
          label.toUpperCase(),
          style: const TextStyle(
            fontSize: 10,
            fontWeight: FontWeight.w700,
            color: Colors.black38,
            letterSpacing: 0.8,
          ),
        ),
        const SizedBox(width: 8),
        Expanded(child: Divider(color: Colors.grey.shade200, height: 1)),
      ],
    );
  }
}

class _FeedSkeleton extends StatelessWidget {
  const _FeedSkeleton();

  @override
  Widget build(BuildContext context) {
    return SliverList.builder(
      itemCount: 6,
      itemBuilder: (_, i) => Padding(
        padding: const EdgeInsets.only(bottom: 20),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: 32,
              height: 32,
              decoration: BoxDecoration(
                color: Colors.grey.shade200,
                shape: BoxShape.circle,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: 80,
                    height: 18,
                    decoration: BoxDecoration(
                      color: Colors.grey.shade200,
                      borderRadius: BorderRadius.circular(20),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Container(
                    width: double.infinity,
                    height: 13,
                    decoration: BoxDecoration(
                      color: Colors.grey.shade200,
                      borderRadius: BorderRadius.circular(6),
                    ),
                  ),
                  const SizedBox(height: 6),
                  Container(
                    width: double.infinity,
                    height: 44,
                    decoration: BoxDecoration(
                      color: Colors.grey.shade100,
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  const SizedBox(height: 6),
                  Container(
                    width: 120,
                    height: 11,
                    decoration: BoxDecoration(
                      color: Colors.grey.shade200,
                      borderRadius: BorderRadius.circular(6),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
