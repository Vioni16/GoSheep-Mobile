import 'package:flutter/material.dart';

class StatsSection extends StatelessWidget {
  const StatsSection({super.key});

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;

    const stats = [
      _StatItem(title: 'Total Domba', value: '120', icon: Icons.pets_rounded),
      _StatItem(title: 'Siap Breeding', value: '98', icon: Icons.favorite_rounded),
      _StatItem(title: 'Sedang Bunting', value: '15', icon: Icons.access_time_rounded),
      _StatItem(title: 'Perlu Diperhatikan', value: '7', icon: Icons.warning_amber_rounded),
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Statistik Kandang',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: scheme.onSurface,
              ),
            ),
            Text(
              'Hari ini',
              style: TextStyle(
                fontSize: 12,
                color: scheme.onSurfaceVariant,
              ),
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
            childAspectRatio: 2.2,
          ),
          itemBuilder: (context, index) => _StatCard(
            item: stats[index],
          ),
        ),
      ],
    );
  }
}

class _StatCard extends StatelessWidget {
  final _StatItem item;

  const _StatCard({required this.item});

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      decoration: BoxDecoration(
        color: scheme.surface,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: scheme.outlineVariant),
      ),
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: scheme.primaryContainer,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(
              item.icon,
              color: scheme.onPrimaryContainer,
              size: 20,
            ),
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
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                    color: scheme.onSurface,
                    height: 1.1,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  item.title,
                  style: TextStyle(
                    fontSize: 11,
                    color: scheme.onSurfaceVariant,
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