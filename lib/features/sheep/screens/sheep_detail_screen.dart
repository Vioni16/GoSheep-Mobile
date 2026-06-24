import 'package:flutter/material.dart';
import 'package:gosheep_mobile/core/utils/format_helper.dart';
import 'package:gosheep_mobile/core/utils/sheep_status_util.dart';
import 'package:gosheep_mobile/core/widgets/async_state_sliver.dart';
import 'package:gosheep_mobile/core/widgets/empty_data.dart';
import 'package:gosheep_mobile/core/widgets/no_connection.dart';
import 'package:gosheep_mobile/data/models/sheep.dart';
import 'package:gosheep_mobile/data/models/sheep_detail.dart';
import 'package:gosheep_mobile/data/providers/sheep_detail_provider.dart';
import 'package:gosheep_mobile/features/sheep/widgets/sheep_detail_skeleton.dart';
import 'package:gosheep_mobile/features/sheep/widgets/sheep_detail_widgets.dart';
import 'package:gosheep_mobile/features/sheep/widgets/sheep_hero_header.dart';
import 'package:gosheep_mobile/features/sheep/widgets/sheep_info_card.dart';
import 'package:gosheep_mobile/features/sheep/screens/edit_sheep_screen.dart';
import 'package:gosheep_mobile/data/models/inactive_sheep.dart';
import 'package:provider/provider.dart';

class SheepDetailScreen extends StatelessWidget {
  final int id;
  final Sheep? initialData;

  const SheepDetailScreen({super.key, required this.id, this.initialData});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => SheepDetailProvider()..init(id, initialData: initialData),
      child: _SheepDetailView(id: id),
    );
  }
}

class _SheepDetailView extends StatelessWidget {
  final int id;

  const _SheepDetailView({required this.id});

  String _getStatusLabel(SheepStatus status) {
    switch (status) {
      case SheepStatus.sold:
        return 'Dijual';
      case SheepStatus.dead:
        return 'Mati';
      case SheepStatus.inactive:
        return 'Nonaktif';
    }
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<SheepDetailProvider>();
    final primary = Theme.of(context).colorScheme.primary;

    return Scaffold(
      body: CustomScrollView(
        physics: BouncingScrollPhysics(),
        slivers: [
          SliverAppBar(
            expandedHeight: 0,
            floating: true,
            pinned: true,
            elevation: 0,
            backgroundColor: primary,
            foregroundColor: Colors.white,
            centerTitle: false,
            title: const Text(
              'Detail Domba',
              style: TextStyle(
                fontWeight: FontWeight.w700,
                fontSize: 18,
                letterSpacing: 0.3,
              ),
            ),
            actions: [
              if (provider.sheepDetail != null)
                IconButton(
                  icon: const Icon(Icons.edit_rounded),
                  onPressed: () async {
                    final result = await Navigator.push<bool>(
                      context,
                      MaterialPageRoute(
                        builder: (_) =>
                            EditSheepScreen(sheep: provider.sheepDetail!),
                      ),
                    );
                    if (result == true) {
                      provider.refresh(id);
                    }
                  },
                ),
            ],
          ),

          AsyncStateSliver<SheepDetail>(
            isLoading: provider.isLoading,
            error: provider.error,
            data: provider.sheepDetail != null ? [provider.sheepDetail!] : [],
            onLoading: () =>
                const SliverToBoxAdapter(child: SheepDetailSkeleton()),
            onError: (err) => SliverFillRemaining(
              hasScrollBody: false,
              child: NoConnection(onRetry: [() => provider.refresh(id)]),
            ),
            showErrorWhenHasData: true,
            onEmpty: () => const SliverFillRemaining(
              hasScrollBody: false,
              child: EmptyData(description: 'Data tidak ditemukan'),
            ),
            onSuccess: (data) {
              final sheep = data.first;
              return SliverList(
                delegate: SliverChildListDelegate([
                  SheepHeroHeader(sheep: sheep, primary: primary),

                  const SizedBox(height: 20),

                  ModernCard(
                    icon: Icons.info_outline_rounded,
                    title: 'Informasi Umum',
                    children: [
                      ModernInfoRow(label: 'Ear Tag', value: sheep.earTag),
                      ModernInfoRow(
                        label: 'Jenis Kelamin',
                        value: SheepStatusUtil.getGenderLabel(sheep.gender),
                      ),
                      ModernInfoRow(label: 'Breed', value: sheep.breed ?? '-'),
                      ModernInfoRow(
                        label: 'Ditambahkan',
                        value: FormatHelper.formatDateTime(sheep.createdAt),
                        isLoading: sheep.isFromInitial,
                      ),
                    ],
                  ),

                  ModernCard(
                    icon: Icons.calendar_today_rounded,
                    title: 'Detail',
                    children: [
                      ModernInfoRow(
                        label: 'Tanggal Lahir',
                        value: FormatHelper.formatDate(sheep.birthDate),
                        isLoading: sheep.isFromInitial,
                      ),
                      ModernInfoRow(
                        label: 'Umur',
                        value: FormatHelper.formatAge(sheep.birthDate),
                        isLoading: sheep.isFromInitial,
                      ),
                      buildStatusTile(
                        sheep.status.toLowerCase() == 'active'
                            ? 'Aktif'
                            : _getStatusLabel(
                                SheepStatus.values.firstWhere(
                                  (e) =>
                                      e.name.toLowerCase() ==
                                      sheep.status.toLowerCase(),
                                  orElse: () => SheepStatus.inactive,
                                ),
                              ),
                        isLoading: sheep.isFromInitial,
                      ),
                      ModernInfoRow(
                        label: 'Kandang',
                        value: sheep.cage ?? '-',
                        isLoading: sheep.isFromInitial,
                      ),
                    ],
                  ),

                  ModernCard(
                    icon: Icons.family_restroom_rounded,
                    title: 'Orang Tua',
                    children: [
                      buildParentTile(
                        context,
                        'Sire',
                        sheep.sire,
                        isLoading: sheep.isFromInitial,
                      ),
                      buildParentTile(
                        context,
                        'Dam',
                        sheep.dam,
                        isLoading: sheep.isFromInitial,
                      ),
                    ],
                  ),

                  ModernCard(
                    icon: Icons.monitor_heart_rounded,
                    title: 'Kesehatan & Berat',
                    children: [
                      buildWeightTile(sheep.weight, isLoading: false),
                      ModernInfoRow(
                        label: 'Kondisi',
                        value: SheepStatusUtil.healthConditionStatus(
                          sheep.healthCondition,
                        ),
                        isLoading: sheep.isFromInitial,
                        valueColor: SheepStatusUtil.getHealthColor(
                          sheep.statusUi,
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 32),
                ]),
              );
            },
          ),
        ],
      ),
    );
  }
}
