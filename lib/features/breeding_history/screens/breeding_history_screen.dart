import 'package:flutter/material.dart';
import 'package:gosheep_mobile/features/breeding_history/widgets/breeding_history_card.dart';
import 'package:gosheep_mobile/features/breeding_history/widgets/breeding_history_summary.dart';
import 'package:gosheep_mobile/features/breeding_history/widgets/filter_chip_breeding.dart';

class BreedingHistoryScreen extends StatefulWidget {
  const BreedingHistoryScreen({super.key});

  @override
  State<BreedingHistoryScreen> createState() => _BreedingHistoryScreenState();
}

class _BreedingHistoryScreenState extends State<BreedingHistoryScreen> {
  String selectedFilter = "Semua";

  final List<Map<String, dynamic>> data = [
    {
      "male": "Domba A",
      "female": "Domba B",
      "date": "10 Mei 2026",
      "status": "Berhasil",
    },
    {
      "male": "Domba C",
      "female": "Domba D",
      "date": "8 Mei 2026",
      "status": "Proses",
    },
    {
      "male": "Domba E",
      "female": "Domba F",
      "date": "5 Mei 2026",
      "status": "Gagal",
    },
  ];

  List<Map<String, dynamic>> get filteredData {
    if (selectedFilter == "Semua") return data;
    return data.where((e) => e["status"] == selectedFilter).toList();
  }

  Color _getColor(String label) {
    switch (label) {
      case "Berhasil":
        return Colors.green;
      case "Proses":
        return Colors.orange;
      case "Gagal":
        return Colors.red;
      default:
        return Colors.grey;
    }
  }

  @override
  Widget build(BuildContext context) {
    final success = data.where((e) => e["status"] == "Berhasil").length;
    final proses = data.where((e) => e["status"] == "Proses").length;
    final gagal = data.where((e) => e["status"] == "Gagal").length;

    return Scaffold(
      appBar: AppBar(
        foregroundColor: Colors.white,
        backgroundColor: Theme.of(context).colorScheme.primary,
        centerTitle: true,
        title: const Text(
          'Riwayat Kawin',
          style: TextStyle(fontWeight: FontWeight.w700, fontSize: 18),
        ),
      ),

      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          const Text(
            "Riwayat Breeding",
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 4),
          const Text(
            "Pantau hasil perkawinan domba",
            style: TextStyle(color: Colors.grey, fontSize: 13),
          ),

          const SizedBox(height: 16),

          Row(
            children: [
              Expanded(
                child: SummaryCard(
                  label: "Berhasil",
                  count: success,
                  color: Colors.green,
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: SummaryCard(
                  label: "Proses",
                  count: proses,
                  color: Colors.orange,
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: SummaryCard(
                  label: "Gagal",
                  count: gagal,
                  color: Colors.red,
                ),
              ),
            ],
          ),

          const SizedBox(height: 16),

          Row(
            children: [
              FilterChipItem(
                label: "Semua",
                isActive: selectedFilter == "Semua",
                color: Colors.grey,
                onTap: () => setState(() => selectedFilter = "Semua"),
              ),
              const SizedBox(width: 8),
              FilterChipItem(
                label: "Berhasil",
                isActive: selectedFilter == "Berhasil",
                color: Colors.green,
                onTap: () => setState(() => selectedFilter = "Berhasil"),
              ),
              const SizedBox(width: 8),
              FilterChipItem(
                label: "Proses",
                isActive: selectedFilter == "Proses",
                color: Colors.orange,
                onTap: () => setState(() => selectedFilter = "Proses"),
              ),
              const SizedBox(width: 8),
              FilterChipItem(
                label: "Gagal",
                isActive: selectedFilter == "Gagal",
                color: Colors.red,
                onTap: () => setState(() => selectedFilter = "Gagal"),
              ),
            ],
          ),

          const SizedBox(height: 16),

          if (filteredData.isEmpty)
            const Center(child: Text("Tidak ada data"))
          else
            ...filteredData.map((item) => BreedingCard(item: item)).toList(),
        ],
      ),
    );
  }
}
