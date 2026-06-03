import 'package:flutter/material.dart';
import 'package:gosheep_mobile/core/utils/format_helper.dart';
import 'package:gosheep_mobile/core/widgets/app_banner.dart';
import 'package:gosheep_mobile/core/widgets/app_refresh_indicator.dart';
import 'package:gosheep_mobile/core/widgets/async_state_sliver.dart';
import 'package:gosheep_mobile/core/widgets/empty_data.dart';
import 'package:gosheep_mobile/core/widgets/filter_pill.dart';
import 'package:gosheep_mobile/core/widgets/gender_badge.dart';
import 'package:gosheep_mobile/core/widgets/no_connection.dart';
import 'package:gosheep_mobile/data/models/health.dart';
import 'package:gosheep_mobile/data/providers/health_record_provider.dart';
import 'package:gosheep_mobile/features/health_record/widgets/add_health_sheet.dart';
import 'package:gosheep_mobile/features/health_record/widgets/health_record_card.dart';
import 'package:gosheep_mobile/features/health_record/widgets/health_overview_card_skeleton.dart';
import 'package:provider/provider.dart';

class HealthRecordScreen extends StatelessWidget {
  final int id;
  final String earTag;
  final String gender;

  const HealthRecordScreen({
    super.key,
    required this.id,
    required this.earTag,
    required this.gender,
  });

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => HealthRecordProvider(id)..fetchInitial(),
      child: _HealthRecordScreenView(earTag: earTag, gender: gender),
    );
  }
}

class _HealthRecordScreenView extends StatefulWidget {
  final String earTag;
  final String gender;

  const _HealthRecordScreenView({required this.earTag, required this.gender});

  @override
  State<_HealthRecordScreenView> createState() =>
      _HealthRecordScreenViewState();
}

class _HealthRecordScreenViewState extends State<_HealthRecordScreenView> {
  final _scrollController = ScrollController();

  String _filter = 'all';

  static const Map<String, List<String>> severityGroup = {
    'safe': ['normal'],
    'warning': ['ringan', 'sedang'],
    'critical': ['berat'],
  };

  List<Health> _filtered(List<Health> list) {
    if (_filter == 'all') return list;
    final allowed = severityGroup[_filter] ?? [];
    return list.where((e) => allowed.contains(e.severity)).toList();
  }

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
  }

  void _onScroll() {
    final provider = context.read<HealthRecordProvider>();
    final pos = _scrollController.position;

    if (pos.maxScrollExtent == 0) return;
    if (provider.error?.isNotEmpty == true) return;
    if (provider.healthRecords.isEmpty) return;

    if (pos.pixels >= pos.maxScrollExtent - 200) {
      provider.fetchMore();
    }
  }

  void _openAdd() => showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    builder: (_) {
      return MultiProvider(
        providers: [
          ChangeNotifierProvider.value(
            value: context.read<HealthRecordProvider>(),
          ),
        ],
        child: const AddHealthSheet(),
      );
    },
  );

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<HealthRecordProvider>();
    final data = _filtered(provider.healthRecords);

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
                'Riwayat Kesehatan',
                style: TextStyle(fontWeight: FontWeight.w700, fontSize: 18),
              ),
            ),

            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(16, 16, 16, 16),
                child: Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Text(
                                widget.earTag,
                                style: const TextStyle(
                                  fontSize: 22,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                              const SizedBox(width: 8),
                              GenderBadge(gender: widget.gender),
                            ],
                          ),
                          const SizedBox(height: 4),
                          Text(
                            'Seluruh riwayat kondisi kesehatan',
                            style: TextStyle(
                              color: Colors.grey.shade600,
                              fontSize: 13,
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
                              'Rekam Medis',
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

            const SliverToBoxAdapter(
              child: Padding(
                padding: EdgeInsets.fromLTRB(16, 0, 16, 12),
                child: Text(
                  'RIWAYAT KESEHATAN',
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
                    title: 'Semua Riwayat Kesehatan',
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
              onError: (err) =>
                  SliverToBoxAdapter(child: NoConnection(description: err)),
              onEmpty: () => SliverToBoxAdapter(
                child: EmptyData(
                  title: _filter == 'all'
                      ? 'Belum Ada Riwayat'
                      : 'Tidak Ada Data',
                  description: _filter == 'all'
                      ? 'Belum ada catatan kesehatan untuk domba ini'
                      : 'Tidak ada catatan dengan kondisi ini',
                ),
              ),
              onSuccess: (data) => SliverPadding(
                padding: const EdgeInsets.fromLTRB(16, 0, 16, 24),
                sliver: SliverList.builder(
                  itemCount: data.length,
                  itemBuilder: (_, i) => HealthRecordCard(health: data[i]),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
