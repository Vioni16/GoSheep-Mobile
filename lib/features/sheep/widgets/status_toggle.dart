import 'package:flutter/material.dart';

class StatusToggle extends StatelessWidget {
  final String label;
  final bool selected;
  final Color bg, border, text;
  final VoidCallback onTap;
  const StatusToggle({
    super.key,
    required this.label,
    required this.selected,
    required this.bg,
    required this.border,
    required this.text,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) => GestureDetector(
    onTap: onTap,
    child: AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      padding: const EdgeInsets.symmetric(vertical: 12),
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: selected ? bg : Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: selected ? border : Colors.black.withValues(alpha: 0.08),
          width: selected ? 1.5 : 1,
        ),
      ),
      child: Text(
        label,
        style: TextStyle(
          fontSize: 14,
          fontWeight: selected ? FontWeight.w600 : FontWeight.w500,
          color: selected ? text : Colors.black54,
        ),
      ),
    ),
  );
}