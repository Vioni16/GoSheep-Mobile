import 'package:flutter/material.dart';
import 'package:gosheep_mobile/core/theme/theme.dart';
import 'package:gosheep_mobile/core/utils/format_helper.dart';
import 'package:gosheep_mobile/core/widgets/gender_badge.dart';
import 'package:gosheep_mobile/core/widgets/sheep_chip.dart';
import 'package:gosheep_mobile/data/models/sheep_weight_overview.dart';
import 'package:gosheep_mobile/features/sheep/screens/sheep_detail_screen.dart';

class WeightCard extends StatelessWidget {
  final SheepWeightOverview sheepWeightOverview;

  const WeightCard({super.key, required this.sheepWeightOverview});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(14),
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
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Wrap(
                spacing: 8,
                crossAxisAlignment: WrapCrossAlignment.center,
                children: [
                  SheepChip(
                    label: sheepWeightOverview.earTag,
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) =>
                              SheepDetailScreen(id: sheepWeightOverview.id),
                        ),
                      );
                    },
                  ),
                  GenderBadge(gender: sheepWeightOverview.gender),
                ],
              ),
              const Spacer(),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 6,
                ),
                decoration: BoxDecoration(
                  color: AppTheme.cream,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  "${sheepWeightOverview.latestWeight.weight} Kg",
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.primary,
                    fontWeight: FontWeight.w700,
                    fontSize: 12,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Divider(color: Colors.grey.shade100, height: 1),
          const SizedBox(height: 10),
          Row(
            children: [
              Icon(
                Icons.monitor_weight_outlined,
                size: 16,
                color: Color(0xFF727272),
              ),
              const SizedBox(width: 6),
              const Text(
                "Terakhir ditimbang",
                style: TextStyle(fontSize: 12, color: Color(0xFF727272)),
              ),
              const Spacer(),
              Text(
                FormatHelper.formatDate(
                  sheepWeightOverview.latestWeight.recordedAt,
                ),
                style: const TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              Icon(Icons.person_outline, size: 16, color: Color(0xFF727272)),
              const SizedBox(width: 6),
              const Text(
                "Dicatat oleh",
                style: TextStyle(fontSize: 12, color: Color(0xFF727272)),
              ),
              const Spacer(),
              Text(
                sheepWeightOverview.latestWeight.recordedBy?.name ??
                    ('User tidak diketahui/dihapus'),
                style: const TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
