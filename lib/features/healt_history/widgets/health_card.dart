import 'package:flutter/material.dart';
import 'package:gosheep_mobile/core/theme/theme.dart';
import 'package:gosheep_mobile/core/widgets/gender_badge.dart';
import 'package:gosheep_mobile/core/widgets/sheep_chip.dart';
import 'package:gosheep_mobile/features/sheep/screens/sheep_detail_screen.dart';

class HealthCard extends StatelessWidget {
  final Map<String, dynamic> item;

  const HealthCard({super.key, required this.item});

  Color getSeverityColor(String severity) {
    switch (severity) {
      case "Ringan":
        return AppTheme.primaryGreen;

      case "Sedang":
        return Colors.orange;

      case "Berat":
        return Colors.red;

      default:
        return Colors.grey;
    }
  }

  @override
  Widget build(BuildContext context) {
    final bool isFemale = item["gender"] == "Betina";
    final severityColor = getSeverityColor(item["severity"]);

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
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Row(
                  children: [
                    SheepChip(
                      label: item["earTag"],

                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => SheepDetailScreen(id: item["id"]),
                          ),
                        );
                      },
                    ),

                    const SizedBox(width: 8),
                    GenderBadge(gender: item["gender"]),
                  ],
                ),
              ),

              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 7,
                ),

                decoration: BoxDecoration(
                  color: severityColor.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(20),
                ),

                child: Text(
                  item["severity"],

                  style: TextStyle(
                    color: severityColor,
                    fontSize: 12,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 12),

          Divider(color: Colors.grey.shade100, height: 1),

          const SizedBox(height: 12),

          Row(
            children: [
              Icon(
                Icons.medical_services_outlined,
                size: 16,
                color: Colors.grey.shade500,
              ),

              const SizedBox(width: 6),

              Expanded(
                child: Text(
                  item["condition"],

                  style: const TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF2D3132),
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 10),

          Row(
            children: [
              Icon(
                Icons.category_outlined,
                size: 16,
                color: Colors.grey.shade500,
              ),

              const SizedBox(width: 6),

              Text(
                item["category"],

                style: const TextStyle(fontSize: 12, color: Colors.black54),
              ),

              const Spacer(),

              Text(
                item["date"],

                style: const TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF2D3132),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
