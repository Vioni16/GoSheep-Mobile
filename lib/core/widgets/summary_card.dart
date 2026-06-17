import 'package:flutter/material.dart';
import 'package:gosheep_mobile/core/widgets/summary_card_skeleton.dart';
import 'package:gosheep_mobile/core/widgets/marquee_text.dart';

class SummaryCard extends StatelessWidget {
  final String label, value;
  final String? description;
  final Color? valueColor;
  final double? fontSize;
  final bool isLoading;
  const SummaryCard({
    super.key,
    required this.label,
    required this.value,
    this.description,
    this.valueColor,
    this.fontSize,
    this.isLoading = false,
  });

  @override
  Widget build(BuildContext context) {
    if (isLoading) return const SummaryCardSkeleton();

    return Container(
      padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.black.withValues(alpha: 0.04)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            value,
            textAlign: TextAlign.center, 
            style: TextStyle(
              fontSize: fontSize ?? 24,
              fontWeight: FontWeight.w700,
              color: valueColor ?? Colors.black87,
            ),
          ),
          const SizedBox(height: 4),

          if (description?.isNotEmpty ?? false) ...[
            Text(
              description!,
              textAlign: TextAlign.center, 
              style: const TextStyle(
                fontSize: 9, 
                color: Colors.black54,
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: 6), 
          ],

          MarqueeText(
            text: label,
            style: const TextStyle(
              fontSize: 12,
              color: Colors.black54,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}