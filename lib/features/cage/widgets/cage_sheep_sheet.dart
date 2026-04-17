import 'package:flutter/material.dart';
import 'package:gosheep_mobile/data/models/cage.dart';
import 'ear_tag_chip.dart';

class CageSheepSheet extends StatefulWidget {
  final String cageName;
  final List<CageSheep> sheep;

  const CageSheepSheet({
    super.key,
    required this.cageName,
    required this.sheep,
  });

  @override
  State<CageSheepSheet> createState() => _CageSheepSheetState();
}

class _CageSheepSheetState extends State<CageSheepSheet> {
  final TextEditingController _searchController = TextEditingController();
  String _query = '';

  List<CageSheep> get _filteredSheep {
    if (_query.isEmpty) return widget.sheep;

    return widget.sheep.where((s) {
      return s.earTag.toLowerCase().contains(_query.toLowerCase());
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    final sheep = _filteredSheep;

    return DraggableScrollableSheet(
      initialChildSize: 0.65,
      minChildSize: 0.4,
      maxChildSize: 0.9,
      builder: (_, controller) {
        return Container(
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
          ),
          child: Column(
            children: [
              const SizedBox(height: 12),

              Container(
                width: 42,
                height: 4,
                decoration: BoxDecoration(
                  color: const Color(0xFFDDE3EA),
                  borderRadius: BorderRadius.circular(2),
                ),
              ),

              const SizedBox(height: 14),

              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        gradient:  LinearGradient(
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                          stops: [0.8, 0.6],
                          colors: [Color(0xFF0F5132), Color(0xFF8D6E63)],
                        ),
                      ),
                      child: const Icon(
                        Icons.fence_rounded,
                        color: Color(0xFFFFFFFF),
                        size: 20,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          widget.cageName,
                          style: const TextStyle(
                            fontSize: 17,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        Text(
                          '${widget.sheep.length} domba terdaftar',
                          style: const TextStyle(
                            fontSize: 12,
                            color: Color(0xFF7F8C8D),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 14),

              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: TextField(
                  controller: _searchController,
                  onChanged: (val) => setState(() => _query = val),
                  decoration: InputDecoration(
                    hintText: 'Cari ear tag...',
                    prefixIcon: const Icon(Icons.search),
                    isDense: true,
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 12,
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 14),

              const Divider(height: 1),

              const SizedBox(height: 12),

              Expanded(
                child: SingleChildScrollView(
                  controller: controller,
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: sheep.isEmpty
                      ? const Padding(
                    padding: EdgeInsets.only(top: 60),
                    child: Center(
                      child: Text(
                        'Tidak ditemukan',
                        style: TextStyle(
                          color: Color(0xFF7F8C8D),
                        ),
                      ),
                    ),
                  )
                      : Wrap(
                    spacing: 10,
                    runSpacing: 10,
                    children: sheep.map((s) {
                      return EarTagChip(
                        sheep: s,
                        onTap: () {
                          // TODO: detail sheep
                        },
                      );
                    }).toList(),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}