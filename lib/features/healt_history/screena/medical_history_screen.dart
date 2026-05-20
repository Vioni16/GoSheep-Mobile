import 'package:flutter/material.dart';
import 'package:gosheep_mobile/core/theme/theme.dart';
import 'package:gosheep_mobile/features/healt_history/widgets/health_card.dart';
import 'package:gosheep_mobile/features/healt_history/widgets/health_chart_card.dart';
import 'package:gosheep_mobile/features/healt_history/widgets/health_statistics_header.dart';

class HealthHistoryScreen extends StatelessWidget {
  HealthHistoryScreen({super.key});

  final List<Map<String, dynamic>> healthData = [
    {
      "id": 1,
      "earTag": "ET017",
      "gender": "Betina",
      "category": "Pemeriksaan",
      "condition": "Demam ringan",
      "severity": "Sedang",
      "date": "12 Mei 2026",
    },

    {
      "id": 2,
      "earTag": "ET020",
      "gender": "Jantan",
      "category": "Vitamin",
      "condition": "Kondisi sehat",
      "severity": "Ringan",
      "date": "10 Mei 2026",
    },

    {
      "id": 3,
      "earTag": "ET031",
      "gender": "Betina",
      "category": "Infeksi",
      "condition": "Infeksi kulit",
      "severity": "Berat",
      "date": "08 Mei 2026",
    },

    {
      "id": 4,
      "earTag": "ET015",
      "gender": "Jantan",
      "category": "Pemeriksaan",
      "condition": "Nafsu makan menurun",
      "severity": "Sedang",
      "date": "06 Mei 2026",
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,

      appBar: AppBar(
        elevation: 0,
        centerTitle: true,
        foregroundColor: Colors.white,
        backgroundColor: Theme.of(context).colorScheme.primary,

        title: const Text(
          "Riwayat Kesehatan",
          style: TextStyle(
            fontWeight: FontWeight.w700,
            fontSize: 18,
          ),
        ),
      ),

      body: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(16, 16, 16, 24),

        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [

            // statistik
            const HealthStatisticsHeader(
              totalRecords: 24,
              healthyCount: 15,
              attentionCount: 9,
            ),

            const SizedBox(height: 16),

            // chart
            const HealthChartCard(),

            const SizedBox(height: 20),

            Text(
              "Riwayat Pemeriksaan",
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w700,
                color: const Color(0xFF2D3132),
              ),
            ),

            const SizedBox(height: 14),

            ListView.builder(
              itemCount: healthData.length,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),

              itemBuilder: (context, index) {
                return HealthCard(
                  item: healthData[index],
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}