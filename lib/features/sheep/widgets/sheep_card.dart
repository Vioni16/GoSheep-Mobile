import 'package:flutter/material.dart';
import 'package:gosheep_mobile/core/widgets/confirmation_dialog.dart';
import 'package:gosheep_mobile/core/widgets/sheep_icon.dart';
import 'package:gosheep_mobile/data/models/sheep.dart';

class SheepCard extends StatelessWidget {
  final Sheep sheep;
  final Function(BuildContext)? onConfirmDelete;

  const SheepCard({super.key, required this.sheep, this.onConfirmDelete});

  @override
  Widget build(BuildContext context) {
    final isHealthy = sheep.statusUi == 'sehat';
    final isAtRisk = sheep.statusUi == 'at_risk';
    final isMale = sheep.gender == 'male';

    final bg =  isHealthy
        ? const Color(0xFF3B6D11)
        : isAtRisk
        ? const Color(0xFFF5D48A)
        : const Color(0xFFA32D2D);

    final statusLabel = isHealthy
        ? 'Sehat'
        : isAtRisk
        ? 'Berisiko'
        : 'Sakit';

    final genderLabel = isMale ? 'Jantan' : 'Betina';

    return Dismissible(
      key: ValueKey(sheep.id),
      direction: DismissDirection.endToStart,
      confirmDismiss: (direction) async {
        final shouldDelete = await showDialog<bool>(
          context: context,
          builder: (confirmDialogContext) => ConfirmationDialog(
            "Apakah kamu yakin ingin menghapus domba ini?",
            onTap: () {
              Navigator.pop(confirmDialogContext, true);
            },
          ),
        );

        if (shouldDelete == true &&
            context.mounted &&
            onConfirmDelete != null) {
          onConfirmDelete!(context);
        }

        return shouldDelete ?? false;
      },
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
                  SheepIcon(
                    color: isMale ? Colors.blue : Colors.pink,
                    size: 28,
                  ),

                  const SizedBox(width: 14),

                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Text(
                              sheep.earTag,
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            const SizedBox(width: 6),
                            Text(
                              '• $genderLabel',
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
                    ),
                    child: Text(
                      statusLabel,
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: Colors.white
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
