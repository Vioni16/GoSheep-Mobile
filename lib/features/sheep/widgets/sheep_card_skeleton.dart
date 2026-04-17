import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class SheepCardSkeleton extends StatelessWidget {
  const SheepCardSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      decoration: BoxDecoration(
        color: Colors.white, // ✅ card tetap normal
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: Colors.black.withValues(alpha: 0.05)),
      ),
      child: Shimmer.fromColors(
        baseColor: const Color(0xFFE0E0E0),
        highlightColor: const Color(0xFFF5F5F5),
        child: Padding(
          padding: const EdgeInsets.all(14),
          child: Row(
            children: [
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  color: Colors.grey[400],
                  shape: BoxShape.circle,
                ),
              ),

              const SizedBox(width: 14),

              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Container(
                          width: 110,
                          height: 14,
                          decoration: BoxDecoration(
                            color: Colors.grey[400],
                            borderRadius: BorderRadius.circular(6),
                          ),
                        ),
                        const SizedBox(width: 6),
                        Container(
                          width: 50,
                          height: 12,
                          decoration: BoxDecoration(
                            color: Colors.grey[400],
                            borderRadius: BorderRadius.circular(6),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 6),
                    Container(
                      width: 160,
                      height: 12,
                      decoration: BoxDecoration(
                        color: Colors.grey[400],
                        borderRadius: BorderRadius.circular(6),
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(width: 12),

              Container(
                width: 70,
                height: 28,
                decoration: BoxDecoration(
                  color: Colors.grey[400],
                  borderRadius: BorderRadius.circular(20),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}