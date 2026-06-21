import 'package:flutter/material.dart';
import 'package:gosheep_mobile/core/widgets/marquee_text.dart';
import 'package:gosheep_mobile/core/widgets/sheep_chip.dart';
import 'package:gosheep_mobile/core/widgets/toast_widget.dart';
import 'package:gosheep_mobile/data/models/recommendation.dart';
import 'package:gosheep_mobile/data/models/sheep_breeding.dart';
import 'package:gosheep_mobile/features/sheep/screens/sheep_detail_screen.dart';
import 'package:gosheep_mobile/features/breeding/providers/breeding_provider.dart';
import 'package:gosheep_mobile/features/breeding/widgets/mating_confirm_dialog.dart';
import 'package:provider/provider.dart';

class RecommendationItemCard extends StatelessWidget {
  final SheepBreeding selectedSheep;
  final RecommendationItem item;

  const RecommendationItemCard({
    super.key,
    required this.selectedSheep,
    required this.item,
  });

  @override
  Widget build(BuildContext context) {
    final sheep = item.sheep;
    final coiText = '${item.inbreedingPercent.toStringAsFixed(2)}%';
    final isDanger = item.inbreedingPercent >= 6.25;

    final coiColor = isDanger
        ? const Color(0xFFC62828)
        : const Color(0xFF2E7D32);

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey.shade200),
        boxShadow: [
          BoxShadow(
            color: const Color(0x03000000),
            blurRadius: 6,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
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
                          const SizedBox(width: 8),
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
                        'Tingkat Kekerabatan: $coiText ',
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                          color: coiColor,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 8),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: const Color(0xFFFFF8E1),
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: const Color(0xFFFFD54F)),
                  ),
                  child: Row(
                    children: [
                      const Icon(
                        Icons.star_rounded,
                        color: Color(0xFFF57F17),
                        size: 16,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        item.scores.final_.toStringAsFixed(2),
                        style: const TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFFF57F17),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            const Divider(height: 1),
            const SizedBox(height: 12),
            const Text(
              'Prediksi Kualitas Genetik Anak (Nilai EBV):',
              style: TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.bold,
                color: Colors.grey,
              ),
            ),
            const SizedBox(height: 6),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                  _buildExpectedEbvSpan(
                    'Bobot:',
                    item.expectedEbvOffspring['EBV_Bobot'],
                  ),
                  const SizedBox(width: 16),
                  _buildExpectedEbvSpan(
                    'Pertumbuhan:',
                    item.expectedEbvOffspring['EBV_ADG'],
                  ),
                  const SizedBox(width: 16),
                  _buildExpectedEbvSpan(
                    'Kesehatan:',
                    item.expectedEbvOffspring['EBV_Kesehatan'],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 12),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  showDialog<bool>(
                    context: context,
                    builder: (dialogContext) {
                      return MatingConfirmDialog(
                        selectedSheep: selectedSheep,
                        candidate: sheep,
                        recommendationId: item.recommendationId,
                      );
                    },
                  ).then((success) {
                    if (success == true && context.mounted) {
                      Navigator.pop(context); // Close BottomSheet
                      ToastService.show(
                        context,
                        'Pencatatan perkawinan berhasil disimpan.',
                        title: 'Berhasil!',
                        type: ToastType.success,
                      );
                      context.read<BreedingProvider>().loadSheepList();
                    }
                  });
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF0F5132),
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  padding: const EdgeInsets.symmetric(vertical: 10),
                ),
                child: const Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Kawinkan',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 13,
                      ),
                    ),
                    SizedBox(width: 4),
                    Icon(Icons.arrow_forward_rounded, size: 14),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildExpectedEbvSpan(String label, double? value) {
    String valStr = '-';
    if (value != null) {
      final sign = value >= 0 ? '+' : '';
      valStr = '$sign${value.toStringAsFixed(4)}';
    }
    return Text(
      '$label $valStr',
      style: const TextStyle(
        fontSize: 12,
        fontWeight: FontWeight.bold,
        color: Colors.black87,
      ),
    );
  }
}
