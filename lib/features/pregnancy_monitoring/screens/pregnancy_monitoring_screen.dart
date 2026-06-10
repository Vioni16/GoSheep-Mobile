import 'package:flutter/material.dart';
import 'package:gosheep_mobile/core/widgets/app_banner.dart';
import 'package:gosheep_mobile/core/widgets/app_refresh_indicator.dart';
import 'package:gosheep_mobile/core/widgets/filter_pill.dart';
import 'package:gosheep_mobile/core/widgets/summary_card.dart';
import 'package:gosheep_mobile/features/pregnancy_monitoring/widgets/pregnancy_monitoring_card.dart';

class PregnancyMonitoringScreen extends StatefulWidget {
  const PregnancyMonitoringScreen({super.key});

  @override
  State<PregnancyMonitoringScreen> createState() =>
      _PregnancyMonitoringScreenState();
}

class _PregnancyMonitoringScreenState extends State<PregnancyMonitoringScreen> {
  final _searchController = TextEditingController();
  String? _filter;

  // Data dummy
  final List<Map<String, dynamic>> _dummyData = [
    {
      "title": "Domba A001",
      "status": "ongoing",
      "startDate": "2026-01-10",
      "expectedDate": "2026-06-10",
    },
    {
      "title": "Domba A002",
      "status": "birthed",
      "startDate": "2025-11-02",
      "expectedDate": "2026-04-02",
    },
    {
      "title": "Domba A003",
      "status": "miscarried",
      "startDate": "2025-12-01",
      "expectedDate": "2026-05-01",
    },
  ];

  List<Map<String, dynamic>> get _filteredData {
    return _dummyData.where((item) {
      if (_filter != null && item['status'] != _filter) return false;

      if (_searchController.text.isNotEmpty) {
        final query = _searchController.text.toLowerCase();
        return item['title'].toString().toLowerCase().contains(query);
      }

      return true;
    }).toList();
  }

  Future<void> _refresh() async {
    await Future.delayed(const Duration(seconds: 1));
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    _searchController.addListener(() => setState(() {}));
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final listData = _filteredData;

    return Scaffold(
      appBar: AppBar(
        foregroundColor: Colors.white,
        backgroundColor: Theme.of(context).colorScheme.primary,
        centerTitle: true,
        title: const Text(
          'Monitoring Kebuntingan',
          style: TextStyle(fontWeight: FontWeight.w700, fontSize: 18),
        ),
      ),
      body: SafeArea(
        child: AppRefreshIndicator(
          onRefresh: _refresh,
          child: CustomScrollView(
            physics: const AlwaysScrollableScrollPhysics(
              parent: BouncingScrollPhysics(),
            ),
            slivers: [
              // 1. Header Teks Statistik
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Statistik Kebuntingan",
                        style: Theme.of(context).textTheme.headlineSmall
                            ?.copyWith(fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 4),
                      const Text(
                        "Pantau masa kebuntingan dan kelahiran domba",
                        style: TextStyle(color: Colors.grey, fontSize: 13),
                      ),
                    ],
                  ),
                ),
              ),

              // 2. Summary Cards (Minimalis & Hitam Putih memakai core widget)
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(16, 0, 16, 14),
                  child: Row(
                    children: [
                      Expanded(
                        child: SummaryCard(
                          label: "Bunting",
                          value: "12",
                          isLoading: false,
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: SummaryCard(
                          label: "Melahirkan",
                          value: "5",
                          isLoading: false,
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: SummaryCard(
                          label: "Keguguran",
                          value: "2",
                          isLoading: false,
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              // 3. Search Bar
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(16, 0, 16, 10),
                  child: SearchBar(
                    controller: _searchController,
                    hintText: 'Cari Eartag domba...',
                    leading: const Icon(Icons.search_rounded),
                    elevation: WidgetStateProperty.all(0),
                    backgroundColor: WidgetStateProperty.all(Colors.white),
                    shape: WidgetStateProperty.all(
                      RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    trailing: [
                      if (_searchController.text.isNotEmpty)
                        IconButton(
                          icon: const Icon(Icons.close),
                          onPressed: () => _searchController.clear(),
                        ),
                    ],
                  ),
                ),
              ),

              // 4. Filter Pills
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(16, 0, 16, 18),
                  child: SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: [
                        FilterPill(
                          label: 'Semua',
                          active: _filter == null,
                          onTap: () => setState(() => _filter = null),
                        ),
                        const SizedBox(width: 8),
                        FilterPill(
                          label: 'Bunting',
                          active: _filter == 'ongoing',
                          onTap: () => setState(() => _filter = 'ongoing'),
                        ),
                        const SizedBox(width: 8),
                        FilterPill(
                          label: 'Melahirkan',
                          active: _filter == 'birthed',
                          onTap: () => setState(() => _filter = 'birthed'),
                        ),
                        const SizedBox(width: 8),
                        FilterPill(
                          label: 'Keguguran',
                          active: _filter == 'miscarried',
                          onTap: () => setState(() => _filter = 'miscarried'),
                        ),
                      ],
                    ),
                  ),
                ),
              ),

              // 5. Dynamic AppBanner (Sudah fix dengan default wildcard _)
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(16, 0, 16, 14),
                  child: switch (_filter) {
                    'ongoing' => const AppBanner(
                      backgroundColor: Color(0xFF2E7D52),
                      pillLabel: 'Ongoing',
                      title: 'Domba Sedang\nDalam Masa Kebuntingan',
                      subtitle: 'Indukan memerlukan pengawasan nutrisi ekstra',
                      decorIcon: Icons.favorite_rounded,
                    ),
                    'birthed' => const AppBanner(
                      backgroundColor: Color(0xFF1E88E5),
                      pillLabel: 'Melahirkan',
                      title: 'Proses Kelahiran\nSelesai',
                      subtitle: 'Catatan anakan baru telah berhasil terdata',
                      decorIcon: Icons.child_care_rounded,
                    ),
                    'miscarried' => AppBanner(
                      backgroundColor: Colors.red.shade700,
                      pillLabel: 'Keguguran',
                      title: 'Kebuntingan Gagal\n/ Keguguran',
                      subtitle: 'Evaluasi kondisi fisik dan kesehatan indukan',
                      decorIcon: Icons.warning_rounded,
                    ),
                    null || _ => const AppBanner(
                      backgroundColor: Colors.black,
                      pillLabel: 'Semua Status',
                      title: 'Seluruh Data\nKebuntingan',
                      subtitle: 'Menampilkan semua masa pemantauan indukan',
                      decorIcon: Icons.list_alt_rounded,
                    ),
                  },
                ),
              ),

              // 6. Title Section List
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(16, 0, 16, 12),
                  child: const Text(
                    'DATA MONITORING KEBUNTINGAN',
                    style: TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w700,
                      color: Colors.black54,
                      letterSpacing: 1.2,
                    ),
                  ),
                ),
              ),

              // 7. List Data
              SliverPadding(
                padding: const EdgeInsets.fromLTRB(16, 0, 16, 24),
                sliver: SliverList.builder(
                  itemCount: listData.length,
                  itemBuilder: (context, index) {
                    final item = listData[index];
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 10),
                      child: PregnancyMonitoringCard(
                        title: item['title'],
                        status: item['status'],
                        startDate: item['startDate'],
                        expectedDate: item['expectedDate'],
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
