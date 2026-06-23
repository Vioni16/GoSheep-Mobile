import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:gosheep_mobile/data/models/farm_report.dart';
import 'package:gosheep_mobile/data/providers/report_provider.dart';

class ReportScreen extends StatelessWidget {
  const ReportScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => ReportProvider(),
      child: const _ReportScreenView(),
    );
  }
}

class _ReportScreenView extends StatefulWidget {
  const _ReportScreenView();

  @override
  State<_ReportScreenView> createState() => _ReportScreenViewState();
}

class _ReportScreenViewState extends State<_ReportScreenView> {
  static const primaryGreen = Color(0xFF0F5132);
  static const softBrown = Color(0xFF8D6E63);

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<ReportProvider>().loadReport();
    });
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<ReportProvider>();

    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FA),
      appBar: AppBar(
        elevation: 0,
        foregroundColor: Colors.white,
        backgroundColor: Theme.of(context).colorScheme.primary,
        centerTitle: true,
        title: const Text(
          'Laporan Peternakan',
          style: TextStyle(fontWeight: FontWeight.w700, fontSize: 18),
        ),
      ),
      body: _buildBody(provider),
    );
  }

  Widget _buildBody(ReportProvider provider) {
    if (provider.isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (provider.error != null) {
      return Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.cloud_off, size: 48, color: Colors.grey),
            const SizedBox(height: 12),
            Text(
              provider.error!,
              textAlign: TextAlign.center,
              style: const TextStyle(color: Colors.grey),
            ),
            const SizedBox(height: 12),
            ElevatedButton(
              onPressed: () => context.read<ReportProvider>().loadReport(),
              child: const Text('Coba Lagi'),
            ),
          ],
        ),
      );
    }

    final report = provider.report;
    if (report == null) {
      return const SizedBox.shrink();
    }

    return _buildContent(report);
  }

  Widget _buildContent(FarmReport report) {
    final summary = report.summary;
    final health = report.healthStats;
    final totalHealth =
        health.healthyTotal + health.atRiskTotal + health.sickTotal;

    double healthRatio(int value) =>
        totalHealth > 0 ? value / totalHealth : 0;

    return ListView(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 20),
      children: [
        const Text(
          "Laporan Peternakan",
          style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 4),
        const Text(
          "Pantau statistik dan performa peternakan Anda",
          style: TextStyle(color: Colors.grey, fontSize: 13),
        ),
        const SizedBox(height: 22),

        // SUMMARY CARD
        Row(
          children: [
            Expanded(
              child: _summaryCard(
                title: 'Total Domba',
                value: '${summary.totalSheep}',
                icon: Icons.pets,
              ),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: _summaryCard(
                title: 'Kandang',
                value: '${summary.totalCages}',
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
                value: '${summary.healthyPercentage.toStringAsFixed(0)}%',
                icon: Icons.favorite,
              ),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: _summaryCard(
                title: 'Breeding',
                value: '${summary.breedingTotal}',
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
                lineTouchData: LineTouchData(
                  touchTooltipData: LineTouchTooltipData(
                    getTooltipColor: (_) => Colors.white,
                    tooltipBorder: BorderSide(
                      color: Colors.grey.shade300,
                      width: 1,
                    ),
                    getTooltipItems: (touchedSpots) {
                      return touchedSpots.map((spot) {
                        return LineTooltipItem(
                          '${spot.y.toInt()}',
                          const TextStyle(
                            color: Colors.black87,
                            fontWeight: FontWeight.bold,
                          ),
                        );
                      }).toList();
                    },
                  ),
                ),
                gridData: FlGridData(show: true, drawVerticalLine: false),
                borderData: FlBorderData(show: false),
                titlesData: FlTitlesData(
                  rightTitles: AxisTitles(
                    sideTitles: SideTitles(showTitles: false),
                  ),
                  topTitles: AxisTitles(
                    sideTitles: SideTitles(showTitles: false),
                  ),
                  leftTitles: AxisTitles(
                    sideTitles: SideTitles(showTitles: true, reservedSize: 35),
                  ),
                  bottomTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      reservedSize: 38,
                      getTitlesWidget: (value, meta) {
                        final index = value.toInt();
                        if (index < 0 ||
                            index >= report.populationPerMonth.length) {
                          return const SizedBox.shrink();
                        }
                        return Padding(
                          padding: const EdgeInsets.only(top: 10),
                          child: Text(
                            _monthLabelId(
                                report.populationPerMonth[index].month),
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
                      for (int i = 0; i < report.populationPerMonth.length; i++)
                        FlSpot(
                          i.toDouble(),
                          report.populationPerMonth[i].total.toDouble(),
                        ),
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
                barTouchData: BarTouchData(
                  touchTooltipData: BarTouchTooltipData(
                    getTooltipColor: (_) => Colors.white,
                    tooltipBorder: BorderSide(
                      color: Colors.grey.shade300,
                      width: 1,
                    ),
                    getTooltipItem: (group, groupIndex, rod, rodIndex) {
                      return BarTooltipItem(
                        rod.toY.toInt().toString(),
                        const TextStyle(
                          color: Colors.black87,
                          fontWeight: FontWeight.bold,
                        ),
                      );
                    },
                  ),
                ),
                gridData: FlGridData(show: true, drawVerticalLine: false),
                borderData: FlBorderData(show: false),
                titlesData: FlTitlesData(
                  rightTitles: AxisTitles(
                    sideTitles: SideTitles(showTitles: false),
                  ),
                  topTitles: AxisTitles(
                    sideTitles: SideTitles(showTitles: false),
                  ),
                  leftTitles: AxisTitles(
                    sideTitles: SideTitles(showTitles: true, reservedSize: 35),
                  ),
                  bottomTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      reservedSize: 42,
                      getTitlesWidget: (value, meta) {
                        final index = value.toInt();
                        if (index < 0 ||
                            index >= report.ageDistribution.length) {
                          return const SizedBox.shrink();
                        }
                        return Padding(
                          padding: const EdgeInsets.only(top: 10),
                          child: Text(
                            report.ageDistribution[index].range,
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
                  for (int i = 0; i < report.ageDistribution.length; i++)
                    _barData(
                      i,
                      report.ageDistribution[i].total.toDouble(),
                    ),
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
                percentage: healthRatio(health.healthyTotal),
                color: Colors.green,
              ),
              const SizedBox(height: 18),
              _healthTile(
                title: 'Dalam Perawatan',
                percentage: healthRatio(health.atRiskTotal),
                color: Colors.orange,
              ),
              const SizedBox(height: 18),
              _healthTile(
                title: 'Sakit',
                percentage: healthRatio(health.sickTotal),
                color: Colors.redAccent,
              ),
            ],
          ),
        ),
      ],
    );
  }

  String _monthLabelId(String enMonth) {
    const map = {
      'Jan': 'Jan',
      'Feb': 'Feb',
      'Mar': 'Mar',
      'Apr': 'Apr',
      'May': 'Mei',
      'Jun': 'Jun',
      'Jul': 'Jul',
      'Aug': 'Agu',
      'Sep': 'Sep',
      'Oct': 'Okt',
      'Nov': 'Nov',
      'Dec': 'Des',
    };
    return map[enMonth] ?? enMonth;
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
          colors: [primaryGreen, softBrown],
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
            child: Icon(icon, color: Colors.white),
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
            style: const TextStyle(color: Colors.white70, fontSize: 13),
          ),
        ],
      ),
    );
  }

  Widget _chartCard({required String title, required Widget child}) {
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
            style: const TextStyle(fontSize: 17, fontWeight: FontWeight.w800),
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
            colors: [primaryGreen, softBrown],
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
              style: const TextStyle(fontWeight: FontWeight.w600),
            ),
            Text(
              '${(percentage * 100).toInt()}%',
              style: const TextStyle(fontWeight: FontWeight.bold),
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
