import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class SheepDetailSkeleton extends StatelessWidget {
  const SheepDetailSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    final primary = Theme.of(context).colorScheme.primary;

    return ColoredBox(
      color: const Color(0xFFF4F6FA),
      child: Column(
        children: [
          _HeroHeaderSkeleton(primary: primary),
          const SizedBox(height: 20),
          _CardSkeleton(rowCount: 4),
          _CardSkeleton(rowCount: 4),
          _CardSkeleton(rowCount: 2, isParent: true),
          _CardSkeleton(rowCount: 2),
          const SizedBox(height: 32),
        ],
      ),
    );
  }
}

class _HeroHeaderSkeleton extends StatelessWidget {
  final Color primary;

  const _HeroHeaderSkeleton({required this.primary});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [primary, primary.withValues(alpha: 0.82)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      padding: const EdgeInsets.fromLTRB(24, 28, 24, 36),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                width: 64,
                height: 64,
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.18),
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: Colors.white.withValues(alpha: 0.4),
                    width: 1.5,
                  ),
                ),
                child: Icon(
                  Icons.pets_rounded,
                  color: Colors.white.withValues(alpha: 0.4),
                  size: 32,
                ),
              ),
              const SizedBox(width: 16),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _ShimmerBox(
                    width: 140,
                    height: 26,
                    baseColor: Colors.white.withValues(alpha: 0.2),
                    highlightColor: Colors.white.withValues(alpha: 0.35),
                  ),
                  const SizedBox(height: 10),
                  _ShimmerBox(
                    width: 80,
                    height: 24,
                    radius: 20,
                    baseColor: Colors.white.withValues(alpha: 0.2),
                    highlightColor: Colors.white.withValues(alpha: 0.35),
                  ),
                ],
              ),
            ],
          ),

          const SizedBox(height: 24),

          Row(
            children: [
              _QuickStatSkeleton(),
              Container(
                width: 1,
                height: 36,
                color: Colors.white.withValues(alpha: 0.25),
                margin: const EdgeInsets.symmetric(horizontal: 4),
              ),
              _QuickStatSkeleton(),
              Container(
                width: 1,
                height: 36,
                color: Colors.white.withValues(alpha: 0.25),
                margin: const EdgeInsets.symmetric(horizontal: 4),
              ),
              _QuickStatSkeleton(),
            ],
          ),
        ],
      ),
    );
  }
}

class _QuickStatSkeleton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Column(
        children: [
          _ShimmerBox(
            width: 18,
            height: 18,
            radius: 4,
            baseColor: Colors.white.withValues(alpha: 0.2),
            highlightColor: Colors.white.withValues(alpha: 0.35),
          ),
          const SizedBox(height: 6),
          _ShimmerBox(
            width: 48,
            height: 13,
            baseColor: Colors.white.withValues(alpha: 0.2),
            highlightColor: Colors.white.withValues(alpha: 0.35),
          ),
          const SizedBox(height: 4),
          _ShimmerBox(
            width: 36,
            height: 10,
            baseColor: Colors.white.withValues(alpha: 0.15),
            highlightColor: Colors.white.withValues(alpha: 0.28),
          ),
        ],
      ),
    );
  }
}

class _CardSkeleton extends StatelessWidget {
  final int rowCount;
  final bool isParent;

  const _CardSkeleton({required this.rowCount, this.isParent = false});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.fromLTRB(16, 0, 16, 14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 12),
            child: Row(
              children: [
                _ShimmerBox(width: 32, height: 32, radius: 8),
                const SizedBox(width: 10),
                _ShimmerBox(width: 100, height: 14),
              ],
            ),
          ),

          Divider(height: 1, color: Colors.grey.shade100),

          Padding(
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
            child: Column(
              children: List.generate(
                rowCount,
                (i) => isParent ? _ParentRowSkeleton() : _InfoRowSkeleton(),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _InfoRowSkeleton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          _ShimmerBox(width: 90, height: 13),
          _ShimmerBox(width: 70, height: 13),
        ],
      ),
    );
  }
}

class _ParentRowSkeleton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _ShimmerBox(width: 30, height: 11),
              const SizedBox(height: 6),
              _ShimmerBox(width: 80, height: 13),
            ],
          ),
          _ShimmerBox(width: 24, height: 24, radius: 12),
        ],
      ),
    );
  }
}


class _ShimmerBox extends StatelessWidget {
  final double width;
  final double height;
  final double radius;
  final Color? baseColor;
  final Color? highlightColor;

  const _ShimmerBox({
    required this.width,
    this.height = 12,
    this.radius = 6,
    this.baseColor,
    this.highlightColor,
  });

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: baseColor ?? Colors.grey.shade200,
      highlightColor: highlightColor ?? Colors.grey.shade100,
      child: Container(
        width: width,
        height: height,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(radius),
        ),
      ),
    );
  }
}
