import 'package:flutter/material.dart';

class HealthStatisticsHeader extends StatelessWidget {
  final int totalRecords;
  final int healthyCount;
  final int attentionCount;

  const HealthStatisticsHeader({
    super.key,
    required this.totalRecords,
    required this.healthyCount,
    required this.attentionCount,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: _StatCard(
            title: "Total Catatan",
            value: totalRecords.toString(),
          ),
        ),

        const SizedBox(width: 10),

        Expanded(
          child: _StatCard(
            title: "Kondisi Sehat",
            value: healthyCount.toString(),
          ),
        ),

        const SizedBox(width: 10),

        Expanded(
          child: _StatCard(
            title: "Perlu Diperhatikan",
            value: attentionCount.toString(),
          ),
        ),
      ],
    );
  }
}

class _StatCard extends StatelessWidget {
  final String title;
  final String value;

  const _StatCard({required this.title, required this.value});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 16),

      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),

        border: Border.all(color: Colors.black.withValues(alpha: 0.05)),
      ),

      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(fontSize: 11, color: Colors.black87),
          ),

          const SizedBox(height: 6),

          Text(
            value,

            style: const TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.w700,
              color: Color(0xFF2D3132),
            ),
          ),
        ],
      ),
    );
  }
}
