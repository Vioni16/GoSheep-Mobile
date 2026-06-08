import 'package:flutter/material.dart';
import 'package:gosheep_mobile/core/theme/theme.dart';
import 'package:gosheep_mobile/core/utils/format_helper.dart';
import 'package:gosheep_mobile/core/widgets/gender_badge.dart';
import 'package:gosheep_mobile/core/widgets/sheep_chip.dart';
import 'package:gosheep_mobile/data/models/mating_record.dart';
import 'package:gosheep_mobile/data/providers/mating_check_provider.dart';
import 'package:gosheep_mobile/data/providers/mating_record_provider.dart';
import 'package:gosheep_mobile/features/mating_record/widgets/mating_check_sheet.dart';
import 'package:gosheep_mobile/features/sheep/screens/sheep_detail_screen.dart';
import 'package:provider/provider.dart';

class MatingRecordCard extends StatelessWidget {
  final MatingRecord matingRecord;

  const MatingRecordCard({super.key, required this.matingRecord});

  void _openCheckSheet(BuildContext context) {
    final matingRecordProvider = Provider.of<MatingRecordProvider>(context, listen: false);

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => MultiProvider(
        providers: [
          ChangeNotifierProvider(
            create: (_) =>
                MatingCheckProvider(matingRecord.id)..fetchMatingChecks(),
          ),
          ChangeNotifierProvider.value(
            value: matingRecordProvider,
          ),
        ],
        child: MatingCheckSheet(matingRecord: matingRecord),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      child: Material(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        elevation: 0,
        child: InkWell(
          onTap: () => _openCheckSheet(context),
          borderRadius: BorderRadius.circular(12),
          child: Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.04),
                  blurRadius: 6,
                ),
              ],
            ),
            child: Column(
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Expanded(
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const GenderBadge(gender: "male"),
                                const SizedBox(width: 3),
                                SheepChip(
                                  label: matingRecord.ramEarTag,
                                  backgroundColor: Colors.white,
                                  borderColor: Colors.blue,
                                  onTap: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => SheepDetailScreen(
                                          id: matingRecord.ramId,
                                        ),
                                      ),
                                    );
                                  },
                                ),
                              ],
                            ),
                          ),

                          Expanded(
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                SheepChip(
                                  label: matingRecord.eweEarTag,
                                  backgroundColor: Colors.white,
                                  borderColor: Colors.pink,
                                  onTap: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => SheepDetailScreen(
                                          id: matingRecord.eweId,
                                        ),
                                      ),
                                    );
                                  },
                                ),
                                const SizedBox(width: 3),
                                const GenderBadge(gender: "female"),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(width: 10),

                    SizedBox(
                      width: 90,
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 10,
                          vertical: 5,
                        ),
                        decoration: BoxDecoration(
                          color: AppTheme.cream,
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              matingRecord.result.icon,
                              size: 13,
                              color: matingRecord.result.color,
                            ),
                            const SizedBox(width: 4),
                            Flexible(
                              child: Text(
                                matingRecord.result.label,
                                style: TextStyle(
                                  color: matingRecord.result.color,
                                  fontSize: 12,
                                  fontWeight: FontWeight.w600,
                                ),
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
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
                      "Kawin",
                      FormatHelper.formatDate(matingRecord.matingDate),
                    ),
                    _infoItem(
                      Icons.event_available_outlined,
                      "Selesai",
                      FormatHelper.formatDate(matingRecord.endDate),
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

  Widget _infoItem(
    IconData icon,
    String label,
    String value, {
    Color? valueColor,
  }) {
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
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: valueColor ?? const Color(0xFF2D3132),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
