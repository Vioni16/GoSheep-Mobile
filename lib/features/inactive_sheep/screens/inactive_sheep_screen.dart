import 'package:flutter/material.dart';
import '../widgets/inactive_sheep_helpers.dart';
import '../widgets/inactive_sheep_widgets.dart';

class InactiveSheepScreen extends StatefulWidget {
  const InactiveSheepScreen({super.key});

  @override
  State<InactiveSheepScreen> createState() => _InactiveSheepScreenState();
}

class _InactiveSheepScreenState extends State<InactiveSheepScreen> {
  String _activeFilter = 'all';
  String _searchQuery  = '';

  int get _soldCount     => sampleSheepData.where((s) => s.status == SheepStatus.sold).length;
  int get _deadCount     => sampleSheepData.where((s) => s.status == SheepStatus.dead).length;
  int get _inactiveCount => sampleSheepData.where((s) => s.status == SheepStatus.inactive).length;

  List<InactiveSheep> get _filtered => sampleSheepData.where((sheep) {
    final matchFilter = _activeFilter == 'all' || sheep.status.name == _activeFilter;
    final matchSearch = _searchQuery.isEmpty ||
        sheep.earTag.toLowerCase().contains(_searchQuery.toLowerCase());
    return matchFilter && matchSearch;
  }).toList();

  FilterConfig get _config => filterConfigs[_activeFilter]!;

  @override
  Widget build(BuildContext context) {
    final config = _config;

    return Scaffold(
      backgroundColor: kBg,
      appBar: AppBar(
        foregroundColor: Colors.white,
        backgroundColor: Theme.of(context).colorScheme.primary,
        centerTitle: true,
        title: const Text(
          'Ternak Nonaktif',
          style: TextStyle(fontWeight: FontWeight.w700, fontSize: 18),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Summary cards
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 14, 16, 0),
                child: Row(
                  children: [
                    Expanded(child: SummaryCard(label: 'Dijual',  dotColor: kGreen, value: '$_soldCount')),
                    const SizedBox(width: 10),
                    Expanded(child: SummaryCard(label: 'Mati',    dotColor: kBrown, value: '$_deadCount')),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 10, 16, 0),
                child: SummaryCard(
                  label: 'Nonaktif', dotColor: kTaupe, value: '$_inactiveCount',
                  description: '(terlalu tua, tidak produktif, atau dikeluarkan dari kandang)',
                ),
              ),

              // Search bar
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 12, 16, 0),
                child: Container(
                  height: 42,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: kGreen.withOpacity(0.15), width: 0.5),
                  ),
                  child: Row(
                    children: [
                      const SizedBox(width: 12),
                      const Icon(Icons.search_rounded, size: 16, color: kGreenLight),
                      const SizedBox(width: 8),
                      Expanded(
                        child: TextField(
                          onChanged: (v) => setState(() => _searchQuery = v),
                          style: const TextStyle(fontSize: 13, color: kGreenLight),
                          decoration: const InputDecoration(
                            hintText: 'Cari eartag domba...',
                            hintStyle: TextStyle(fontSize: 13, color: kGreenLight),
                            border: InputBorder.none,
                            isDense: true,
                            contentPadding: EdgeInsets.zero,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              // Filter pills
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.fromLTRB(16, 12, 16, 0),
                child: Row(
                  children: [
                    FilterPill(label: 'Semua',    filterKey: 'all',      activeFilter: _activeFilter, activeColor: config.color, onTap: () => setState(() => _activeFilter = 'all')),
                    const SizedBox(width: 8),
                    FilterPill(label: 'Dijual',   filterKey: 'sold',     activeFilter: _activeFilter, activeColor: config.color, onTap: () => setState(() => _activeFilter = 'sold')),
                    const SizedBox(width: 8),
                    FilterPill(label: 'Mati',     filterKey: 'dead',     activeFilter: _activeFilter, activeColor: config.color, onTap: () => setState(() => _activeFilter = 'dead')),
                    const SizedBox(width: 8),
                    FilterPill(label: 'Nonaktif', filterKey: 'inactive', activeFilter: _activeFilter, activeColor: config.color, onTap: () => setState(() => _activeFilter = 'inactive')),
                  ],
                ),
              ),

              // Section label
              const Padding(
                padding: EdgeInsets.fromLTRB(16, 16, 16, 8),
                child: Text(
                  'RIWAYAT TERNAK',
                  style: TextStyle(fontSize: 10, fontWeight: FontWeight.w500, color: kGreenLight, letterSpacing: 1.2),
                ),
              ),

              // Banner
              InactiveBanner(config: config),

              // Sheep cards
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 0, 16, 32),
                child: Column(
                  children: _filtered.map((sheep) => Padding(
                    padding: const EdgeInsets.only(bottom: 10),
                    child: SheepCard(sheep: sheep),
                  )).toList(),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}