import 'package:flutter/material.dart';
import 'package:gosheep_mobile/core/utils/validators.dart';
import 'package:gosheep_mobile/core/widgets/app_refresh_indicator.dart';
import 'package:gosheep_mobile/core/widgets/async_state_sliver.dart';
import 'package:gosheep_mobile/core/widgets/custom_textfield.dart';
import 'package:gosheep_mobile/core/widgets/empty_data.dart';
import 'package:gosheep_mobile/core/widgets/gender_badge.dart';
import 'package:gosheep_mobile/core/widgets/no_connection.dart';
import 'package:gosheep_mobile/core/widgets/toast_widget.dart';
import 'package:gosheep_mobile/data/providers/statistic_provider.dart';
import 'package:gosheep_mobile/data/providers/weight_record_provider.dart';
import 'package:gosheep_mobile/features/health_record/widgets/health_overview_card_skeleton.dart';
import 'package:gosheep_mobile/features/weight_record/widgets/weight_chart_card.dart';
import 'package:gosheep_mobile/features/weight_record/widgets/weight_record_card.dart';
import 'package:gosheep_mobile/core/widgets/pagination_loading_footer.dart';
import 'package:provider/provider.dart';

class WeightRecordScreen extends StatelessWidget {
  final int sheepId;
  final String earTag;
  final String gender;

  const WeightRecordScreen({
    super.key,
    required this.sheepId,
    required this.earTag,
    required this.gender,
  });

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => WeightRecordProvider(sheepId)..fetchInitial(),
        ),
        ChangeNotifierProvider(
          create: (_) =>
              StatisticProvider()
                ..fetchMonthlyWeightStatistics(sheepId: sheepId),
        ),
      ],
      child: _WeightRecordScreenView(
        sheepId: sheepId,
        earTag: earTag,
        gender: gender,
      ),
    );
  }
}

class _WeightRecordScreenView extends StatefulWidget {
  final int sheepId;
  final String earTag;
  final String gender;

  const _WeightRecordScreenView({
    required this.sheepId,
    required this.earTag,
    required this.gender,
  });

  @override
  State<_WeightRecordScreenView> createState() =>
      _WeightRecordScreenViewState();
}

class _WeightRecordScreenViewState extends State<_WeightRecordScreenView> {
  final _scrollController = ScrollController();
  final _formKey = GlobalKey<FormState>();
  final _weightController = TextEditingController();

  late int _selectedYear;

  @override
  void initState() {
    super.initState();
    _selectedYear = DateTime.now().year;
    _scrollController.addListener(_onScroll);
  }

  void _onScroll() {
    final provider = context.read<WeightRecordProvider>();
    final pos = _scrollController.position;

    if (pos.maxScrollExtent == 0) return;
    if (provider.error?.isNotEmpty == true) return;
    if (provider.weightRecords.isEmpty) return;

    if (pos.pixels >= pos.maxScrollExtent - 200) {
      provider.fetchMore();
    }
  }

  Future<void> _submit(BuildContext context) async {
    if (!_formKey.currentState!.validate()) return;

    final provider = context.read<WeightRecordProvider>();

    final success = await provider.createWeightRecord(
      weight: double.parse(_weightController.text.trim()),
    );

    if (!mounted) return;

    if (success) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (!mounted) return;
        _weightController.clear();
        context.read<StatisticProvider>().refreshMonthlyWeightStatistics(
          sheepId: widget.sheepId,
        );
      });

      ToastService.show(
        context,
        provider.message,
        title: 'Berhasil!',
        type: ToastType.success,
      );

      return;
    }

    ToastService.show(
      context,
      provider.error ?? 'Gagal mencatat berat badan',
      title: 'Gagal!',
      type: ToastType.error,
    );
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _weightController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<WeightRecordProvider>();
    final data = provider.weightRecords;

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
                'Riwayat Berat Badan',
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
                            'Seluruh riwayat berat badan domba',
                            style: TextStyle(
                              color: Colors.grey.shade600,
                              fontSize: 13,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),

            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
                child: Material(
                  child: Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(14),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.04),
                          blurRadius: 8,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Form(
                      key: _formKey,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Catat Berat Badan',
                            style: TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            'Masukkan berat badan domba dalam satuan kilogram',
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.grey.shade500,
                            ),
                          ),
                          const SizedBox(height: 14),
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Expanded(
                                child: CustomTextFormField(
                                  controller: _weightController,
                                  icon: Icons.monitor_weight_outlined,
                                  hint: 'Contoh: 45.5',
                                  keyboardType:
                                      const TextInputType.numberWithOptions(
                                        decimal: true,
                                      ),
                                  validator: Validators.weight,
                                ),
                              ),
                              const SizedBox(width: 10),
                              SizedBox(
                                height: 48,
                                width: 52,
                                child: ElevatedButton(
                                  onPressed: provider.isCreating
                                      ? null
                                      : () => _submit(context),
                                  style: ElevatedButton.styleFrom(
                                    padding: EdgeInsets.zero,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                  ),
                                  child: provider.isCreating
                                      ? const SizedBox(
                                          width: 18,
                                          height: 18,
                                          child: CircularProgressIndicator(
                                            strokeWidth: 2,
                                            color: Colors.white,
                                          ),
                                        )
                                      : const Icon(
                                          Icons.add_rounded,
                                          color: Colors.white,
                                          size: 22,
                                        ),
                                ),
                              ),
                            ],
                          ),
                          Consumer<StatisticProvider>(
                            builder: (context, statProvider, _) => WeightChart(
                              statistic: statProvider.weightStatisticDetail,
                              selectedYear: _selectedYear,
                              isLoading: statProvider.isLoading,
                              onYearChanged: (year) {
                                setState(() => _selectedYear = year);
                                context
                                    .read<StatisticProvider>()
                                    .refreshMonthlyWeightStatistics(
                                      sheepId: widget.sheepId,
                                      year: year,
                                    );
                              },
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),

            const SliverToBoxAdapter(
              child: Padding(
                padding: EdgeInsets.fromLTRB(16, 0, 16, 12),
                child: Text(
                  'RIWAYAT BERAT BADAN',
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
                    () => context
                        .read<StatisticProvider>()
                        .refreshMonthlyWeightStatistics(
                          sheepId: widget.sheepId,
                          year: _selectedYear,
                        ),
                  ],
                ),
              ),
              onEmpty: () => const SliverToBoxAdapter(
                child: EmptyData(
                  title: 'Belum Ada Riwayat',
                  description: 'Belum ada catatan berat badan untuk domba ini',
                ),
              ),
              onSuccess: (data) => SliverPadding(
                padding: const EdgeInsets.fromLTRB(16, 0, 16, 24),
                sliver: SliverList.builder(
                  itemCount: data.length + 1,
                  itemBuilder: (_, i) {
                    if (i == data.length) {
                      return PaginationLoadingFooter(hasMore: provider.hasMore);
                    }
                    return WeightRecordCard(
                      weight: data[i],
                      sheepId: widget.sheepId,
                    );
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
