import 'package:flutter/material.dart';

class PregnancyStatusBadge extends StatelessWidget {
  final String status;

  const PregnancyStatusBadge({
    super.key,
    required this.status,
  });

  Color _color() {
    switch (status) {
      case 'ongoing':
        return Colors.green;
      case 'birthed':
        return Colors.blue;
      case 'miscarried':
        return Colors.red;
      default:
        return Colors.grey;
    }
  }

  String _text() {
    switch (status) {
      case 'ongoing':
        return 'Bunting';
      case 'birthed':
        return 'Melahirkan';
      case 'miscarried':
        return 'Keguguran';
      default:
        return 'Unknown';
    }
  }

  @override
  Widget build(BuildContext context) {
    final color = _color();

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: color.withOpacity(0.15),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        _text(),
        style: TextStyle(
          color: color,
          fontSize: 11,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}