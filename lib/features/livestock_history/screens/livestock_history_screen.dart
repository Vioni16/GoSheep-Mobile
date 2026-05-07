import 'package:flutter/material.dart';
import 'package:gosheep_mobile/features/livestock_history/widgets/livestock_history_card.dart';
import 'package:gosheep_mobile/features/livestock_history/widgets/livestock_summary_box.dart';

class LivestockHistoryScreen extends StatelessWidget {
  const LivestockHistoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final data = [
      {
        "name": "Domba A",
        "type": "Jantan",
        "date": "10 Mei 2026",
        "status": "Terjual",
      },
      {
        "name": "Domba B",
        "type": "Betina",
        "date": "8 Mei 2026",
        "status": "Mati",
      },
      {
        "name": "Domba C",
        "type": "Jantan",
        "date": "5 Mei 2026",
        "status": "Dipindahkan",
      },
    ];

    return Scaffold(
      appBar: AppBar(
        foregroundColor: Colors.white,
        backgroundColor: Theme.of(context).colorScheme.primary,
        centerTitle: true,
        title: const Text(
          'Riwayat Ternak',
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
            "Riwayat Ternak",
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),

          const SizedBox(height: 4),

          const Text(
            "Pantau perubahan status ternak dengan mudah dan cepat",
            style: TextStyle(
              color: Colors.grey,
              fontSize: 13,
            ),
          ),

          const SizedBox(height: 16),

          Row(
            children: [
              const Expanded(
                child: LivestockSummaryBox(
                  value: "1",
                  label: "Terjual",
                  color: Colors.green,
                ),
              ),

              const SizedBox(width: 10),

              const Expanded(
                child: LivestockSummaryBox(
                  value: "1",
                  label: "Mati",
                  color: Colors.red,
                ),
              ),

              const SizedBox(width: 10),

              const Expanded(
                child: LivestockSummaryBox(
                  value: "1",
                  label: "Pindah",
                  color: Colors.orange,
                ),
              ),
            ],
          ),

          const SizedBox(height: 20),

          const Text(
            "Aktivitas Terbaru",
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),

          const SizedBox(height: 14),

          ...data.map(
            (item) => LivestockHistoryCard(item: item),
          ),
        ],
      ),
    );
  }
}