import 'package:flutter/material.dart';
import 'package:gosheep_mobile/data/models/cage.dart';
import 'package:gosheep_mobile/features/cage/widgets/ear_tag_chip.dart';
import 'package:gosheep_mobile/features/sheep/screens/sheep_detail_screen.dart';
import 'package:intl/intl.dart';

import 'cage_sheep_sheet.dart';

class CageCard extends StatelessWidget {
  final Cage cage;

  const CageCard({super.key, required this.cage});

  void _onCardTap(BuildContext context) {
    final List<CageSheep> sheep = cage.sheep;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => CageSheepSheet(
        cageName: cage.name,
        sheep: sheep,
      ),
    );
  }

  Color _capacityColor(double ratio) {
    if (ratio >= 1.0) return const Color(0xFF2E7D32);
    if (ratio >= 0.75) return const Color(0xFFD85A30);
    return const Color(0xFF1D9E75);
  }

  Color _badgeFg(String status) {
    switch (status.toLowerCase()) {
      case 'penuh':
        return const Color(0xFF633806);
      case 'hampir penuh':
        return const Color(0xFF501313);
      default:
        return const Color(0xFF1B5E20);
    }
  }

  @override
  Widget build(BuildContext context) {
    final ratio = cage.currentCapacity / cage.maxCapacity;
    final capColor = _capacityColor(ratio);

    final visibleSheep = cage.sheep.take(8).toList();
    final hasMore = cage.sheep.length > 8;
    final remaining = cage.sheep.length - 8;

    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: () => _onCardTap(context),
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: Colors.black.withValues(alpha: 0.08),
              width: 0.5,
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [

              Padding(
                padding: const EdgeInsets.fromLTRB(14, 12, 14, 10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          cage.name,
                          style: const TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 9,
                            vertical: 3,
                          ),
                          decoration: BoxDecoration(
                            color: Color(0xFFFAEEDA),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Text(
                            cage.statusLabel,
                            style: TextStyle(
                              fontSize: 11,
                              fontWeight: FontWeight.w500,
                              color: _badgeFg(cage.statusLabel),
                            ),
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 8),

                    Row(
                      children: [
                        Text(
                          '${cage.currentCapacity} / ${cage.maxCapacity}',
                          style: TextStyle(
                            fontSize: 12,
                            color: Theme.of(context).colorScheme.onSurfaceVariant,
                          ),
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(4),
                            child: LinearProgressIndicator(
                              value: ratio.clamp(0.0, 1.0),
                              minHeight: 6,
                              backgroundColor: Theme.of(
                                context,
                              ).colorScheme.surfaceContainerHighest,
                              valueColor:
                              AlwaysStoppedAnimation<Color>(capColor),
                            ),
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 6),

                    Text(
                      'Dibuat ${DateFormat('d MMM yyyy', 'id').format(cage.createdAt)}',
                      style: TextStyle(
                        fontSize: 11,
                        color: Theme.of(context).colorScheme.onSurfaceVariant,
                      ),
                    ),
                  ],
                ),
              ),

              Divider(
                height: 1,
                thickness: 0.5,
                color: Colors.black.withValues(alpha: 0.08),
              ),

              Padding(
                padding: const EdgeInsets.fromLTRB(14, 8, 14, 12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Domba (${cage.sheep.length})',
                      style: TextStyle(
                        fontSize: 12,
                        color: Theme.of(context).colorScheme.onSurfaceVariant,
                      ),
                    ),

                    const SizedBox(height: 6),

                    cage.sheep.isEmpty
                        ? Text(
                      'Belum ada domba',
                      style: TextStyle(
                        fontSize: 12,
                        color: Theme.of(context).colorScheme.onSurfaceVariant,
                        fontStyle: FontStyle.italic,
                      ),
                    )
                        : Wrap(
                      spacing: 5,
                      runSpacing: 5,
                      children: [
                        ...visibleSheep.map((s) {
                          return EarTagChip(
                            sheep: s,
                            onTap: () {
                              Navigator.push(
                                context, 
                                MaterialPageRoute(
                                  builder: (context) => SheepDetailScreen(id: s.id),
                                )
                              );
                            }
                          );
                        }),

                        if (hasMore)
                          Material(
                            color: Colors.transparent,
                            child: InkWell(
                              borderRadius: BorderRadius.circular(20),
                              onTap: () => _onCardTap(context),
                              child: Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 10,
                                  vertical: 3,
                                ),
                                decoration: BoxDecoration(
                                  color: const Color(0xFFE0E0E0),
                                  borderRadius: BorderRadius.circular(20),
                                  border: Border.all(
                                    color: const Color(0xFFBDBDBD),
                                  ),
                                ),
                                child: Text(
                                  '+$remaining lainnya',
                                  style: const TextStyle(
                                    fontSize: 11,
                                    fontWeight: FontWeight.w500,
                                    color: Color(0xFF424242),
                                  ),
                                ),
                              ),
                            ),
                          ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}