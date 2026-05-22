import 'package:flutter/material.dart';
import 'package:gosheep_mobile/features/healt_history/widgets/add_healt_sheet.dart';
import 'package:gosheep_mobile/features/healt_history/widgets/health_card.dart';
import 'package:gosheep_mobile/features/healt_history/widgets/health_chart_card.dart';
import 'package:gosheep_mobile/features/healt_history/widgets/health_statistics_header.dart';

class HealthHistoryScreen extends StatefulWidget {
  const HealthHistoryScreen({super.key});

  @override
  State<HealthHistoryScreen> createState() => _HealthHistoryScreenState();
}

class _HealthHistoryScreenState extends State<HealthHistoryScreen> {
  final List<Map<String, dynamic>> healthData = [
    {
      "id": 1,
      "earTag": "ET017",
      "gender": "Betina",
      "category": "Pemeriksaan",
      "condition": "Demam ringan",
      "severity": "Sedang",
      "date": "12 Mei 2026",
      "source": "Input Manual",
      "recordedBy": "Dokter Hewan",
    },
    {
      "id": 2,
      "earTag": "ET020",
      "gender": "Jantan",
      "category": "Vitamin",
      "condition": "Kondisi sehat",
      "severity": "Ringan",
      "date": "10 Mei 2026",
      "source": "Sistem Terjadwal",
      "recordedBy": "Peternak",
    },
    {
      "id": 3,
      "earTag": "ET031",
      "gender": "Betina",
      "category": "Infeksi",
      "condition": "Infeksi kulit",
      "severity": "Berat",
      "date": "08 Mei 2026",
      "source": "Input Manual",
      "recordedBy": "Peternak",
    },
    {
      "id": 4,
      "earTag": "ET015",
      "gender": "Jantan",
      "category": "Pemeriksaan",
      "condition": "Nafsu makan menurun",
      "severity": "Sedang",
      "date": "06 Mei 2026",
      "source": "Sensor IoT",
      "recordedBy": "Sistem",
    },
  ];

  Future<void> _openAddHealthSheet(BuildContext context) async {
    final result = await showModalBottomSheet<Map<String, dynamic>>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => const AddHealthSheet(),
    );

    if (result != null && mounted) {
      setState(() {
        healthData.insert(0, result);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            pinned: true,
            expandedHeight: 60.0,
            centerTitle: true,
            foregroundColor: Colors.white,
            backgroundColor: Theme.of(context).colorScheme.primary,
            elevation: 0,
            title: const Text(
              "Riwayat Kesehatan",
              style: TextStyle(fontWeight: FontWeight.w700, fontSize: 18),
            ),
          ),

          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Pantau Kesehatan',
                        style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                              fontWeight: FontWeight.bold,
                            ),
                      ),
                      
                      InkWell(
                        onTap: () => _openAddHealthSheet(context),
                        borderRadius: BorderRadius.circular(20),
                        child: Ink(
                          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
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
                  const SizedBox(height: 4),
                  const Text(
                    'Kelola kondisi kesehatan domba',
                    style: TextStyle(color: Colors.grey, fontSize: 13),
                  ),
                  const SizedBox(height: 16), 

                  const HealthStatisticsHeader(
                    totalRecords: 24,
                    healthyCount: 15,
                    attentionCount: 9,
                  ),
                  const SizedBox(height: 16),
                  const HealthChartCard(),
                  const SizedBox(height: 20),
                  Text(
                    "Riwayat Pemeriksaan",
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.w700,
                          color: const Color(0xFF2D3132),
                        ),
                  ),
                  const SizedBox(height: 14),
                ],
              ),
            ),
          ),

          SliverPadding(
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 24),
            sliver: SliverList(
              delegate: SliverChildBuilderDelegate(
                (context, index) {
                  return HealthCard(
                    item: healthData[index],
                  );
                },
                childCount: healthData.length,
              ),
            ),
          ),
        ],
      ),
    );
  }
}