import 'package:flutter/material.dart';
import 'package:gosheep_mobile/features/sheep/widgets/add_sheep_sheet.dart';
import 'package:gosheep_mobile/features/sheep/widgets/filter_pill.dart';
import 'package:gosheep_mobile/features/sheep/widgets/sheep_card.dart';
import 'package:gosheep_mobile/features/sheep/widgets/stat_card.dart';
import '../../../data/models/sheep.dart';

const _breedList = ['Merino', 'Garut', 'Texel', 'Dorper', 'Suffolk'];

final _initialData = [
  Sheep(
    id: 1,
    name: 'Shaun',
    breed: 'Merino',
    weight: 45.5,
    statusUi: 'Sehat',
    earTag: 'D001',
    gender: 'Male'
  ),
  Sheep(
    id: 2,
    name: 'Mbandot',
    breed: 'Garut',
    weight: 40.1,
    statusUi: 'Sakit',
    earTag: 'D002',
    gender: 'Female'
  ),
  Sheep(
    id: 3,
    name: 'Bolly',
    breed: 'Texel',
    weight: 49.5,
    statusUi: 'Sehat',
    earTag: 'D003',
    gender: 'Male'
  ),
];

class SheepScreen extends StatefulWidget {
  const SheepScreen({super.key});
  @override
  State<SheepScreen> createState() => _SheepScreenState();
}

class _SheepScreenState extends State<SheepScreen> {
  final _sheep = List<Sheep>.from(_initialData);
  final _search = TextEditingController();
  String _filter = 'all';

  @override
  void dispose() {
    _search.dispose();
    super.dispose();
  }

  List<Sheep> get _filtered => _sheep.where((s) {
    final q = _search.text.toLowerCase();
    return (_filter == 'all' || s.statusUi.toLowerCase() == _filter) &&
        (q.isEmpty ||
            s.name.toLowerCase().contains(q) ||
            s.earTag.toLowerCase().contains(q));
  }).toList();

  double get _maxBerat => _sheep.isEmpty
      ? 1
      : _sheep.map((s) => s.weight).reduce((a, b) => a > b ? a : b);

  void _delete(Sheep s) {
    setState(() => _sheep.remove(s));
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('${s.name} berhasil dihapus'),
        behavior: SnackBarBehavior.floating,
        backgroundColor: Colors.black87,
      ),
    );
  }

  void _openAdd() => showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    builder: (_) => AddSheepSheet(
      breedList: _breedList,
      onAdd: (s) {
        // setState(() => _sheep.insert(0, s));
        // ScaffoldMessenger.of(context).showSnackBar(
        //   const SnackBar(
        //     content: Text('Data domba berhasil ditambahkan'),
        //     behavior: SnackBarBehavior.floating,
        //     backgroundColor: Color(0xFF3B6D11),
        //   ),
        // );
      },
    ),
  );

  @override
  Widget build(BuildContext context) {
    final sheepList = _filtered;
    final healthy = _sheep.where((s) => s.statusUi == 'Sehat').length;

    return Scaffold(
      backgroundColor: const Color(0xFFF5F4F0),
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
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
            Expanded(
              child: ListView(
                padding: const EdgeInsets.fromLTRB(16, 16, 16, 24),
                children: [
                  Row(
                    children: [
                      StatCard(label: 'Total', value: '${_sheep.length}'),
                      const SizedBox(width: 10),
                      StatCard(
                        label: 'Sehat',
                        value: '$healthy',
                        valueColor: const Color(0xFF3B6D11),
                      ),
                      const SizedBox(width: 10),
                      StatCard(
                        label: 'Sakit',
                        value: '${_sheep.length - healthy}',
                        valueColor: const Color(0xFFA32D2D),
                      ),
                    ],
                  ),
                  const SizedBox(height: 14),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: Colors.black.withValues(alpha: 0.05),
                      ),
                    ),
                    child: Row(
                      children: [
                        Icon(
                          Icons.search_rounded,
                          size: 18,
                          color: Colors.black.withValues(alpha: 0.4),
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: TextField(
                            controller: _search,
                            onChanged: (_) => setState(() {}),
                            style: const TextStyle(fontSize: 14),
                            decoration: InputDecoration(
                              hintText: 'Cari nama atau ID domba...',
                              hintStyle: TextStyle(
                                color: Colors.black.withValues(alpha: 0.3),
                                fontSize: 14,
                              ),
                              isDense: true,
                              border: InputBorder.none,
                              contentPadding: const EdgeInsets.symmetric(
                                vertical: 10,
                              ),
                            ),
                          ),
                        ),
                        if (_search.text.isNotEmpty)
                          GestureDetector(
                            onTap: () {
                              _search.clear();
                              setState(() {});
                            },
                            child: Icon(
                              Icons.close_rounded,
                              size: 16,
                              color: Colors.black.withValues(alpha: 0.4),
                            ),
                          ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 10),
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: [
                        for (final f in [
                          ('Semua', 'all'),
                          ('Sehat', 'healthy'),
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
                  Text(
                    'DAFTAR TERNAK',
                    style: TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w700,
                      color: Colors.black.withValues(alpha: 0.4),
                      letterSpacing: 1.2,
                    ),
                  ),
                  const SizedBox(height: 12),
                  if (sheepList.isEmpty)
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 40),
                      child: Center(
                        child: Column(
                          children: [
                            Icon(
                              Icons.search_off_rounded,
                              size: 48,
                              color: Colors.black.withValues(alpha: 0.2),
                            ),
                            const SizedBox(height: 12),
                            Text(
                              'Tidak ada domba ditemukan',
                              style: TextStyle(
                                color: Colors.black.withValues(alpha: 0.5),
                                fontSize: 14,
                              ),
                            ),
                          ],
                        ),
                      ),
                    )
                  else
                    ...sheepList.map(
                      (s) => SheepCard(
                        key: ValueKey(s.id),
                        sheep: s,
                        maxBerat: _maxBerat,
                        onDelete: () => _delete(s),
                      ),
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