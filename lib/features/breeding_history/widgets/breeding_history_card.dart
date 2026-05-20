import 'package:flutter/material.dart';
import 'package:gosheep_mobile/core/theme/theme.dart';
import 'package:gosheep_mobile/core/widgets/gender_badge.dart';
import 'package:gosheep_mobile/core/widgets/sheep_chip.dart';
import 'package:gosheep_mobile/features/sheep/screens/sheep_detail_screen.dart';

class BreedingCard extends StatelessWidget {
  final Map<String, dynamic> item;

  const BreedingCard({super.key, required this.item});

  Color get _statusColor {
    switch (item["status"]) {
      case "Berhasil":
        return AppTheme.primaryGreen;
      case "Gagal":
        return Colors.red;
      default:
        return Colors.orange;
    }
  }

  IconData get _statusIcon {
    switch (item["status"]) {
      case "Berhasil":
        return Icons.check_circle_outline;
      case "Gagal":
        return Icons.cancel_outlined;
      default:
        return Icons.access_time_outlined;
    }
  }

  String get _statusText {
    switch (item["status"]) {
      case "Berhasil":
        return "Bunting";
      case "Gagal":
        return "Gagal";
      default:
        return "Proses";
    }
  }

  @override
  Widget build(BuildContext context) {
    final color = _statusColor;
    final male = item["male"] ?? "-";
    final female = item["female"] ?? "-";
    final date = item["date"] ?? "-";
    final status = item["status"] ?? "-";

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(color: Colors.black.withValues(alpha: 0.04), blurRadius: 6),
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
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SheepChip(
                            label: male,
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) =>
                                      SheepDetailScreen(id: item["male_id"]),
                                ),
                              );
                            },
                          ),

                          const SizedBox(height: 5),

                          const GenderBadge(gender: "Jantan"),
                        ],
                      ),
                    ),

                    const SizedBox(width: 10),

                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SheepChip(
                            label: female,
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) =>
                                      SheepDetailScreen(id: item["female_id"]),
                                ),
                              );
                            },
                          ),

                          const SizedBox(height: 5),

                          const GenderBadge(gender: "Betina"),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(width: 10),

              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 5,
                ),
                decoration: BoxDecoration(
                  color: color.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(_statusIcon, size: 13, color: color),
                    const SizedBox(width: 4),
                    Text(
                      _statusText,
                      style: TextStyle(
                        color: color,
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),

          const SizedBox(height: 12),
          Divider(color: Colors.grey.shade100, height: 1),
          const SizedBox(height: 10),

          Row(
            children: [
              Expanded(
                child: _infoItem(Icons.calendar_today_outlined, "Kawin", date),
              ),
              Expanded(
                child: _infoItem(
                  Icons.event_available_outlined,
                  "Selesai",
                  "25 Mei 2026",
                ),
              ),
              Expanded(
                child: _infoItem(
                  _statusIcon,
                  "Hasil",
                  status == "Proses" ? "Menunggu" : "Dicatat",
                  valueColor: color,
                ),
              ),
            ],
          ),
        ],
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
