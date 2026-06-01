import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:gosheep_mobile/data/models/health_record_statistic.dart';
import 'package:gosheep_mobile/features/health_record/widgets/health_chart_skeleton.dart';

class HealthChartCard extends StatelessWidget {
  final HealthRecordStatistic? statistic;
  final bool isLoading;

  const HealthChartCard({super.key, this.statistic, this.isLoading = false});

  @override
  Widget build(BuildContext context) {
    final normal = (statistic?.severityNormal ?? 0).toDouble();
    final mild = (statistic?.severityMild ?? 0).toDouble();
    final moderate = (statistic?.severityModerate ?? 0).toDouble();
    final severe = (statistic?.severitySevere ?? 0).toDouble();

    final total = normal + mild + moderate + severe;

    double percent(double value) {
      if (total == 0) return 0;
      return (value / total) * 100;
    }

    if (isLoading) return const HealthChartCardSkeleton();

    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.03),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "Statistik Kondisi",
            style: TextStyle(fontSize: 15, fontWeight: FontWeight.w700),
          ),
          const SizedBox(height: 18),

          SizedBox(
            height: 180,
            child: total > 0
                ? PieChart(
                    PieChartData(
                      sectionsSpace: 3,
                      centerSpaceRadius: 45,
                      sections: [
                        if (normal > 0)
                          PieChartSectionData(
                            value: normal,
                            title: "${percent(normal).toStringAsFixed(0)}%",
                            radius: 55,
                            color: Colors.green,
                            titleStyle: const TextStyle(
                              color: Colors.white,
                              fontSize: 11,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        if (mild > 0)
                          PieChartSectionData(
                            value: mild,
                            title: "${percent(mild).toStringAsFixed(0)}%",
                            radius: 55,
                            color: Colors.yellow,
                            titleStyle: const TextStyle(
                              color: Colors.black,
                              fontSize: 11,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        if (moderate > 0)
                          PieChartSectionData(
                            value: moderate,
                            title: "${percent(moderate).toStringAsFixed(0)}%",
                            radius: 55,
                            color: Colors.orange,
                            titleStyle: const TextStyle(
                              color: Colors.white,
                              fontSize: 11,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        if (severe > 0)
                          PieChartSectionData(
                            value: severe,
                            title: "${percent(severe).toStringAsFixed(0)}%",
                            radius: 55,
                            color: Colors.red,
                            titleStyle: const TextStyle(
                              color: Colors.white,
                              fontSize: 11,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                      ],
                    ),
                  )
                : Center(
                    child: Text(
                      'Belum ada data',
                      style: TextStyle(color: Colors.grey[400], fontSize: 14),
                    ),
                  ),
          ),

          const SizedBox(height: 16),

          /// LEGEND (dengan jumlah)
          Wrap(
            spacing: 12,
            runSpacing: 8,
            children: [
              _legendItem("Sehat", normal.toInt(), Colors.green),
              _legendItem("Ringan", mild.toInt(), Colors.yellow),
              _legendItem("Sedang", moderate.toInt(), Colors.orange),
              _legendItem("Berat", severe.toInt(), Colors.red),
            ],
          ),
        ],
      ),
    );
  }

  Widget _legendItem(String label, int value, Color color) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 10,
          height: 10,
          decoration: BoxDecoration(color: color, shape: BoxShape.circle),
        ),
        const SizedBox(width: 6),
        Text("$label ($value)", style: const TextStyle(fontSize: 12)),
      ],
    );
  }
}
