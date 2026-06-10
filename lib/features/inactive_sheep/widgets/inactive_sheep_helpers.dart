import 'package:flutter/material.dart';

// ── Colors ──
const kGreen      = Color(0xFF0F5132);
const kBrown      = Color(0xFFB71C1C); // Colors.red.shade700
const kTaupe      = Color(0xFFB8860B);
const kGreenLight = Color(0xFF4A7C62);
const kBg         = Color(0xFFF5F4F0);

// ── Model ──
enum SheepStatus { sold, dead, inactive }

class InactiveSheep {
  final String earTag;
  final String gender;
  final String breed;
  final String pen;
  final double weightKg;
  final String age;
  final String inactiveDate;
  final SheepStatus status;

  const InactiveSheep({
    required this.earTag,
    required this.gender,
    required this.breed,
    required this.pen,
    required this.weightKg,
    required this.age,
    required this.inactiveDate,
    required this.status,
  });
}

const sampleSheepData = <InactiveSheep>[
  InactiveSheep(earTag: 'ET-00142', gender: 'Betina',  breed: 'Merino',      pen: 'Kandang A', weightKg: 42, age: '2 th 3 bl', inactiveDate: '12 Mar 2025', status: SheepStatus.sold),
  InactiveSheep(earTag: 'ET-00089', gender: 'Jantan',  breed: 'Domba lokal', pen: 'Kandang B', weightKg: 38, age: '3 th 1 bl', inactiveDate: '5 Jan 2025',  status: SheepStatus.dead),
  InactiveSheep(earTag: 'ET-00031', gender: 'Betina',  breed: 'Garut',       pen: 'Kandang C', weightKg: 29, age: '5 th 7 bl', inactiveDate: '20 Feb 2025', status: SheepStatus.inactive),
  InactiveSheep(earTag: 'ET-00205', gender: 'Jantan',  breed: 'Merino',      pen: 'Kandang A', weightKg: 51, age: '1 th 9 bl', inactiveDate: '28 Apr 2025', status: SheepStatus.sold),
];

// ── Filter config ──
class FilterConfig {
  final Color color;
  final String pillText;
  final String title;
  final String subtitle;
  final IconData icon;
  const FilterConfig({required this.color, required this.pillText, required this.title, required this.subtitle, required this.icon});
}

const filterConfigs = <String, FilterConfig>{
  'all':      FilterConfig(color: kGreen, pillText: 'Tidak aktif',  title: 'Seluruh riwayat',  subtitle: 'Domba dijual, mati, atau sudah nonaktif',  icon: Icons.history_rounded),
  'sold':     FilterConfig(color: kGreen, pillText: 'Sudah dijual', title: 'Domba dijual',     subtitle: 'Tercatat sudah berpindah kepemilikan',     icon: Icons.sell_rounded),
  'dead':     FilterConfig(color: kBrown, pillText: 'Sudah mati',   title: 'Domba mati',       subtitle: 'Catatan domba yang tidak lagi hidup',      icon: Icons.heart_broken_rounded),
  'inactive': FilterConfig(color: kTaupe, pillText: 'Nonaktif',     title: 'Domba nonaktif',   subtitle: 'Terlalu tua atau tidak lagi produktif',    icon: Icons.do_not_disturb_on_rounded),
};

// ── Status helpers ──
Color statusColor(SheepStatus s) {
  switch (s) {
    case SheepStatus.sold:     return kGreen;
    case SheepStatus.dead:     return kBrown;
    case SheepStatus.inactive: return kTaupe;
  }
}

String statusLabel(SheepStatus s) {
  switch (s) {
    case SheepStatus.sold:     return 'Dijual';
    case SheepStatus.dead:     return 'Mati';
    case SheepStatus.inactive: return 'Nonaktif';
  }
}

IconData statusIcon(SheepStatus s) {
  switch (s) {
    case SheepStatus.sold:     return Icons.sell_rounded;
    case SheepStatus.dead:     return Icons.heart_broken_rounded;
    case SheepStatus.inactive: return Icons.do_not_disturb_on_rounded;
  }
}

Color avatarBg(SheepStatus s) {
  switch (s) {
    case SheepStatus.sold:     return const Color(0xFFE8F5EE);
    case SheepStatus.dead:     return const Color(0xFFFFEBEE); // red.shade50
    case SheepStatus.inactive: return const Color(0xFFFFF8E1); // amber/gold tint
  }
}