import 'package:flutter/material.dart';
import 'package:gosheep_mobile/features/pregnancy_monitoring/widgets/pregnancy_status_badge.dart';

class PregnancyMonitoringCard extends StatelessWidget {
  final String title;
  final String status;
  final String startDate;
  final String expectedDate;

  const PregnancyMonitoringCard({
    super.key,
    required this.title,
    required this.status,
    required this.startDate,
    required this.expectedDate,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      child: Material(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        elevation: 0,
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
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontWeight: FontWeight.w700,
                      fontSize: 14,
                    ),
                  ),
                  PregnancyStatusBadge(status: status),
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
                    startDate,
                  ),
                  _infoItem(
                    Icons.event_available_outlined,
                    "Estimasi",
                    expectedDate,
                  ),
                ],
              ),
            ],
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