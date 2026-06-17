import 'package:flutter/material.dart';
import 'package:gosheep_mobile/core/theme/theme.dart';
import 'package:gosheep_mobile/core/utils/format_helper.dart';
import 'package:gosheep_mobile/data/models/weight.dart';
import 'package:gosheep_mobile/data/providers/weight_record_provider.dart';
import 'package:gosheep_mobile/features/weight_record/widgets/edit_weight_sheet.dart';
import 'package:provider/provider.dart';

class WeightRecordCard extends StatelessWidget {
  final Weight weight;
  final int sheepId;

  const WeightRecordCard({
    super.key,
    required this.weight,
    required this.sheepId,
  });

  void _showEditSheet(BuildContext context) {
    final provider = context.read<WeightRecordProvider>();

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => ChangeNotifierProvider.value(
        value: provider,
        child: EditWeightSheet(
          weight: weight,
          sheepId: sheepId,
        ),
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
            padding: const EdgeInsets.fromLTRB(14, 10, 6, 10),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Icon(
                  Icons.monitor_weight_outlined,
                  size: 20,
                  color: Theme.of(context).colorScheme.primary,
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(
                    FormatHelper.formatWeight(weight.weight),
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                      color: Color(0xFF2D3132),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: AppTheme.cream,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    FormatHelper.formatDate(weight.recordedAt),
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.primary,
                      fontSize: 11,
                      fontWeight: FontWeight.w600,
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
            child: Row(
              children: [
                Icon(
                  Icons.person_outline,
                  size: 14,
                  color: Colors.grey.shade500,
                ),
                const SizedBox(width: 6),
                Text(
                  'Dicatat oleh',
                  style: TextStyle(fontSize: 11, color: Colors.grey.shade500),
                ),
                const SizedBox(width: 6),
                Text(
                  weight.recordedBy?.name ?? 'User tidak diketahui/dihapus',
                  style: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF2D3132),
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
