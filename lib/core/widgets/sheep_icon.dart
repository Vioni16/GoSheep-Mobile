import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class SheepIcon extends StatelessWidget {
  final Color color;
  final double size;

  const SheepIcon({
    super.key,
    this.color = Colors.grey,
    this.size = 120,
  });

  @override
  Widget build(BuildContext context) {
    return SvgPicture.asset(
      'assets/images/sheep_icon.svg',
      width: size,
      height: size,
      colorFilter: ColorFilter.mode(
        color,
        BlendMode.srcIn,
      ),
    );
  }
}