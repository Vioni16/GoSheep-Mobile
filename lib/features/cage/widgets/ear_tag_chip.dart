import 'package:flutter/material.dart';
import 'package:gosheep_mobile/data/models/cage.dart';

class EarTagChip extends StatelessWidget {
  final CageSheep sheep;
  final VoidCallback onTap;

  const EarTagChip({
    super.key,
    required this.sheep,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.symmetric(
            horizontal: 12,
            vertical: 10,
          ),
          decoration: BoxDecoration(
            gradient:  LinearGradient(
              begin: Alignment.bottomRight,
              end: Alignment.topLeft,
              stops: [0.9, 0.5],
              colors: [Color(0xFFFAEEDA), Color(0xFF8D6E63)],
            ),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: Colors.black,
              width: 0.5,
            ),
          ),
          child: Text(
            sheep.earTag,
            style: const TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w600,
              color: Colors.black,
              letterSpacing: 0.3,
            ),
          ),
        ),
      ),
    );
  }
}