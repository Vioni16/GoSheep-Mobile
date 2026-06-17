import 'package:flutter/material.dart';
import 'package:gosheep_mobile/core/enums/mating_result_enum.dart';
import 'package:gosheep_mobile/core/theme/theme.dart';
import 'package:gosheep_mobile/core/utils/format_helper.dart';
import 'package:gosheep_mobile/core/widgets/app_refresh_indicator.dart';
import 'package:gosheep_mobile/core/widgets/async_state_sliver.dart';
import 'package:gosheep_mobile/core/widgets/empty_data.dart';
import 'package:gosheep_mobile/core/widgets/no_connection.dart';
import 'package:gosheep_mobile/data/models/mating_check.dart';
import 'package:gosheep_mobile/data/providers/mating_check_provider.dart';
import 'package:gosheep_mobile/data/providers/mating_record_provider.dart';
import 'package:gosheep_mobile/features/mating_record/widgets/add_mating_check_sheet.dart';
import 'package:gosheep_mobile/features/mating_record/widgets/edit_mating_check_sheet.dart';
import 'package:gosheep_mobile/features/mating_record/widgets/mating_check_card_skeleton.dart';
import 'package:provider/provider.dart';

class MatingCheckScreen extends StatelessWidget {
  final int matingRecordId;
  final String ramEarTag;
  final String eweEarTag;
  final MatingResult result;

  const MatingCheckScreen({
    super.key,
    required this.matingRecordId,
    required this.ramEarTag,
    required this.eweEarTag,
    required this.result,
  });

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => MatingCheckProvider(matingRecordId)..fetchMatingChecks(),
      child: _MatingCheckScreenView(
        matingRecordId: matingRecordId,
        ramEarTag: ramEarTag,
        eweEarTag: eweEarTag,
        result: result,
      ),
    );
  }
}

class _MatingCheckScreenView extends StatefulWidget {
  final int matingRecordId;
  final String ramEarTag;
  final String eweEarTag;
  final MatingResult result;

  const _MatingCheckScreenView({
    required this.matingRecordId,
    required this.ramEarTag,
    required this.eweEarTag,
    required this.result,
  });

  @override
  State<_MatingCheckScreenView> createState() => _MatingCheckScreenViewState();
}

class _MatingCheckScreenViewState extends State<_MatingCheckScreenView> {
  void _openAddSheet() {
    final matingCheckProvider = context.read<MatingCheckProvider>();

    MatingRecordProvider? matingRecordProvider;
    try {
      matingRecordProvider = context.read<MatingRecordProvider>();
    } catch (_) {}

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => MultiProvider(
        providers: [
          ChangeNotifierProvider.value(value: matingCheckProvider),
          if (matingRecordProvider != null)
            ChangeNotifierProvider.value(value: matingRecordProvider),
        ],
        child: AddMatingCheckSheet(matingRecordId: widget.matingRecordId),
      ),
    );
  }

  void _openEditSheet(MatingCheck check, MatingResult currentResult) {
    final matingCheckProvider = context.read<MatingCheckProvider>();

    MatingRecordProvider? matingRecordProvider;
    try {
      matingRecordProvider = context.read<MatingRecordProvider>();
    } catch (_) {}

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => MultiProvider(
        providers: [
          ChangeNotifierProvider.value(value: matingCheckProvider),
          if (matingRecordProvider != null)
            ChangeNotifierProvider.value(value: matingRecordProvider),
        ],
        child: EditMatingCheckSheet(
          matingRecordId: widget.matingRecordId,
          matingCheck: check,
          currentResult: currentResult,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<MatingCheckProvider>();

    MatingRecordProvider? matingRecordProvider;
    try {
      matingRecordProvider = context.watch<MatingRecordProvider>();
    } catch (_) {}

    final currentResult = matingRecordProvider != null
        ? (matingRecordProvider.matingRecords
                  .where((r) => r.id == widget.matingRecordId)
                  .firstOrNull
                  ?.result ??
              widget.result)
        : widget.result;

    return Scaffold(
      body: AppRefreshIndicator(
        onRefresh: provider.fetchMatingChecks,
        child: CustomScrollView(
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
                'Riwayat Pemeriksaan',
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
                          Text(
                            '${widget.ramEarTag} × ${widget.eweEarTag}',
                            style: const TextStyle(
                              fontSize: 22,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            'Seluruh riwayat pemeriksaan perkawinan',
                            style: TextStyle(
                              color: Colors.grey.shade600,
                              fontSize: 13,
                            ),
                          ),
                        ],
                      ),
                    ),
                    if (currentResult == MatingResult.unknown)
                      Material(
                        color: Colors.black,
                        borderRadius: BorderRadius.circular(20),
                        child: InkWell(
                          onTap: _openAddSheet,
                          borderRadius: BorderRadius.circular(20),
                          child: const Padding(
                            padding: EdgeInsets.symmetric(
                              horizontal: 14,
                              vertical: 10,
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(Icons.add, color: Colors.white, size: 16),
                                SizedBox(width: 6),
                                Text(
                                  'Pemeriksaan',
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
                      ),
                  ],
                ),
              ),
            ),

            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
                child: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 6,
                      ),
                      decoration: BoxDecoration(
                        color: AppTheme.cream,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            currentResult.icon,
                            size: 14,
                            color: currentResult.color,
                          ),
                          const SizedBox(width: 6),
                          Text(
                            currentResult.label,
                            style: TextStyle(
                              color: currentResult.color,
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
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
                  'RIWAYAT PEMERIKSAAN',
                  style: TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w700,
                    color: Colors.black54,
                    letterSpacing: 1.2,
                  ),
                ),
              ),
            ),

            AsyncStateSliver<MatingCheck>(
              isLoading: provider.isLoading,
              error: provider.error,
              data: provider.matingChecks,
              onLoading: () => SliverPadding(
                padding: const EdgeInsets.fromLTRB(16, 0, 16, 24),
                sliver: SliverList.builder(
                  itemBuilder: (_, __) => const MatingCheckCardSkeleton(),
                  itemCount: 6,
                ),
              ),
              onError: (err) => SliverToBoxAdapter(
                child: NoConnection(
                  description: err,
                  onRetry: [provider.fetchMatingChecks],
                ),
              ),
              onEmpty: () => const SliverToBoxAdapter(
                child: EmptyData(
                  title: 'Belum Ada Pemeriksaan',
                  description:
                      'Belum ada catatan pemeriksaan untuk perkawinan ini',
                ),
              ),
              onSuccess: (data) => SliverPadding(
                padding: const EdgeInsets.fromLTRB(16, 0, 16, 24),
                sliver: SliverList.builder(
                  itemCount: data.length,
                  itemBuilder: (_, index) {
                    final check = data[index];

                    return Container(
                      margin: const EdgeInsets.only(bottom: 4),
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
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 14,
                          vertical: 14,
                        ),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              padding: const EdgeInsets.all(8),
                              decoration: BoxDecoration(
                                color: AppTheme.cream,
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: Icon(
                                Icons.fact_check_outlined,
                                size: 18,
                                color: AppTheme.primaryGreen,
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    FormatHelper.formatDate(check.checkDate),
                                    style: const TextStyle(
                                      fontSize: 13,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                  if (check.notes != null &&
                                      check.notes!.isNotEmpty) ...[
                                    const SizedBox(height: 2),
                                    Text(
                                      check.notes!,
                                      style: TextStyle(
                                        fontSize: 12,
                                        color: Colors.grey.shade600,
                                      ),
                                      maxLines: 2,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ],
                                ],
                              ),
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                Text(
                                  FormatHelper.timeAgo(check.createdAt),
                                  style: TextStyle(
                                    fontSize: 11,
                                    color: Colors.grey.shade400,
                                  ),
                                ),
                                if (index == 0) ...[
                                  const SizedBox(height: 6),
                                  IconButton(
                                    icon: Icon(
                                      Icons.edit_outlined,
                                      size: 18,
                                      color: Colors.grey.shade500,
                                    ),
                                    padding: EdgeInsets.zero,
                                    constraints: const BoxConstraints(),
                                    onPressed: () =>
                                        _openEditSheet(check, currentResult),
                                  ),
                                ],
                              ],
                            ),
                          ],
                        ),
                      ),
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
