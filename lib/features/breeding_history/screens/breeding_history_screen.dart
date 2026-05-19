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

  final breedingData = [
    {
      "male": "ET020",
      "male_id": 2,

      "female": "ET017",
      "female_id": 1,

      "date": "20 Mei 2026",
      "status": "Berhasil",
    },
  ];

  List<Map<String, dynamic>> get filteredData {
    if (selectedFilter == "Semua") return breedingData;
    return breedingData.where((e) => e["status"] == selectedFilter).toList();
  }

  @override
  Widget build(BuildContext context) {
    final success = breedingData.where((e) => e["status"] == "Berhasil").length;
    final proses = breedingData.where((e) => e["status"] == "Proses").length;
    final gagal = breedingData.where((e) => e["status"] == "Gagal").length;

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
                  label: "Bunting",
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
                onTap: () => setState(() => selectedFilter = "Semua"),
              ),

              const SizedBox(width: 8),

              FilterChipItem(
                label: "Bunting",
                isActive: selectedFilter == "Bunting",
                onTap: () => setState(() => selectedFilter = "Bunting"),
              ),

              const SizedBox(width: 8),

              FilterChipItem(
                label: "Proses",
                isActive: selectedFilter == "Proses",
                onTap: () => setState(() => selectedFilter = "Proses"),
              ),

              const SizedBox(width: 8),

              FilterChipItem(
                label: "Gagal",
                isActive: selectedFilter == "Gagal",
                onTap: () => setState(() => selectedFilter = "Gagal"),
              ),
            ],
          ),

          const SizedBox(height: 16),

          if (filteredData.isEmpty)
            const Center(child: Text("Tidak ada data"))
          else
            ...filteredData.map((item) => BreedingCard(item: item)),
        ],
      ),
    );
  }
}
