import 'package:flutter/material.dart';

class SheepChip extends StatelessWidget {
  final String label;
  final VoidCallback onTap;
  final Color? backgroundColor;
  final Color? borderColor;
  final Color? textColor;

  const SheepChip({
    super.key,
    required this.label,
    required this.onTap,
    this.backgroundColor,
    this.borderColor,
    this.textColor,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.bottomRight,
              end: Alignment.topLeft,
              stops: const [0.9, 0.5],
              colors: [
                backgroundColor ?? const Color(0xFFFAEEDA),
                borderColor ?? const Color(0xFF8D6E63),
              ],
            ),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: borderColor ?? Colors.black, width: 0.5),
          ),
          child: Text(
            label,
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w600,
              color: textColor ?? Colors.black,
              letterSpacing: 0.3,
            ),
          ),
        ),
      ),
    );
  }
}
