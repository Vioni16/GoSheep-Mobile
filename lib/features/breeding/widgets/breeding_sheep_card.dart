import 'package:flutter/material.dart';
import 'package:gosheep_mobile/core/theme/theme.dart';
import 'package:gosheep_mobile/core/widgets/marquee_text.dart';
import 'package:gosheep_mobile/core/widgets/sheep_chip.dart';
import 'package:gosheep_mobile/core/widgets/sheep_icon.dart';
import 'package:gosheep_mobile/data/models/sheep_breeding.dart';
import 'package:gosheep_mobile/features/sheep/screens/sheep_detail_screen.dart';

class BreedingSheepCard extends StatelessWidget {
  final SheepBreeding sheep;
  final VoidCallback onTap;

  const BreedingSheepCard({
    super.key,
    required this.sheep,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final isEligible = sheep.isEligible;
    final String statusText;
    final Color badgeText;

    if (isEligible) {
      statusText = 'Siap Kawin';
      badgeText = const Color(0xFF0F5132);
    } else {
      switch (sheep.breedingStatus) {
        case 'Sedang Bunting':
          statusText = 'Sedang Bunting';
          badgeText = const Color(0xFF8D6E63);
          break;
        case 'Proses Kawin':
          statusText = 'Proses Kawin';
          badgeText = const Color(0xFF1E88E5);
          break;
        case 'Belum Cukup Umur':
          statusText = 'Belum Cukup Umur';
          badgeText = Colors.red.shade700;
          break;
        case 'Data Belum Lengkap':
        default:
          statusText = 'Belum Lengkap';
          badgeText = const Color(0xFF546E7A);
          break;
      }
    }

    final isFemale = sheep.gender.toLowerCase() == 'female';
    final genderColor = isFemale
        ? const Color(0xFFE91E63)
        : const Color(0xFF2196F3);
    final genderBgColor = isFemale
        ? const Color(0xFFFCE4EC)
        : const Color(0xFFE3F2FD);

    return Opacity(
      opacity: isEligible ? 1.0 : 0.6,
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: const Color(0xFFEEEEEE)),
          boxShadow: [
            BoxShadow(
              color: const Color(0x05000000),
              blurRadius: 8,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Material(
          color: Colors.transparent,
          borderRadius: BorderRadius.circular(14),
          child: InkWell(
            borderRadius: BorderRadius.circular(14),
            onTap: isEligible ? onTap : null,
            child: Padding(
              padding: const EdgeInsets.all(14),
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: genderBgColor,
                      shape: BoxShape.circle,
                    ),
                    child: SheepIcon(color: genderColor, size: 24),
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            SheepChip(
                              label: sheep.eartag,
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (_) =>
                                        SheepDetailScreen(id: sheep.id),
                                  ),
                                );
                              },
                            ),
                            const SizedBox(width: 10),
                            Expanded(
                              child: MarqueeText(
                                text: sheep.breed ?? "Tanpa Breed",
                                style: const TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black87,
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Umur: ${sheep.ageMonths.toStringAsFixed(1)} bulan',
                          style: TextStyle(
                            fontSize: 13,
                            color: Colors.grey[600],
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 8),
                  Container(
                    width: 110,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 8,
                    ),
                    decoration: BoxDecoration(
                      color: AppTheme.cream,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: MarqueeText(
                      text: statusText,
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                        color: badgeText,
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
