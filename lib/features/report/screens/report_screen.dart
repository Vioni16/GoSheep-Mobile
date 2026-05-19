import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

class ReportScreen extends StatelessWidget {
  const ReportScreen({super.key});

  static const primaryGreen = Color(0xFF0F5132);
  static const softBrown = Color(0xFF8D6E63);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FA),

      appBar: AppBar(
        elevation: 0,
        foregroundColor: Colors.white,
        backgroundColor: Theme.of(context).colorScheme.primary,
        centerTitle: true,
        title: const Text(
          'Laporan Peternakan',
          style: TextStyle(
            fontWeight: FontWeight.w700,
            fontSize: 18,
          ),
        ),
      ),

      body: ListView(
        padding: const EdgeInsets.fromLTRB(16, 12, 16, 20),
        children: [
          const Text(
            "Laporan Peternakan",
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
            ),
          ),

          const SizedBox(height: 4),

          const Text(
            "Pantau statistik dan performa peternakan Anda",
            style: TextStyle(
              color: Colors.grey,
              fontSize: 13,
            ),
          ),

          const SizedBox(height: 22),

          // SUMMARY CARD
          Row(
            children: [
              Expanded(
                child: _summaryCard(
                  title: 'Total Domba',
                  value: '128',
                  icon: Icons.pets,
                ),
              ),

              const SizedBox(width: 14),

              Expanded(
                child: _summaryCard(
                  title: 'Kandang',
                  value: '12',
                  icon: Icons.home_work_rounded,
                ),
              ),
            ],
          ),

          const SizedBox(height: 14),

          Row(
            children: [
              Expanded(
                child: _summaryCard(
                  title: 'Domba Sehat',
                  value: '94%',
                  icon: Icons.favorite,
                ),
              ),

              const SizedBox(width: 14),

              Expanded(
                child: _summaryCard(
                  title: 'Breeding',
                  value: '23',
                  icon: Icons.auto_graph,
                ),
              ),
            ],
          ),

          const SizedBox(height: 24),

          // LINE CHART
          _chartCard(
            title: 'Populasi Domba per Bulan',
            child: SizedBox(
              height: 250,
              child: LineChart(
                LineChartData(
                  gridData: FlGridData(
                    show: true,
                    drawVerticalLine: false,
                  ),

                  borderData: FlBorderData(show: false),

                  titlesData: FlTitlesData(
                    rightTitles: AxisTitles(
                      sideTitles: SideTitles(showTitles: false),
                    ),

                    topTitles: AxisTitles(
                      sideTitles: SideTitles(showTitles: false),
                    ),

                    leftTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        reservedSize: 35,
                      ),
                    ),

                    bottomTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        reservedSize: 38,
                        getTitlesWidget: (value, meta) {
                          const months = [
                            'Jan',
                            'Feb',
                            'Mar',
                            'Apr',
                            'Mei',
                            'Jun',
                          ];

                          return Padding(
                            padding: const EdgeInsets.only(top: 10),
                            child: Text(
                              months[value.toInt()],
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
                      color: primaryGreen,
                      barWidth: 4,
                      dotData: FlDotData(show: true),

                      belowBarData: BarAreaData(
                        show: true,
                        color: primaryGreen.withOpacity(0.15),
                      ),

                      spots: [
                        FlSpot(0, 10),
                        FlSpot(1, 15),
                        FlSpot(2, 13),
                        FlSpot(3, 18),
                        FlSpot(4, 25),
                        FlSpot(5, 22),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),

          const SizedBox(height: 22),

          // BAR CHART
          _chartCard(
            title: 'Distribusi Umur Domba',
            child: SizedBox(
              height: 270,
              child: BarChart(
                BarChartData(
                  alignment: BarChartAlignment.spaceAround,

                  gridData: FlGridData(
                    show: true,
                    drawVerticalLine: false,
                  ),

                  borderData: FlBorderData(show: false),

                  titlesData: FlTitlesData(
                    rightTitles: AxisTitles(
                      sideTitles: SideTitles(showTitles: false),
                    ),

                    topTitles: AxisTitles(
                      sideTitles: SideTitles(showTitles: false),
                    ),

                    leftTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        reservedSize: 35,
                      ),
                    ),

                    bottomTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        reservedSize: 42,
                        getTitlesWidget: (value, meta) {
                          const labels = [
                            '0-6',
                            '7-12',
                            '13-18',
                            '>18',
                          ];

                          return Padding(
                            padding: const EdgeInsets.only(top: 10),
                            child: Text(
                              labels[value.toInt()],
                              style: const TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  ),

                  barGroups: [
                    _barData(0, 40),
                    _barData(1, 25),
                    _barData(2, 18),
                    _barData(3, 12),
                  ],
                ),
              ),
            ),
          ),

          const SizedBox(height: 22),

          // HEALTH CARD
          _chartCard(
            title: 'Statistik Kesehatan',
            child: Column(
              children: [
                _healthTile(
                  title: 'Domba Sehat',
                  percentage: 0.94,
                  color: Colors.green,
                ),

                const SizedBox(height: 18),

                _healthTile(
                  title: 'Dalam Perawatan',
                  percentage: 0.04,
                  color: Colors.orange,
                ),

                const SizedBox(height: 18),

                _healthTile(
                  title: 'Sakit',
                  percentage: 0.02,
                  color: Colors.redAccent,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _summaryCard({
    required String title,
    required String value,
    required IconData icon,
  }) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [
            primaryGreen,
            softBrown,
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),

        borderRadius: BorderRadius.circular(22),

        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 14,
            offset: const Offset(0, 8),
          ),
        ],
      ),

      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CircleAvatar(
            radius: 22,
            backgroundColor: Colors.white.withOpacity(0.18),
            child: Icon(
              icon,
              color: Colors.white,
            ),
          ),

          const SizedBox(height: 18),

          Text(
            value,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 26,
              fontWeight: FontWeight.bold,
            ),
          ),

          const SizedBox(height: 4),

          Text(
            title,
            style: const TextStyle(
              color: Colors.white70,
              fontSize: 13,
            ),
          ),
        ],
      ),
    );
  }

  Widget _chartCard({
    required String title,
    required Widget child,
  }) {
    return Container(
      padding: const EdgeInsets.all(18),

      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),

        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 14,
            offset: const Offset(0, 8),
          ),
        ],
      ),

      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              fontSize: 17,
              fontWeight: FontWeight.w800,
            ),
          ),

          const SizedBox(height: 18),

          child,
        ],
      ),
    );
  }

  static BarChartGroupData _barData(int x, double y) {
    return BarChartGroupData(
      x: x,

      barRods: [
        BarChartRodData(
          toY: y,
          width: 20,
          borderRadius: BorderRadius.circular(10),

          gradient: const LinearGradient(
            colors: [
              primaryGreen,
              softBrown,
            ],
            begin: Alignment.bottomCenter,
            end: Alignment.topCenter,
          ),
        ),
      ],
    );
  }

  Widget _healthTile({
    required String title,
    required double percentage,
    required Color color,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              title,
              style: const TextStyle(
                fontWeight: FontWeight.w600,
              ),
            ),

            Text(
              '${(percentage * 100).toInt()}%',
              style: const TextStyle(
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),

        const SizedBox(height: 10),

        ClipRRect(
          borderRadius: BorderRadius.circular(20),
          child: LinearProgressIndicator(
            value: percentage,
            minHeight: 10,
            backgroundColor: Colors.grey.shade300,
            valueColor: AlwaysStoppedAnimation(color),
          ),
        ),
      ],
    );
  }
}