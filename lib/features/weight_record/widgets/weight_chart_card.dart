import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:gosheep_mobile/core/theme/theme.dart';
import 'package:gosheep_mobile/data/models/statistics/weight_statistic.dart';
import 'package:gosheep_mobile/features/weight_record/widgets/weight_chart_skeleton.dart';

class WeightChart extends StatefulWidget {
  final WeightStatistic? statistic;
  final int? selectedYear;
  final bool isLoading;
  final Function(int)? onYearChanged;

  const WeightChart({
    super.key,
    this.statistic,
    this.selectedYear,
    this.onYearChanged,
    this.isLoading = false,
  });

  @override
  State<WeightChart> createState() => _WeightChartState();
}

class _WeightChartState extends State<WeightChart> {
  late int _selectedYear;

  @override
  void initState() {
    super.initState();
    _selectedYear = widget.selectedYear ?? DateTime.now().year;
  }

  @override
  void didUpdateWidget(WeightChart oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.selectedYear != null && widget.selectedYear != _selectedYear) {
      _selectedYear = widget.selectedYear!;
    }
  }

  List<FlSpot> _generateSpots() {
    final stats = widget.statistic?.statistics ?? [];
    final validStats = stats.where((stat) => stat.hasData).toList();
    return List.generate(validStats.length, (index) {
      return FlSpot(index.toDouble(), validStats[index].avgWeight!);
    });
  }

  @override
  Widget build(BuildContext context) {
    if (widget.isLoading || widget.statistic == null) {
      return const WeightChartSkeleton();
    }

    return _ChartView(
      statistic: widget.statistic,
      selectedYear: _selectedYear,
      onYearChanged: (year) {
        setState(() => _selectedYear = year);
        widget.onYearChanged?.call(year);
      },
      spots: _generateSpots(),
    );
  }
}

class _ChartView extends StatelessWidget {
  final WeightStatistic? statistic;
  final int selectedYear;
  final Function(int) onYearChanged;
  final List<FlSpot> spots;

  const _ChartView({
    required this.statistic,
    required this.selectedYear,
    required this.onYearChanged,
    required this.spots,
  });

  @override
  Widget build(BuildContext context) {
    double minY = 20;
    double maxY = 60;

    if (spots.isNotEmpty) {
      final yValues = spots.map((e) => e.y).toList();
      minY = yValues.reduce((a, b) => a < b ? a : b);
      maxY = yValues.reduce((a, b) => a > b ? a : b);

      minY = (minY - 5).clamp(0, double.infinity);
      maxY = maxY + 5;
    }

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
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                "Rata-rata Berat per Bulan",
                style: TextStyle(fontSize: 15, fontWeight: FontWeight.w700),
              ),
              DropdownButton<int>(
                value: selectedYear,
                underline: const SizedBox(),
                items: List.generate(5, (i) {
                  final year = DateTime.now().year - i;
                  return DropdownMenuItem(
                    value: year,
                    child: Text(
                      year.toString(),
                      style: const TextStyle(fontSize: 13),
                    ),
                  );
                }).toList(),
                onChanged: (year) {
                  if (year != null) {
                    onYearChanged(year);
                  }
                },
              ),
            ],
          ),
          const SizedBox(height: 20),
          SizedBox(
            height: 220,
            child: spots.isEmpty
                ? const Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.bar_chart_outlined,
                          size: 48,
                          color: Colors.black12,
                        ),
                        SizedBox(height: 8),
                        Text(
                          'Tidak ada data di tahun ini',
                          style: TextStyle(color: Colors.black38, fontSize: 13),
                        ),
                      ],
                    ),
                  )
                : LineChart(
                    LineChartData(
                      lineTouchData: LineTouchData(
                        touchTooltipData: LineTouchTooltipData(
                          getTooltipColor: (_) =>
                              AppTheme.primaryGreen.withValues(alpha: 0.9),
                          tooltipRoundedRadius: 8,
                          getTooltipItems: (touchedSpots) {
                            return touchedSpots.map((spot) {
                              final validStats = (statistic?.statistics ?? [])
                                  .where((stat) => stat.hasData)
                                  .toList();

                              final index = spot.spotIndex;
                              final monthName = index < validStats.length
                                  ? validStats[index].monthName
                                  : '';

                              return LineTooltipItem(
                                '$monthName\n${spot.y.toStringAsFixed(1)} kg',
                                const TextStyle(
                                  color: Colors.white,
                                  fontSize: 12,
                                  fontWeight: FontWeight.w600,
                                  height: 1.5,
                                ),
                              );
                            }).toList();
                          },
                        ),
                      ),
                      minY: minY,
                      maxY: maxY,
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
                            interval: 1,
                            getTitlesWidget: (value, meta) {
                              if (value % 1 != 0) return const SizedBox();

                              final validStats = (statistic?.statistics ?? [])
                                  .where((stat) => stat.hasData)
                                  .toList();

                              final index = value.toInt();
                              if (index < 0 || index >= validStats.length) {
                                return const SizedBox();
                              }

                              final stat = validStats[index];
                              final monthLabel = stat.monthName.substring(0, 3);

                              return Padding(
                                padding: const EdgeInsets.only(top: 8),
                                child: Text(
                                  monthLabel,
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
                          curveSmoothness: 0.35,
                          color: AppTheme.primaryGreen,
                          barWidth: 2.5,
                          belowBarData: BarAreaData(
                            show: true,
                            gradient: LinearGradient(
                              begin: Alignment.topCenter,
                              end: Alignment.bottomCenter,
                              colors: [
                                AppTheme.primaryGreen.withValues(alpha: 0.25),
                                AppTheme.primaryGreen.withValues(alpha: 0.0),
                              ],
                            ),
                          ),
                          dotData: FlDotData(
                            show: true,
                            getDotPainter: (spot, percent, bar, index) =>
                                FlDotCirclePainter(
                                  radius: 4,
                                  color: Colors.white,
                                  strokeWidth: 2,
                                  strokeColor: AppTheme.primaryGreen,
                                ),
                          ),
                          spots: spots,
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
