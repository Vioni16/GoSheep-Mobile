import 'package:flutter/material.dart';
import 'package:gosheep_mobile/core/enums/mating_result_enum.dart';
import 'package:gosheep_mobile/core/utils/format_helper.dart';
import 'package:gosheep_mobile/core/widgets/sheep_chip.dart';
import 'package:gosheep_mobile/data/models/pregnancy.dart';
import 'package:gosheep_mobile/data/providers/pregnant_sheep_provider.dart';
import 'package:gosheep_mobile/features/mating_record/screens/mating_check_screen.dart';
import 'package:gosheep_mobile/features/pregnancy_monitoring/widgets/edit_pregnancy_sheet.dart';
import 'package:gosheep_mobile/features/sheep/widgets/sheep_info_card.dart';
import 'package:provider/provider.dart';

class PregnancyMonitoringDetailScreen extends StatelessWidget {
  final Pregnancy pregnancy;

  const PregnancyMonitoringDetailScreen({super.key, required this.pregnancy});

  void _showEditSheet(
    BuildContext context,
    PregnantSheepProvider provider,
    Pregnancy pregnancy,
  ) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => ChangeNotifierProvider.value(
        value: provider,
        child: EditPregnancySheet(pregnancy: pregnancy),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<PregnantSheepProvider>();
    final currentPregnancy = provider.pregnancies.firstWhere(
      (p) => p.id == pregnancy.id,
      orElse: () => pregnancy,
    );

    final primary = Theme.of(context).colorScheme.primary;

    return Scaffold(
      body: CustomScrollView(
        physics: const BouncingScrollPhysics(),
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
              'Detail Kebuntingan',
              style: TextStyle(
                fontWeight: FontWeight.w700,
                fontSize: 18,
                letterSpacing: 0.3,
              ),
            ),
          ),

          SliverList(
            delegate: SliverChildListDelegate([
              PregnancyHeroHeader(
                pregnancy: currentPregnancy,
                primary: primary,
              ),

              const SizedBox(height: 20),

              // Info Card: Dam & Sire
              ModernCard(
                icon: Icons.info_outline_rounded,
                title: 'Informasi Induk & Pejantan',
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'Dam (Induk)',
                          style: TextStyle(
                            fontSize: 13,
                            color: Colors.grey,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        SheepChip(
                          label: currentPregnancy.eweEartag,
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => MatingCheckScreen(
                                  matingRecordId:
                                      currentPregnancy.matingRecordId,
                                  ramEarTag: currentPregnancy.ramEartag,
                                  eweEarTag: currentPregnancy.eweEartag,
                                  result: MatingResult.pregnant,
                                ),
                              ),
                            );
                          },
                        ),
                      ],
                    ),
                  ),
                  ModernInfoRow(
                    label: 'Sire (Pejantan)',
                    value: currentPregnancy.ramEartag,
                  ),
                ],
              ),

              // Info Card: Timeline & Dates
              ModernCard(
                icon: Icons.calendar_today_rounded,
                title: 'Rentang Masa Kebuntingan',
                children: [
                  ModernInfoRow(
                    label: 'Tanggal Mulai',
                    value: FormatHelper.formatDate(currentPregnancy.startDate),
                  ),
                  ModernInfoRow(
                    label: 'Estimasi Melahirkan',
                    value: FormatHelper.formatDate(
                      currentPregnancy.expectedBirthDate,
                    ),
                  ),
                  if (currentPregnancy.status != 'ongoing' &&
                      currentPregnancy.endDate != null)
                    ModernInfoRow(
                      label: currentPregnancy.status == 'birthed'
                          ? 'Tanggal Melahirkan'
                          : 'Tanggal Keguguran',
                      value: FormatHelper.formatDate(currentPregnancy.endDate),
                      valueColor: currentPregnancy.status == 'birthed'
                          ? const Color(0xFF1E88E5)
                          : Colors.red.shade700,
                    ),
                ],
              ),

              // Info Card: Notes
              ModernCard(
                icon: Icons.notes_rounded,
                title: 'Catatan Kehamilan',
                children: [
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.grey.shade50,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: Colors.grey.shade100),
                    ),
                    child: Text(
                      FormatHelper.formatNullable(currentPregnancy.notes),
                      style: TextStyle(
                        fontSize: 13,
                        color:
                            currentPregnancy.notes == null ||
                                currentPregnancy.notes!.isEmpty
                            ? Colors.grey.shade500
                            : Colors.grey.shade800,
                        height: 1.4,
                      ),
                    ),
                  ),
                ],
              ),

              // Info Card: Birth Data (only shown when birthed)
              if (currentPregnancy.status == 'birthed' &&
                  currentPregnancy.birth != null)
                ModernCard(
                  icon: Icons.child_care_rounded,
                  title: 'Data Kelahiran',
                  iconColor: const Color(0xFF1E88E5),
                  children: [
                    ModernInfoRow(
                      label: 'Jumlah Anak',
                      value: '${currentPregnancy.birth!.totalLambs} ekor',
                      valueColor: const Color(0xFF1E88E5),
                    ),
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Colors.blue.shade50,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: Colors.blue.shade100),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Catatan Kelahiran',
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.grey.shade500,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            FormatHelper.formatNullable(
                              currentPregnancy.birth!.birthNotes,
                            ),
                            style: TextStyle(
                              fontSize: 13,
                              color: currentPregnancy.birth!.birthNotes == null
                                  ? Colors.grey.shade500
                                  : Colors.grey.shade800,
                              height: 1.4,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),

              const SizedBox(height: 32),
            ]),
          ),
        ],
      ),
      bottomNavigationBar: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
          child: ElevatedButton.icon(
            onPressed: () =>
                _showEditSheet(context, provider, currentPregnancy),
            icon: const Icon(Icons.edit_rounded, size: 18),
            label: const Text('Edit Kehamilan'),
            style: ElevatedButton.styleFrom(
              backgroundColor: primary,
              foregroundColor: Colors.white,
              minimumSize: const Size.fromHeight(48),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              elevation: 2,
            ),
          ),
        ),
      ),
    );
  }
}

class PregnancyHeroHeader extends StatelessWidget {
  final Pregnancy pregnancy;
  final Color primary;

  const PregnancyHeroHeader({
    super.key,
    required this.pregnancy,
    required this.primary,
  });

  Color _getStatusColor() {
    switch (pregnancy.status) {
      case 'ongoing':
        return const Color(0xFF2E7D52);
      case 'birthed':
        return const Color(0xFF1E88E5);
      case 'miscarried':
        return Colors.red.shade700;
      default:
        return Colors.grey;
    }
  }

  String _getStatusLabel() {
    switch (pregnancy.status) {
      case 'ongoing':
        return 'Bunting';
      case 'birthed':
        return 'Melahirkan';
      case 'miscarried':
        return 'Keguguran';
      default:
        return 'Unknown';
    }
  }

  @override
  Widget build(BuildContext context) {
    final statusColor = _getStatusColor();
    final statusLabel = _getStatusLabel();
    final durationDays = (pregnancy.endDate ?? DateTime.now())
        .difference(pregnancy.startDate)
        .inDays;

    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [primary, primary.withValues(alpha: 0.82)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      padding: const EdgeInsets.fromLTRB(24, 28, 24, 36),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                width: 64,
                height: 64,
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.18),
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: Colors.white.withValues(alpha: 0.4),
                    width: 1.5,
                  ),
                ),
                child: const Icon(Icons.pets, color: Colors.white, size: 32),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      pregnancy.eweEartag,
                      style: const TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.w800,
                        color: Colors.white,
                        letterSpacing: 0.5,
                        height: 1.1,
                      ),
                    ),
                    const SizedBox(height: 6),
                    _PregnancyStatusChip(
                      label: statusLabel,
                      color: statusColor,
                    ),
                  ],
                ),
              ),
            ],
          ),

          const SizedBox(height: 24),

          Row(
            children: [
              _QuickStat(
                icon: Icons.calendar_today_rounded,
                label: 'Mulai',
                value: FormatHelper.formatDate(pregnancy.startDate),
              ),
              _QuickStatDivider(),
              _QuickStat(
                icon: Icons.hourglass_empty_rounded,
                label: 'Durasi',
                value: '$durationDays Hari',
              ),
              _QuickStatDivider(),
              _QuickStat(
                icon: Icons.child_care_rounded,
                label: 'Estimasi Lahir',
                value: FormatHelper.formatDate(pregnancy.expectedBirthDate),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _PregnancyStatusChip extends StatelessWidget {
  final String label;
  final Color color;

  const _PregnancyStatusChip({required this.label, required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.08),
            blurRadius: 6,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 7,
            height: 7,
            decoration: BoxDecoration(color: color, shape: BoxShape.circle),
          ),
          const SizedBox(width: 6),
          Text(
            label,
            style: TextStyle(
              color: color,
              fontSize: 12,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}

class _QuickStat extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;

  const _QuickStat({
    required this.icon,
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Column(
        children: [
          Icon(icon, color: Colors.white.withValues(alpha: 0.7), size: 18),
          const SizedBox(height: 4),
          Text(
            value,
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.w700,
              fontSize: 13,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          Text(
            label,
            style: TextStyle(
              color: Colors.white.withValues(alpha: 0.65),
              fontSize: 10,
            ),
          ),
        ],
      ),
    );
  }
}

class _QuickStatDivider extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 1,
      height: 36,
      color: Colors.white.withValues(alpha: 0.25),
      margin: const EdgeInsets.symmetric(horizontal: 4),
    );
  }
}
