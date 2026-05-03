import 'package:flutter/material.dart';

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
          style: TextStyle(fontWeight: FontWeight.w700, fontSize: 18),
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(16, 12, 16, 20),
        children: [
          const Text(
            "Riwayat Ternak",
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 4),
          const Text(
            "Pantau perubahan status ternak dengan mudah dan cepat",
            style: TextStyle(color: Colors.grey, fontSize: 13),
          ),

          const SizedBox(height: 16),

          Row(
            children: [
              _summaryBox("1", "Terjual", Colors.green),
              const SizedBox(width: 10),
              _summaryBox("1", "Mati", Colors.red),
              const SizedBox(width: 10),
              _summaryBox("1", "Pindah", Colors.orange),
            ],
          ),

          const SizedBox(height: 16),

          ...data.map((item) => _LivestockCard(item: item)).toList(),
        ],
      ),
    );
  }

  Widget _summaryBox(String value, String label, Color color) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 14),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.05),
              blurRadius: 6,
            ),
          ],
        ),
        child: Column(
          children: [
            Text(
              value,
              style: TextStyle(
                color: color,
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              label,
              style: const TextStyle(fontSize: 12, color: Colors.grey),
            ),
          ],
        ),
      ),
    );
  }
}

class _LivestockCard extends StatelessWidget {
  final Map<String, dynamic> item;

  const _LivestockCard({required this.item});

  Color get _statusColor {
    switch (item["status"]) {
      case "Terjual":
        return Colors.green;
      case "Mati":
        return Colors.red;
      default:
        return Colors.orange;
    }
  }

  @override
  Widget build(BuildContext context) {
    final color = _statusColor;

    final name = item["name"] ?? "-";
    final type = item["type"] ?? "-";
    final date = item["date"] ?? "-";
    final status = item["status"] ?? "-";

    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border(left: BorderSide(color: color, width: 3)),
        boxShadow: [
          BoxShadow(color: Colors.black.withValues(alpha: 0.05), blurRadius: 6),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: type == "Jantan"
                  ? Colors.green.withValues(alpha: 0.1)
                  : Colors.pink.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(
              Icons.pets,
              color: type == "Jantan" ? Colors.green : Colors.pink,
            ),
          ),

          const SizedBox(width: 12),

          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  name,
                  style: const TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 15,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  type,
                  style: const TextStyle(color: Colors.grey, fontSize: 12),
                ),
                const SizedBox(height: 6),
                Row(
                  children: [
                    const Icon(
                      Icons.calendar_today,
                      size: 12,
                      color: Colors.grey,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      date,
                      style: const TextStyle(fontSize: 12, color: Colors.grey),
                    ),
                  ],
                ),
              ],
            ),
          ),

          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text(
              status,
              style: TextStyle(
                color: color,
                fontSize: 11,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
