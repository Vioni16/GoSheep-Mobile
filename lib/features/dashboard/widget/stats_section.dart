import 'package:flutter/material.dart';

class StatsSection extends StatelessWidget {
  const StatsSection({super.key});

  @override
  Widget build(BuildContext context) {
    const stats = [
      _StatItem(title: 'Total Domba', value: '120', icon: Icons.pets_rounded),
      _StatItem(title: 'Siap Breeding', value: '98', icon: Icons.favorite_rounded),
      _StatItem(title: 'Sedang Bunting', value: '15', icon: Icons.access_time_rounded),
      _StatItem(title: 'Perlu Diperhatikan', value: '7', icon: Icons.warning_amber_rounded),
    ];

    const gradients = [
      LinearGradient(
        colors: [Color(0xFF2044BD), Color(0xFF66BB6A)],
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
      ),
      LinearGradient(
        colors: [Color(0xFF66BB6A), Color(0xFF2044BD)],
        begin: Alignment.bottomLeft,
        end: Alignment.topRight,
      ),
      LinearGradient(
        colors: [Color(0xFF2044BD), Color(0xFF66BB6A)],
        begin: Alignment.bottomLeft,
        end: Alignment.topRight,
      ),
      LinearGradient(
        colors: [Color(0xFF2044BD), Color(0xFF66BB6A)],
        begin: Alignment.bottomRight,
        end: Alignment.topLeft,
      ),
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              'Statistik Kandang',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: Color.fromARGB(255, 115, 115, 115),
              ),
            ),
            Text(
              'Hari ini',
              style: TextStyle(fontSize: 12, color: Colors.grey.shade400),
            ),
          ],
        ),

        const SizedBox(height: 12),

        GridView.builder(
          itemCount: stats.length,
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            crossAxisSpacing: 10,
            mainAxisSpacing: 10,
            childAspectRatio: 2.4,
          ),
          itemBuilder: (context, index) => _StatCard(
            item: stats[index],
            gradient: gradients[index],
          ),
        ),
      ],
    );
  }
}

class _StatCard extends StatelessWidget {
  final _StatItem item;
  final LinearGradient gradient;

  const _StatCard({required this.item, required this.gradient});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              gradient: gradient,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(item.icon, color: Colors.white, size: 20),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  item.value,
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.w600,
                    color: Colors.grey[800],
                    height: 1.1,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  item.title,
                  style: TextStyle(
                    fontSize: 11,
                    color: Color.fromARGB(255, 115, 115, 115)
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _StatItem {
  final String title;
  final String value;
  final IconData icon;

  const _StatItem({
    required this.title,
    required this.value,
    required this.icon,
  });
}