import 'package:flutter/material.dart';
import 'package:gosheep_mobile/data/models/sheep.dart';

class SheepCard extends StatelessWidget {
  final Sheep sheep;
  final double maxBerat;
  final VoidCallback onDelete;
  const SheepCard({
    super.key,
    required this.sheep,
    required this.maxBerat,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    final isHealthy = sheep.statusUi == 'Sehat';
    final bg = isHealthy ? const Color(0xFFEAF3DE) : const Color(0xFFFCEBEB);
    final fg = isHealthy ? const Color(0xFF3B6D11) : const Color(0xFFA32D2D);
    final bar = isHealthy ? const Color(0xFF639922) : const Color(0xFFE24B4A);
    final border = isHealthy ? const Color(0xFFC0DD97) : const Color(0xFFF7C1C1);
    final progress = (sheep.weight / maxBerat).clamp(0.0, 1.0);

    return Dismissible(
      key: ValueKey(sheep.id),
      direction: DismissDirection.endToStart,
      onDismissed: (_) => onDelete(),
      background: Container(
        margin: const EdgeInsets.only(bottom: 10),
        decoration: BoxDecoration(
          color: const Color(0xFFE24B4A),
          borderRadius: BorderRadius.circular(14),
        ),
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.only(right: 20),
        child: const Icon(Icons.delete_outline_rounded, color: Colors.white),
      ),
      child: Container(
        margin: const EdgeInsets.only(bottom: 10),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: Colors.black.withValues(alpha: 0.05)),
        ),
        child: Material(
          color: Colors.transparent,
          borderRadius: BorderRadius.circular(14),
          child: InkWell(
            borderRadius: BorderRadius.circular(14),
            onTap: () {},
            child: Padding(
              padding: const EdgeInsets.all(14),
              child: Row(
                children: [
                  Container(
                    width: 48,
                    height: 48,
                    decoration: BoxDecoration(
                      color: bg,
                      shape: BoxShape.circle,
                    ),
                    child: Icon(Icons.pets_rounded, color: fg, size: 24),
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Text(
                              sheep.name,
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            const SizedBox(width: 6),
                            Text(
                              '• ${sheep.id}',
                              style: const TextStyle(
                                fontSize: 12,
                                color: Colors.black45,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 4),
                        Text(
                          '${sheep.breed}  ·  ${sheep.weight} kg',
                          style: const TextStyle(
                            fontSize: 13,
                            color: Colors.black54,
                          ),
                        ),
                        const SizedBox(height: 8),
                        ClipRRect(
                          borderRadius: BorderRadius.circular(4),
                          child: LinearProgressIndicator(
                            value: progress,
                            backgroundColor: Colors.black.withValues(
                              alpha: 0.04,
                            ),
                            valueColor: AlwaysStoppedAnimation(bar),
                            minHeight: 4,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 12),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      color: bg,
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(color: border),
                    ),
                    child: Text(
                      sheep.statusUi,
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: fg,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}