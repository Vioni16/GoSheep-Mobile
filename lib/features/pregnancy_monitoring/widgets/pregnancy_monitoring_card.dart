import 'package:flutter/material.dart';
import 'package:gosheep_mobile/core/enums/mating_result_enum.dart';
import 'package:gosheep_mobile/core/utils/format_helper.dart';
import 'package:gosheep_mobile/core/widgets/sheep_chip.dart';
import 'package:gosheep_mobile/data/models/pregnancy.dart';
import 'package:gosheep_mobile/features/mating_record/screens/mating_check_screen.dart';
import 'package:gosheep_mobile/features/pregnancy_monitoring/widgets/pregnancy_status_badge.dart';
import 'package:provider/provider.dart';
import 'package:gosheep_mobile/data/providers/pregnant_sheep_provider.dart';
import 'package:gosheep_mobile/features/pregnancy_monitoring/screens/pregnancy_monitoring_detail_screen.dart';

class PregnancyMonitoringCard extends StatelessWidget {
  final Pregnancy pregnancy;

  const PregnancyMonitoringCard({super.key, required this.pregnancy});

  @override
  Widget build(BuildContext context) {
    final provider = context.read<PregnantSheepProvider>();
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      child: Material(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        elevation: 0,
        child: InkWell(
          borderRadius: BorderRadius.circular(12),
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => ChangeNotifierProvider.value(
                  value: provider,
                  child: PregnancyMonitoringDetailScreen(pregnancy: pregnancy),
                ),
              ),
            );
          },
          child: Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.grey.shade100),
            ),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    SheepChip(
                      label: pregnancy.eweEartag,
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => MatingCheckScreen(
                              matingRecordId: pregnancy.matingRecordId,
                              ramEarTag: pregnancy.ramEartag,
                              eweEarTag: pregnancy.eweEartag,
                              result: MatingResult.pregnant,
                            ),
                          ),
                        );
                      },
                    ),
                    PregnancyStatusBadge(status: pregnancy.status),
                  ],
                ),

                const SizedBox(height: 12),
                Divider(color: Colors.grey.shade100, height: 1),
                const SizedBox(height: 10),

                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    _infoItem(
                      Icons.calendar_today_outlined,
                      "Mulai",
                      FormatHelper.formatDate(pregnancy.startDate),
                    ),
                    _infoItem(
                      Icons.event_available_outlined,
                      "Estimasi",
                      FormatHelper.formatDate(pregnancy.expectedBirthDate),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _infoItem(IconData icon, String label, String value) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, size: 14, color: Colors.grey.shade600),
        const SizedBox(width: 5),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              label,
              style: TextStyle(fontSize: 10, color: Colors.grey.shade600),
            ),
            const SizedBox(height: 1),
            Text(
              value,
              style: const TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: Color(0xFF2D3132),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
