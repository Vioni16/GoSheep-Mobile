import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class HealthOverviewCardSkeleton extends StatelessWidget {
  const HealthOverviewCardSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: Colors.black.withValues(alpha: 0.05)),
      ),
      child: Shimmer.fromColors(
        baseColor: const Color(0xFFE0E0E0),
        highlightColor: const Color(0xFFF5F5F5),
        child: Padding(
          padding: const EdgeInsets.all(14),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  _Box(width: 80, height: 28, radius: 20),
                  const Spacer(),
                  _Box(width: 64, height: 28, radius: 20),
                ],
              ),

              const SizedBox(height: 12),

              _Box(width: 200, height: 14, radius: 4),

              const SizedBox(height: 8),

              _Box(width: 140, height: 12, radius: 4),
            ],
          ),
        ),
      ),
    );
  }
}

class _Box extends StatelessWidget {
  final double width, height, radius;

  const _Box({required this.width, required this.height, required this.radius});

  @override
  Widget build(BuildContext context) => Container(
    width: width,
    height: height,
    decoration: BoxDecoration(
      color: Colors.grey[400],
      borderRadius: BorderRadius.circular(radius),
    ),
  );
}
