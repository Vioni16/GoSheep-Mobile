import 'package:flutter/material.dart';
import 'package:gosheep_mobile/core/theme/theme.dart';
import 'package:gosheep_mobile/core/widgets/gender_badge.dart';
import 'package:gosheep_mobile/core/widgets/sheep_chip.dart';
import '../screens/inactive_sheep_screen.dart';

class InactiveSheepCard extends StatelessWidget {
  final InactiveSheep sheep;

  const InactiveSheepCard({super.key, required this.sheep});

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

  IconData _getStatusIcon(SheepStatus status) {
    switch (status) {
      case SheepStatus.sold:
        return Icons.sell_rounded;
      case SheepStatus.dead:
        return Icons.heart_broken_rounded;
      case SheepStatus.inactive:
        return Icons.do_not_disturb_on_rounded;
    }
  }

  @override
  Widget build(BuildContext context) {
    final genderKey = sheep.gender.toLowerCase() == 'jantan'
        ? 'male'
        : 'female';
    final isMale = genderKey == 'male';

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      child: Material(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        elevation: 0,
        child: InkWell(
          onTap: () {},
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
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          GenderBadge(gender: genderKey),
                          const SizedBox(width: 3),
                          SheepChip(
                            label: sheep.earTag,
                            backgroundColor: Colors.white,
                            borderColor: isMale ? Colors.blue : Colors.pink,
                            onTap: () {
                            },
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
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              _getStatusIcon(sheep.status),
                              size: 13,
                              color: const Color(
                                0xFF2D3132,
                              ), 
                            ),
                            const SizedBox(width: 4),
                            Flexible(
                              child: Text(
                                _getStatusLabel(sheep.status),
                                style: const TextStyle(
                                  color: Color(
                                    0xFF2D3132,
                                  ), 
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
                      Icons.layers_outlined,
                      "Ras / Kandang",
                      "${sheep.breed} · ${sheep.pen}",
                    ),
                    _infoItem(
                      Icons.scale_outlined,
                      "Berat",
                      '${sheep.weightKg.toStringAsFixed(0)} kg',
                    ),
                    _infoItem(
                      Icons.calendar_today_outlined,
                      "Selesai",
                      sheep.inactiveDate,
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
