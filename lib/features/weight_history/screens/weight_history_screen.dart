import 'package:flutter/material.dart';
import 'package:gosheep_mobile/features/weight_history/widgets/weight_card.dart';
import 'package:gosheep_mobile/features/weight_history/widgets/weight_chart_card.dart';

class WeightHistoryScreen extends StatelessWidget {
  const WeightHistoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final List<Map<String, dynamic>> sheepWeights = [
      {
        "id": 1,
        "earTag": "ET017",
        "gender": "Betina",
        "weight": 42,
        "date": "20 Mei 2026",
      },
      {
        "id": 2,
        "earTag": "ET020",
        "gender": "Jantan",
        "weight": 38,
        "date": "18 Mei 2026",
      },
      {
        "id": 3,
        "earTag": "ET024",
        "gender": "Betina",
        "weight": 45,
        "date": "17 Mei 2026",
      },
    ];

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        foregroundColor: Colors.white,
        backgroundColor: Theme.of(context).colorScheme.primary,
        centerTitle: true,
        title: const Text(
          'Riwayat Berat Badan',
          style: TextStyle(fontWeight: FontWeight.w700, fontSize: 18),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const WeightChart(),
            const SizedBox(height: 24),
            const Text(
              "Riwayat Berat Badan Domba",
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w700,
                color: Color(0xFF727272),
              ),
            ),
            const SizedBox(height: 14),
            ...sheepWeights.map((item) => WeightCard(item: item)),
          ],
        ),
      ),
    );
  }
}
