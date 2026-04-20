import 'package:flutter/material.dart';
import 'package:gosheep_mobile/core/utils/format_helper.dart';
import 'package:gosheep_mobile/core/widgets/empty_data.dart';
import 'package:gosheep_mobile/core/widgets/no_connection.dart';
import 'package:gosheep_mobile/data/models/cage.dart';
import 'package:gosheep_mobile/data/providers/cage_provider.dart';
import 'package:gosheep_mobile/features/cage/widgets/cage_card.dart';
import 'package:gosheep_mobile/features/cage/widgets/cage_card_skeleton.dart';
import 'package:gosheep_mobile/features/cage/widgets/cage_summary_header.dart';
import 'package:gosheep_mobile/core/widgets/async_state_sliver.dart';
import 'package:gosheep_mobile/features/cage/widgets/cage_summary_header_skeleton.dart';
import 'package:provider/provider.dart';

class CageScreen extends StatelessWidget {
  const CageScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => CageProvider()..fetchCages(),
      child: const _CageScreenView(),
    );
  }
}

class _CageScreenView extends StatelessWidget {
  const _CageScreenView();

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<CageProvider>();

    return Scaffold(
      appBar: AppBar(
        foregroundColor: Colors.white,
        backgroundColor: Theme.of(context).colorScheme.primary,
        centerTitle: true,
        title: const Text(
          'Kandang',
          style: TextStyle(fontWeight: FontWeight.w700, fontSize: 18),
        ),
      ),

      body: CustomScrollView(
        slivers: [

          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(16, 12, 16, 10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Pantau Kandang',
                    style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  const SizedBox(height: 4),

                  Text(
                    'Kelola kandang dan pantau kondisi domba secara real-time',
                    style: TextStyle(
                      color: Colors.grey,
                      fontSize: 13,
                    ),
                  ),
                ],
              ),
            ),
          ),

          AsyncStateSliver<Cage>(
            isLoading: provider.isLoading,
            error: provider.error,
            data: provider.cages,

            onLoading: () => SliverPadding(
              padding: const EdgeInsets.fromLTRB(16, 0, 16, 24),
              sliver: SliverList(
                delegate: SliverChildListDelegate(
                  [
                    const CageSummaryHeaderSkeleton(),

                    const SizedBox(height: 10),

                    ...List.generate(
                      4,
                          (_) => const Padding(
                        padding: EdgeInsets.only(bottom: 10),
                        child: CageCardSkeleton(),
                      ),
                    ),
                  ],
                ),
              ),
            ),

            onError: (err) => SliverFillRemaining(
              hasScrollBody: false,
              child: FormatHelper.isNoConnection(err)
                  ? NoConnection(onRetry: provider.refresh)
                  : EmptyData(description: err),
            ),

            onEmpty: () => const SliverFillRemaining(
              hasScrollBody: false,
              child: EmptyData(description: 'Belum ada kandang yang terdaftar'),
            ),

            onSuccess: (data) {
              final totalSheep =
              data.fold<int>(0, (sum, c) => sum + c.currentCapacity);

              final avgCapacity = data.isEmpty
                  ? 0.0
                  : data.fold<double>(
                0,
                    (sum, c) =>
                sum + (c.currentCapacity / c.maxCapacity),
              ) /
                  data.length *
                  100;

              return SliverPadding(
                padding: const EdgeInsets.fromLTRB(16, 0, 16, 24),
                sliver: SliverList.builder(
                  itemCount: data.length + 1,
                  itemBuilder: (context, index) {
                    if (index == 0) {
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 10),
                        child: CageSummaryHeader(
                          totalCages: data.length,
                          totalSheep: totalSheep,
                          avgCapacity: avgCapacity,
                        ),
                      );
                    }

                    final cage = data[index - 1];

                    return Padding(
                      padding: const EdgeInsets.only(bottom: 10),
                      child: CageCard(cage: cage),
                    );
                  },
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}