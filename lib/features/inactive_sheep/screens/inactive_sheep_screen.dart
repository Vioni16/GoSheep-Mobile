import 'package:flutter/material.dart';
import 'package:gosheep_mobile/core/widgets/app_banner.dart';
import 'package:gosheep_mobile/core/widgets/app_refresh_indicator.dart';
import 'package:gosheep_mobile/core/widgets/filter_pill.dart';
import 'package:gosheep_mobile/core/widgets/summary_card.dart';
import '../widgets/inactive_sheep_card.dart'; 

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
  InactiveSheep(
    earTag: 'ET-00142',
    gender: 'Betina',
    breed: 'Merino',
    pen: 'Kandang A',
    weightKg: 42,
    age: '2 th 3 bl',
    inactiveDate: '12 Mar 2025',
    status: SheepStatus.sold,
  ),
  InactiveSheep(
    earTag: 'ET-00089',
    gender: 'Jantan',
    breed: 'Domba lokal',
    pen: 'Kandang B',
    weightKg: 38,
    age: '3 th 1 bl',
    inactiveDate: '5 Jan 2025',
    status: SheepStatus.dead,
  ),
  InactiveSheep(
    earTag: 'ET-00031',
    gender: 'Betina',
    breed: 'Garut',
    pen: 'Kandang C',
    weightKg: 29,
    age: '5 th 7 bl',
    inactiveDate: '20 Feb 2025',
    status: SheepStatus.inactive,
  ),
  InactiveSheep(
    earTag: 'ET-00205',
    gender: 'Jantan',
    breed: 'Merino',
    pen: 'Kandang A',
    weightKg: 51,
    age: '1 th 9 bl',
    inactiveDate: '28 Apr 2025',
    status: SheepStatus.sold,
  ),
];

class FilterConfig {
  final String pillText;
  final String title;
  final String subtitle;
  final IconData icon;
  const FilterConfig({
    required this.pillText,
    required this.title,
    required this.subtitle,
    required this.icon,
  });
}

const filterConfigs = <String, FilterConfig>{
  'all': FilterConfig(
    pillText: 'Tidak aktif',
    title: 'Seluruh riwayat',
    subtitle: 'Domba dijual, mati, atau sudah nonaktif',
    icon: Icons.history_rounded,
  ),
  'sold': FilterConfig(
    pillText: 'Sudah dijual',
    title: 'Domba dijual',
    subtitle: 'Tercatat sudah berpindah kepemilikan',
    icon: Icons.sell_rounded,
  ),
  'dead': FilterConfig(
    pillText: 'Sudah mati',
    title: 'Domba mati',
    subtitle: 'Catatan domba yang tidak lagi hidup',
    icon: Icons.heart_broken_rounded,
  ),
  'inactive': FilterConfig(
    pillText: 'Nonaktif',
    title: 'Domba nonaktif',
    subtitle: 'Terlalu tua atau tidak lagi produktif',
    icon: Icons.do_not_disturb_on_rounded,
  ),
};

class InactiveSheepScreen extends StatefulWidget {
  const InactiveSheepScreen({super.key});

  @override
  State<InactiveSheepScreen> createState() => _InactiveSheepScreenState();
}

class _InactiveSheepScreenState extends State<InactiveSheepScreen> {
  String _activeFilter = 'all';
  String _searchQuery = '';
  final _searchController = TextEditingController();

  int get _soldCount =>
      sampleSheepData.where((s) => s.status == SheepStatus.sold).length;
  int get _deadCount =>
      sampleSheepData.where((s) => s.status == SheepStatus.dead).length;
  int get _inactiveCount =>
      sampleSheepData.where((s) => s.status == SheepStatus.inactive).length;

  List<InactiveSheep> get _filtered => sampleSheepData.where((sheep) {
    final matchFilter =
        _activeFilter == 'all' || sheep.status.name == _activeFilter;
    final matchSearch =
        _searchQuery.isEmpty ||
        sheep.earTag.toLowerCase().contains(_searchQuery.toLowerCase());
    return matchFilter && matchSearch;
  }).toList();

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final config = filterConfigs[_activeFilter]!;

    return Scaffold(
      backgroundColor: const Color(0xFFF5F4F0),
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
        child: AppRefreshIndicator(
          onRefresh: () async => setState(() {}),
          child: CustomScrollView(
            physics: const AlwaysScrollableScrollPhysics(
              parent: BouncingScrollPhysics(),
            ),
            slivers: [
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Statistik Domba Nonaktif',
                        style: Theme.of(context).textTheme.headlineSmall
                            ?.copyWith(fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 4),
                      const Text(
                        'Pantau domba yang sudah dijual, mati, atau tidak aktif lagi.',
                        style: TextStyle(color: Colors.grey, fontSize: 13),
                      ),
                    ],
                  ),
                ),
              ),

              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(16, 0, 16, 0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            child: SummaryCard(
                              label: 'Dijual',
                              value: '$_soldCount',
                            ),
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                            child: SummaryCard(
                              label: 'Mati',
                              value: '$_deadCount',
                            ),
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                            child: SummaryCard(
                              label: 'Nonaktif',
                              value: '$_inactiveCount',
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Padding(
                        padding: const EdgeInsets.only(left: 4),
                        child: Text(
                          '* Kategori Nonaktif termasuk ternak yang terlalu tua, tidak produktif, atau dikeluarkan dari kandang.',
                          style: TextStyle(
                            fontSize: 11,
                            color: Colors.grey.shade600,
                            fontStyle: FontStyle.italic,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(16, 10, 16, 0),
                  child: SearchBar(
                    controller: _searchController,
                    hintText: 'Cari Eartag domba...',
                    leading: const Icon(Icons.search_rounded),
                    elevation: const WidgetStatePropertyAll(0),
                    backgroundColor: const WidgetStatePropertyAll(Colors.white),
                    shape: WidgetStatePropertyAll(
                      RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    trailing: [
                      if (_searchQuery.isNotEmpty)
                        IconButton(
                          icon: const Icon(Icons.close),
                          onPressed: () {
                            _searchController.clear();
                            setState(() => _searchQuery = '');
                          },
                        ),
                    ],
                    onChanged: (value) => setState(() => _searchQuery = value),
                  ),
                ),
              ),

              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(16, 12, 16, 0),
                  child: SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: [
                        FilterPill(
                          label: 'Semua',
                          active: _activeFilter == 'all',
                          onTap: () => setState(() => _activeFilter = 'all'),
                        ),
                        const SizedBox(width: 8),
                        FilterPill(
                          label: 'Dijual',
                          active: _activeFilter == 'sold',
                          onTap: () => setState(() => _activeFilter = 'sold'),
                        ),
                        const SizedBox(width: 8),
                        FilterPill(
                          label: 'Mati',
                          active: _activeFilter == 'dead',
                          onTap: () => setState(() => _activeFilter = 'dead'),
                        ),
                        const SizedBox(width: 8),
                        FilterPill(
                          label: 'Nonaktif',
                          active: _activeFilter == 'inactive',
                          onTap: () =>
                              setState(() => _activeFilter = 'inactive'),
                        ),
                      ],
                    ),
                  ),
                ),
              ),

              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(16, 16, 16, 14),
                  child: AppBanner(
                    backgroundColor: _activeFilter == 'sold'
                        ? const Color(0xFF0F5132)
                        : _activeFilter == 'dead'
                        ? const Color(0xFFB71C1C)
                        : _activeFilter == 'inactive'
                        ? const Color(0xFFB8860B)
                        : Colors.black,
                    pillLabel: config.pillText,
                    title: config.title,
                    subtitle: config.subtitle,
                    decorIcon: config.icon,
                  ),
                ),
              ),

              const SliverToBoxAdapter(
                child: Padding(
                  padding: EdgeInsets.fromLTRB(16, 0, 16, 12),
                  child: Text(
                    'DATA TERNAK NONAKTIF',
                    style: TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w700,
                      color: Colors.black54,
                      letterSpacing: 1.2,
                    ),
                  ),
                ),
              ),

              SliverPadding(
                padding: const EdgeInsets.fromLTRB(16, 0, 16, 32),
                sliver: SliverList(
                  delegate: SliverChildBuilderDelegate(
                    (context, index) =>
                        InactiveSheepCard(sheep: _filtered[index]),
                    childCount: _filtered.length,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
