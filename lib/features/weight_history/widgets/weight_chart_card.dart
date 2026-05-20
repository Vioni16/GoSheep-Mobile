import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:gosheep_mobile/core/theme/theme.dart';

class WeightChart extends StatelessWidget {
  const WeightChart({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "Rata-rata Berat per Bulan",
            style: TextStyle(fontSize: 15, fontWeight: FontWeight.w700),
          ),
          const SizedBox(height: 20),
          SizedBox(
            height: 220,
            child: LineChart(
              LineChartData(
                minY: 20,
                maxY: 60,
                gridData: FlGridData(
                  show: true,
                  horizontalInterval: 10,
                  drawVerticalLine: false,
                ),
                borderData: FlBorderData(show: false),
                titlesData: FlTitlesData(
                  topTitles: const AxisTitles(
                    sideTitles: SideTitles(showTitles: false),
                  ),
                  rightTitles: const AxisTitles(
                    sideTitles: SideTitles(showTitles: false),
                  ),
                  leftTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      reservedSize: 30,
                      getTitlesWidget: (value, meta) => Text(
                        value.toInt().toString(),
                        style: const TextStyle(fontSize: 11),
                      ),
                    ),
                  ),
                  bottomTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      interval:
                          1,
                      getTitlesWidget: (value, meta) {
                        if (value % 1 != 0) return const SizedBox();

                        final months = [
                          "Jan",
                          "Feb",
                          "Mar",
                          "Apr",
                          "Mei",
                          "Jun",
                        ];
                        final index = value.toInt();

                        if (index < 0 || index >= months.length)
                          return const SizedBox();

                        return Padding(
                          padding: const EdgeInsets.only(top: 8),
                          child: Text(
                            months[index],
                            style: const TextStyle(fontSize: 11),
                          ),
                        );
                      },
                    ),
                  ),
                ),
                lineBarsData: [
                  LineChartBarData(
                    isCurved: true,
                    color: AppTheme.primaryGreen,
                    barWidth: 3,
                    belowBarData: BarAreaData(
                      show: true,
                      color: AppTheme.primaryGreen.withOpacity(0.12),
                    ),
                    dotData: const FlDotData(show: true),
                    spots: const [
                      FlSpot(0, 30),
                      FlSpot(1, 34),
                      FlSpot(2, 33),
                      FlSpot(3, 40),
                      FlSpot(4, 49),
                      FlSpot(5, 45),
                    ],
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
