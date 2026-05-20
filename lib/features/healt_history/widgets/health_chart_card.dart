import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';

class HealthChartCard extends StatelessWidget {
  const HealthChartCard({super.key});

  @override
  Widget build(BuildContext context) {
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

            child: PieChart(
              PieChartData(
                sectionsSpace: 3,
                centerSpaceRadius: 45,

                sections: [
                  PieChartSectionData(
                    value: 15,
                    title: "Sehat",
                    radius: 55,
                    color: Colors.green,
                    titleStyle: const TextStyle(
                      color: Colors.white,
                      fontSize: 11,
                    ),
                  ),

                  PieChartSectionData(
                    value: 7,
                    title: "Sedang",
                    radius: 55,
                    color: Colors.orange,
                    titleStyle: const TextStyle(
                      color: Colors.white,
                      fontSize: 11,
                    ),
                  ),

                  PieChartSectionData(
                    value: 2,
                    title: "Berat",
                    radius: 55,
                    color: Colors.red,
                    titleStyle: const TextStyle(
                      color: Colors.white,
                      fontSize: 11,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
