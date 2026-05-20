import 'package:flutter/material.dart';
import 'package:gosheep_mobile/core/theme/theme.dart';

class GenderBadge extends StatelessWidget {
  final String gender;

  const GenderBadge({
    super.key,
    required this.gender,
  });

  @override
  Widget build(BuildContext context) {
    final bool isFemale = gender == "Betina";

    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 10,
        vertical: 6,
      ),

      decoration: BoxDecoration(
        color: isFemale
            ? Colors.pink.withOpacity(0.08)
            : AppTheme.primaryGreen.withOpacity(0.08),

        borderRadius: BorderRadius.circular(20),
      ),

      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [

          Icon(
            isFemale
                ? Icons.female_rounded
                : Icons.male_rounded,

            size: 14,

            color: isFemale
                ? Colors.pink.shade400
                : AppTheme.primaryGreen,
          ),

          const SizedBox(width: 4),

          Text(
            gender,

            style: TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w600,

              color: isFemale
                  ? Colors.pink.shade400
                  : AppTheme.primaryGreen,
            ),
          ),
        ],
      ),
    );
  }
}