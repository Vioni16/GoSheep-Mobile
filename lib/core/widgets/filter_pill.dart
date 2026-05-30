import 'package:flutter/material.dart';

class FilterPill extends StatelessWidget {
  final String label;
  final bool active;
  final VoidCallback onTap;
  const FilterPill({
    super.key,
    required this.label,
    required this.active,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) => GestureDetector(
    onTap: onTap,
    child: AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: active ? Colors.black : Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: active ? Colors.black : Colors.black.withValues(alpha: 0.1),
        ),
      ),
      child: Text(
        label,
        style: TextStyle(
          fontSize: 13,
          fontWeight: active ? FontWeight.w600 : FontWeight.w500,
          color: active ? Colors.white : Colors.black54,
        ),
      ),
    ),
  );
}