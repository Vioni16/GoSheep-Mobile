import 'package:flutter/material.dart';
import 'package:gosheep_mobile/core/widgets/sheep_chip.dart';
import 'package:gosheep_mobile/data/models/cage.dart';

class EarTagChip extends StatelessWidget {
  final CageSheep sheep;
  final VoidCallback onTap;

  const EarTagChip({super.key, required this.sheep, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return SheepChip(label: sheep.earTag, onTap: onTap);
  }
}
