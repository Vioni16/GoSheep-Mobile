import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class HealthChartCardSkeleton extends StatelessWidget {
  const HealthChartCardSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: Colors.black.withValues(alpha: 0.05)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Shimmer.fromColors(
            baseColor: const Color(0xFFE0E0E0),
            highlightColor: const Color(0xFFF5F5F5),
            child: _Box(width: 120, height: 14, radius: 4),
          ),

          const SizedBox(height: 18),

          Center(
            child: Stack(
              alignment: Alignment.center,
              children: [
                Shimmer.fromColors(
                  baseColor: const Color(0xFFE0E0E0),
                  highlightColor: const Color(0xFFF5F5F5),
                  child: Container(
                    width: 180,
                    height: 180,
                    decoration: BoxDecoration(
                      color: Colors.grey[400],
                      shape: BoxShape.circle,
                    ),
                  ),
                ),
                Container(
                  width: 90,
                  height: 90,
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    shape: BoxShape.circle,
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 16),

          Shimmer.fromColors(
            baseColor: const Color(0xFFE0E0E0),
            highlightColor: const Color(0xFFF5F5F5),
            child: Row(
              children: [
                _Box(width: 60, height: 12, radius: 4),
                const SizedBox(width: 12),
                _Box(width: 60, height: 12, radius: 4),
                const SizedBox(width: 12),
                _Box(width: 60, height: 12, radius: 4),
                const SizedBox(width: 12),
                _Box(width: 60, height: 12, radius: 4),
              ],
            ),
          ),
        ],
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
