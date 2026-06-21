import 'package:flutter/material.dart';
import 'package:gosheep_mobile/core/widgets/marquee_text.dart';
import 'package:gosheep_mobile/core/widgets/sheep_chip.dart';
import 'package:gosheep_mobile/core/widgets/sheep_icon.dart';
import 'package:gosheep_mobile/data/models/sheep_breeding.dart';
import 'package:gosheep_mobile/features/breeding/providers/breeding_provider.dart';
import 'package:gosheep_mobile/features/sheep/screens/sheep_detail_screen.dart';
import 'package:gosheep_mobile/features/breeding/widgets/recommendation_item_card.dart';
import 'package:provider/provider.dart';

class BreedingRecommendationSheet extends StatelessWidget {
  const BreedingRecommendationSheet({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<BreedingProvider>();
    final sheep = provider.selectedSheep;

    if (sheep == null) return const SizedBox.shrink();

    return DraggableScrollableSheet(
      initialChildSize: 0.75,
      minChildSize: 0.5,
      maxChildSize: 0.95,
      snap: true,
      builder: (context, scrollController) {
        return Container(
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
          ),
          child: Column(
            children: [
              const SizedBox(height: 8),
              Center(
                child: Container(
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                    color: Colors.grey[300],
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: _buildSelectedSheepHeader(context, sheep),
              ),
              const SizedBox(height: 16),
              const Divider(height: 1),
              Expanded(
                child: _buildRecommendationBody(context, provider, scrollController),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildSelectedSheepHeader(BuildContext context, SheepBreeding sheep) {
    final isFemale = sheep.gender.toLowerCase() == 'female';

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'DOMBA TERPILIH:',
          style: TextStyle(
            fontSize: 11,
            fontWeight: FontWeight.bold,
            color: Colors.grey,
            letterSpacing: 1.0,
          ),
        ),
        const SizedBox(height: 8),
        Row(
          children: [
            SheepIcon(
              color: isFemale ? const Color(0xFFE91E63) : const Color(0xFF2196F3),
              size: 20,
            ),
            const SizedBox(width: 8),
            SheepChip(
              label: sheep.eartag,
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => SheepDetailScreen(
                      id: sheep.id,
                    ),
                  ),
                );
              },
            ),
            const SizedBox(width: 10),
            Expanded(
              child: MarqueeText(
                text: '${sheep.breed ?? "Tanpa Breed"} • ${isFemale ? "Betina" : "Jantan"}',
                style: const TextStyle(
                  fontSize: 15,
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
          style: TextStyle(fontSize: 13, color: Colors.grey[600]),
        ),
        const SizedBox(height: 12),
        Container(
          decoration: BoxDecoration(
            border: Border.all(color: Colors.grey.shade200),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Row(
            children: [
              _buildEbvCell('Genetik Bobot (EBV)', sheep.ebv?.weight),
              Container(width: 1, height: 40, color: Colors.grey.shade200),
              _buildEbvCell('Genetik Tumbuh (EBV)', sheep.ebv?.growth),
              Container(width: 1, height: 40, color: Colors.grey.shade200),
              _buildEbvCell('Genetik Sehat (EBV)', sheep.ebv?.health),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildEbvCell(String label, double? value) {
    String valueStr = '-';
    if (value != null) {
      final sign = value >= 0 ? '+' : '';
      valueStr = '$sign${value.toStringAsFixed(4)}';
    }

    return Expanded(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8),
        child: Column(
          children: [
            Text(
              label,
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 10, color: Colors.grey),
            ),
            const SizedBox(height: 2),
            Text(
              valueStr,
              style: const TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRecommendationBody(
    BuildContext context,
    BreedingProvider provider,
    ScrollController scrollController,
  ) {
    if (provider.isLoadingRecommendation) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const CircularProgressIndicator(
              color: Color(0xFF0F5132),
            ),
            const SizedBox(height: 16),
            Text(
              'Menganalisis pasangan terbaik...',
              style: TextStyle(
                color: Colors.grey[600],
                fontSize: 14,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      );
    }

    if (provider.recommendationError != null) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.error_outline_rounded, color: Colors.red[300], size: 48),
              const SizedBox(height: 12),
              Text(
                provider.recommendationError!,
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.grey[700], fontSize: 14),
              ),
              const SizedBox(height: 16),
              ElevatedButton.icon(
                onPressed: () => provider.selectSheep(provider.selectedSheep!),
                icon: const Icon(Icons.refresh_rounded),
                label: const Text('Coba Lagi'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF0F5132),
                  foregroundColor: Colors.white,
                ),
              ),
            ],
          ),
        ),
      );
    }

    final result = provider.result;
    if (result == null || result.recommendations.isEmpty) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.favorite_border_rounded, size: 64, color: Colors.grey[300]),
              const SizedBox(height: 16),
              const Text(
                'Tidak ada kandidat yang memenuhi syarat',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.black87,
                  fontWeight: FontWeight.bold,
                  fontSize: 15,
                ),
              ),
              const SizedBox(height: 6),
              Text(
                'Semua pasangan yang tersedia memiliki hubungan kekerabatan terlalu dekat atau sedang tidak siap kawin.',
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.grey[500], fontSize: 13),
              ),
            ],
          ),
        ),
      );
    }

    return ListView.builder(
      controller: scrollController,
      padding: const EdgeInsets.fromLTRB(20, 16, 20, 24),
      itemCount: result.recommendations.length + 1,
      itemBuilder: (context, index) {
        if (index == 0) {
          return Padding(
            padding: const EdgeInsets.only(bottom: 12),
            child: Text(
              'Rekomendasi Pasangan Terbaik (${result.total} domba)',
              style: const TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
          );
        }

        final item = result.recommendations[index - 1];
        return RecommendationItemCard(selectedSheep: provider.selectedSheep!, item: item);
      },
    );
  }
}
