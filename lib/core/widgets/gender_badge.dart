import 'package:flutter/material.dart';
import 'package:gosheep_mobile/core/utils/sheep_status_util.dart';
import 'package:gosheep_mobile/core/widgets/sheep_icon.dart';

class GenderBadge extends StatelessWidget {
  final String gender;

  const GenderBadge({super.key, required this.gender});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 2, horizontal: 2),

      decoration: BoxDecoration(
        color: SheepStatusUtil.getGenderColor(gender),
        borderRadius: BorderRadius.circular(20),
      ),

      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [SheepIcon(color: Colors.white, size: 15)],
      ),
    );
  }
}
