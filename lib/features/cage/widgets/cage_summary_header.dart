import 'package:flutter/material.dart';

class CageSummaryHeader extends StatelessWidget {
  final int totalCages;
  final int totalSheep;
  final double avgCapacity;

  const CageSummaryHeader({
    super.key,
    required this.totalCages,
    required this.totalSheep,
    required this.avgCapacity,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(0, 14, 0, 8),
      child: Row(
        children: [
          _MetricCard(label: 'Total Kandang', value: '$totalCages'),
          const SizedBox(width: 10),
          _MetricCard(label: 'Total Domba', value: '$totalSheep'),
          const SizedBox(width: 10),
          _MetricCard(label: 'Rata-rata Kapasitas', value: '${avgCapacity.round()}%'),
        ],
      ),
    );
  }
}

class _MetricCard extends StatelessWidget {
  final String label;
  final String value;

  const _MetricCard({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
        decoration: BoxDecoration(
          color: const Color(0xFFFFFFFF),
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: Colors.black.withValues(alpha: 0.08), width: 0.5),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(label, style: Theme.of(context).textTheme.labelSmall?.copyWith(fontSize: 12)),
            const SizedBox(height: 4),
            Text(value, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w500)),
          ],
        ),
      ),
    );
  }
}