import 'package:flutter/material.dart';
import 'inactive_sheep_helpers.dart';


class SummaryCard extends StatelessWidget {
  final String label;
  final Color dotColor;
  final String value;
  final String? description;

  const SummaryCard({
    super.key,
    required this.label,
    required this.dotColor,
    required this.value,
    this.description,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: kGreen.withOpacity(0.12), width: 0.5),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 8, height: 8,
                decoration: BoxDecoration(color: dotColor, shape: BoxShape.circle),
              ),
              const SizedBox(width: 6),
              Text(label,
                style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w500, color: kGreenLight, letterSpacing: 0.4),
              ),
            ],
          ),
          const SizedBox(height: 3),
          Text(value,
            style: const TextStyle(fontSize: 24, fontWeight: FontWeight.w500, color: kGreen),
          ),
          if (description != null) ...[
            const SizedBox(height: 2),
            Text(description!, style: const TextStyle(fontSize: 10, color: kGreenLight)),
          ],
        ],
      ),
    );
  }
}

class FilterPill extends StatelessWidget {
  final String label;
  final String filterKey;
  final String activeFilter;
  final Color activeColor;
  final VoidCallback onTap;

  const FilterPill({
    super.key,
    required this.label,
    required this.filterKey,
    required this.activeFilter,
    required this.activeColor,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final isActive = activeFilter == filterKey;
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
        decoration: BoxDecoration(
          color: isActive ? activeColor : Colors.white,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: isActive ? activeColor : kGreen.withOpacity(0.2),
            width: 0.5,
          ),
        ),
        child: Text(label,
          style: TextStyle(
            fontSize: 12, fontWeight: FontWeight.w500,
            color: isActive ? Colors.white : kGreenLight,
          ),
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────
// InactiveBanner
// ─────────────────────────────────────────────

class InactiveBanner extends StatelessWidget {
  final FilterConfig config;

  const InactiveBanner({super.key, required this.config});

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 250),
      margin: const EdgeInsets.fromLTRB(16, 0, 16, 14),
      decoration: BoxDecoration(
        color: config.color,
        borderRadius: BorderRadius.circular(12),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(12),
        child: Stack(
          children: [
            Positioned(
              right: 14, bottom: 6,
              child: Icon(config.icon, size: 44, color: Colors.white.withOpacity(0.13)),
            ),
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 3),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(config.pillText,
                      style: const TextStyle(fontSize: 10, fontWeight: FontWeight.w500, color: Colors.white),
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(config.title,
                    style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w500, color: Colors.white, height: 1.3),
                  ),
                  const SizedBox(height: 3),
                  Text(config.subtitle,
                    style: TextStyle(fontSize: 11, color: Colors.white.withOpacity(0.8), height: 1.4),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────
// SheepCard
// ─────────────────────────────────────────────

class SheepCard extends StatelessWidget {
  final InactiveSheep sheep;

  const SheepCard({super.key, required this.sheep});

  @override
  Widget build(BuildContext context) {
    final color = statusColor(sheep.status);
    final badgeTextColor = Colors.white;

    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: kGreen.withOpacity(0.12), width: 0.5),
      ),
      child: Column(
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 40, height: 40,
                decoration: BoxDecoration(
                  color: avatarBg(sheep.status),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Center(child: Text('🐑', style: TextStyle(fontSize: 18))),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(sheep.earTag,
                      style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500, color: kGreen),
                    ),
                    const SizedBox(height: 2),
                    Text('${sheep.gender} · ${sheep.breed} · ${sheep.pen}',
                      style: const TextStyle(fontSize: 11, color: kGreenLight),
                    ),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 3),
                decoration: BoxDecoration(color: color, borderRadius: BorderRadius.circular(20)),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(statusIcon(sheep.status), size: 9, color: badgeTextColor),
                    const SizedBox(width: 4),
                    Text(statusLabel(sheep.status),
                      style: TextStyle(fontSize: 10, fontWeight: FontWeight.w500, color: badgeTextColor),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Divider(height: 1, thickness: 0.5, color: kGreen.withOpacity(0.1)),
          const SizedBox(height: 10),
          Row(
            children: [
              _Stat(label: 'Berat',       value: '${sheep.weightKg.toStringAsFixed(0)} kg'),
              _Stat(label: 'Usia',        value: sheep.age),
              _Stat(label: 'Tgl nonaktif', value: sheep.inactiveDate),
            ],
          ),
        ],
      ),
    );
  }
}

class _Stat extends StatelessWidget {
  final String label;
  final String value;
  const _Stat({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: const TextStyle(fontSize: 10, color: kGreenLight)),
          const SizedBox(height: 1),
          Text(value, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w500, color: kGreen)),
        ],
      ),
    );
  }
}