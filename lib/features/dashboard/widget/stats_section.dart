import 'package:flutter/material.dart';

class StatsSection extends StatelessWidget {
  const StatsSection({super.key});

  @override
  Widget build(BuildContext context) {
    final stats = [
      {
        "title": "Total Domba",
        "value": "120",
        "icon": Icons.pets,
        "color": Colors.green,
      },
      {
        "title": "Siap Breeding",
        "value": "98",
        "icon": Icons.favorite,
        "color": const Color.fromARGB(255, 245, 226, 58),
      },
      {
        "title": "Sedang Bunting",
        "value": "15",
        "icon": Icons.access_time,
        "color": Color.fromARGB(255, 92, 188, 226),
      },
      {
        "title": "Perlu Diperhatikan",
        "value": "7",
        "icon": Icons.timeline,
        "color": Color.fromARGB(255, 227, 94, 92),
      },
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Statistik Kandang',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: Color.fromARGB(255, 115, 115, 115),
          ),
        ),
        const SizedBox(height: 5),

        GridView.builder(
          itemCount: stats.length,
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            crossAxisSpacing: 12,
            mainAxisSpacing: 12,
            childAspectRatio: 1.3,
          ),
          itemBuilder: (context, index) {
            final item = stats[index];

            return Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.04),
                    blurRadius: 8,
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: (item["color"] as Color).withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Icon(
                      item["icon"] as IconData,
                      color: item["color"] as Color,
                      size: 25,
                    ),
                  ),

                  const Spacer(),

                  Text(
                    item["value"] as String,
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: item["color"] as Color,
                    ),
                  ),

                  const SizedBox(height: 4),

                  Text(
                    item["title"] as String,
                    style: const TextStyle(
                      color: Color.fromARGB(255, 142, 142, 142),
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ],
    );
  }
}
