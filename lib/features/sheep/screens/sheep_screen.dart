import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:gosheep_mobile/features/sheep/widgets/add_sheep_sheet.dart';
import 'package:gosheep_mobile/features/sheep/widgets/filter_pill.dart';
import 'package:gosheep_mobile/features/sheep/widgets/sheep_card.dart';
import 'package:gosheep_mobile/features/sheep/widgets/stat_card.dart';

import '../../../data/models/sheep.dart';
import '../../../data/providers/sheep_provider.dart';

const _breedList = ['Merino', 'Garut', 'Texel', 'Dorper', 'Suffolk'];

class SheepScreen extends StatelessWidget {
  const SheepScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => SheepProvider()..fetchInitial(),
      child: const _SheepScreenView(),
    );
  }
}

class _SheepScreenView extends StatefulWidget {
  const _SheepScreenView();

  @override
  State<_SheepScreenView> createState() => _SheepScreenViewState();
}

class _SheepScreenViewState extends State<_SheepScreenView> {
  final _search = TextEditingController();
  final _scrollController = ScrollController();

  String _filter = 'all';

  @override
  void initState() {
    super.initState();

    _scrollController.addListener(() {
      if (_scrollController.position.pixels >=
          _scrollController.position.maxScrollExtent - 200) {
        context.read<SheepProvider>().fetchMore();
      }
    });
  }

  @override
  void dispose() {
    _search.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  List<Sheep> _filtered(List<Sheep> list) {
    final q = _search.text.toLowerCase();

    return list.where((s) {
      return (_filter == 'all' || s.statusUi == _filter) &&
          (q.isEmpty || s.earTag.toLowerCase().contains(q));
    }).toList();
  }

  double _maxBerat(List<Sheep> list) {
    if (list.isEmpty) return 1;
    return list
        .map((s) => s.weight ?? 0)
        .reduce((a, b) => a > b ? a : b);
  }

  void _openAdd() => showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    builder: (_) => AddSheepSheet(
      breedList: _breedList,
      onAdd: () {},
    ),
  );

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<SheepProvider>();

    final sheepList = _filtered(provider.sheepList);
    final healthy =
        provider.sheepList.where((s) => s.statusUi == 'sehat').length;

    return Scaffold(
      backgroundColor: const Color(0xFFF5F4F0),
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            /// HEADER
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
              child: Row(
                children: [
                  const Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Data Domba',
                          style: TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        SizedBox(height: 2),
                        Text(
                          'Peternakan Maju Jaya',
                          style: TextStyle(fontSize: 13, color: Colors.black54),
                        ),
                      ],
                    ),
                  ),
                  GestureDetector(
                    onTap: _openAdd,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 14,
                        vertical: 10,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.black,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: const Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(Icons.add, color: Colors.white, size: 16),
                          SizedBox(width: 6),
                          Text(
                            'Tambah',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 13,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),

            /// BODY
            Expanded(
              child: ListView(
                controller: _scrollController,
                padding: const EdgeInsets.fromLTRB(16, 16, 16, 24),
                children: [
                  /// STATS
                  Row(
                    children: [
                      StatCard(
                        label: 'Total',
                        value: '${provider.sheepList.length}',
                      ),
                      const SizedBox(width: 10),
                      StatCard(
                        label: 'Sehat',
                        value: '$healthy',
                        valueColor: const Color(0xFF3B6D11),
                      ),
                      const SizedBox(width: 10),
                      StatCard(
                        label: 'Sakit',
                        value:
                        '${provider.sheepList.length - healthy}',
                        valueColor: const Color(0xFFA32D2D),
                      ),
                    ],
                  ),

                  const SizedBox(height: 14),

                  /// SEARCH
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Row(
                      children: [
                        const Icon(Icons.search_rounded, size: 18),
                        const SizedBox(width: 8),
                        Expanded(
                          child: TextField(
                            controller: _search,
                            onChanged: (_) => setState(() {}),
                            decoration: const InputDecoration(
                              hintText: 'Cari ID domba...',
                              border: InputBorder.none,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 10),

                  /// FILTER
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: [
                        for (final f in [
                          ('Semua', 'all'),
                          ('Sehat', 'sehat'),
                          ('Sakit', 'sakit'),
                        ]) ...[
                          FilterPill(
                            label: f.$1,
                            active: _filter == f.$2,
                            onTap: () => setState(() => _filter = f.$2),
                          ),
                          const SizedBox(width: 8),
                        ],
                      ],
                    ),
                  ),

                  const SizedBox(height: 18),

                  const Text(
                    'DAFTAR TERNAK',
                    style: TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w700,
                      color: Colors.black54,
                      letterSpacing: 1.2,
                    ),
                  ),

                  const SizedBox(height: 12),

                  /// EMPTY STATE
                  if (sheepList.isEmpty && !provider.isLoading)
                    const Center(
                      child: Padding(
                        padding: EdgeInsets.all(40),
                        child: Text('Tidak ada data'),
                      ),
                    )
                  else
                    ...sheepList.map(
                          (s) => SheepCard(
                        key: ValueKey(s.id),
                        sheep: s,
                        maxBerat: _maxBerat(sheepList),
                        onDelete: () {},
                      ),
                    ),

                  /// LOADING
                  if (provider.isLoading)
                    const Padding(
                      padding: EdgeInsets.all(16),
                      child: Center(child: CircularProgressIndicator()),
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