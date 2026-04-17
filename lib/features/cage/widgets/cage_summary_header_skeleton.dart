import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class CageSummaryHeaderSkeleton extends StatelessWidget {
  const CageSummaryHeaderSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: Colors.grey.shade300,
      highlightColor: Colors.grey.shade100,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(0, 14, 0, 8),
        child: Row(
          children: List.generate(3, (index) {
            return Expanded(
              child: Container(
                margin: const EdgeInsets.only(right: 10),
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 15,
                ),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(
                    color: Colors.black.withValues(alpha: 0.08),
                    width: 0.5,
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      width: 80,
                      height: 10,
                      color: Colors.white,
                    ),
                    const SizedBox(height: 6),
                    Container(
                      width: 40,
                      height: 18,
                      color: Colors.white,
                    ),
                  ],
                ),
              ),
            );
          }),
        ),
      ),
    );
  }
}