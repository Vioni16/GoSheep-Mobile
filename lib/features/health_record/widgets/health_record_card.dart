import 'package:flutter/material.dart';
import 'package:gosheep_mobile/core/extensions/string_extension.dart';
import 'package:gosheep_mobile/core/theme/theme.dart';
import 'package:gosheep_mobile/core/utils/format_helper.dart';
import 'package:gosheep_mobile/core/utils/sheep_status_util.dart';
import 'package:gosheep_mobile/data/models/health.dart';
import 'package:gosheep_mobile/data/providers/health_record_provider.dart';
import 'package:gosheep_mobile/features/health_record/widgets/edit_health_sheet.dart';
import 'package:provider/provider.dart';

class HealthRecordCard extends StatelessWidget {
  final Health health;

  const HealthRecordCard({super.key, required this.health});

  void _showEditSheet(BuildContext context) {
    final provider = context.read<HealthRecordProvider>();

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => ChangeNotifierProvider.value(
        value: provider,
        child: EditHealthSheet(health: health),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
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
      clipBehavior: Clip.antiAlias,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(14, 10, 6, 12),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Expanded(
                  child: Text(
                    health.condition.capitalizeFirst,
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF2D3132),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 7,
                  ),
                  decoration: BoxDecoration(
                    color: AppTheme.cream,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    health.severity.capitalizeFirst,
                    style: TextStyle(
                      color: SheepStatusUtil.severityColor(health.severity),
                      fontSize: 12,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
                const SizedBox(width: 4),
                IconButton(
                  icon: Icon(
                    Icons.edit_outlined,
                    size: 20,
                    color: Colors.grey.shade500,
                  ),
                  onPressed: () => _showEditSheet(context),
                ),
              ],
            ),
          ),

          Container(
            decoration: BoxDecoration(
              color: Colors.grey.shade50,
              border: Border(
                top: BorderSide(color: Colors.grey.shade100, width: 1),
              ),
            ),
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
            child: Column(
              children: [
                Row(
                  children: [
                    Expanded(
                      child: _MetaItem(
                        icon: Icons.category_outlined,
                        label: 'Kategori',
                        value: SheepStatusUtil.healthCategoryLabel(
                          health.category,
                        ).capitalizeFirst,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: _MetaItem(
                        icon: Icons.calendar_today_outlined,
                        label: 'Tanggal',
                        value: FormatHelper.formatDateTime(health.recordedAt),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                Row(
                  children: [
                    Expanded(
                      child: _MetaItem(
                        icon: Icons.person_outline,
                        label: 'Dicatat oleh',
                        value:
                            health.recordedBy?.name ??
                            'User Tidak diketahui/Dihapus',
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: _MetaItem(
                        icon: Icons.fact_check_outlined,
                        label: 'Sumber',
                        value: health.source.capitalizeFirst,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),

          if (health.notes != null && health.notes!.isNotEmpty)
            Container(
              decoration: BoxDecoration(
                border: Border(
                  top: BorderSide(color: Colors.grey.shade100, width: 1),
                ),
              ),
              padding: const EdgeInsets.fromLTRB(14, 10, 14, 10),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Icon(
                    Icons.notes_outlined,
                    size: 14,
                    color: Colors.grey.shade400,
                  ),
                  const SizedBox(width: 6),
                  Expanded(
                    child: Text(
                      health.notes!,
                      style: const TextStyle(
                        fontSize: 11,
                        color: Colors.black45,
                      ),
                    ),
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }
}



// ── Meta Item ───────────────────────────────────────────────────────────────

class _MetaItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;

  const _MetaItem({
    required this.icon,
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(top: 2),
          child: Icon(icon, size: 14, color: Colors.grey.shade500),
        ),
        const SizedBox(width: 6),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: const TextStyle(fontSize: 10, color: Colors.black38),
              ),
              const SizedBox(height: 1),
              Text(
                value,
                style: const TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF2D3132),
                ),
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
      ],
    );
  }
}
