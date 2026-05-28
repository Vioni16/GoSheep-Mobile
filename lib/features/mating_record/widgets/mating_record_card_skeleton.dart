import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class MatingRecordCardSkeleton extends StatelessWidget {
  const MatingRecordCardSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(color: Colors.black.withValues(alpha: 0.04), blurRadius: 6),
        ],
      ),
      child: Shimmer.fromColors(
        baseColor: const Color(0xFFE0E0E0),
        highlightColor: const Color(0xFFF5F5F5),
        child: Padding(
          padding: const EdgeInsets.all(14),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Baris atas: dua chip + badge
              Row(
                children: [
                  _box(width: 80, height: 26, radius: 20),
                  const SizedBox(width: 8),
                  _box(width: 80, height: 26, radius: 20),
                  const Spacer(),
                  _box(width: 90, height: 26, radius: 20),
                ],
              ),

              const SizedBox(height: 14),
              _box(width: double.infinity, height: 1, radius: 0),
              const SizedBox(height: 12),

              // Baris bawah: dua info item
              Row(
                children: [
                  _box(width: 90, height: 12, radius: 4),
                  const Spacer(),
                  _box(width: 90, height: 12, radius: 4),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _box({
    required double width,
    required double height,
    required double radius,
  }) {
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        color: Colors.grey[400],
        borderRadius: BorderRadius.circular(radius),
      ),
    );
  }
}
