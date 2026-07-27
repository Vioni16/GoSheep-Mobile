import 'package:flutter/material.dart';

class AboutScreen extends StatelessWidget {
  const AboutScreen({super.key});

  static const String _appVersion = 'v1.0.0';
  static const String _appDescription =
      'GoSheep adalah platform manajemen peternakan domba modern yang mengintegrasikan teknologi Internet of Things (IoT) dan Artificial Intelligence (AI). Sensor DHT22 pada setiap kandang memantau suhu dan kelembaban secara otomatis, mendeteksi kondisi heat stress yang berpengaruh pada kesehatan domba. Model AI berbasis Random Forest menghitung EBV (Estimated Breeding Value) dari data berat badan dan kesehatan, lalu sistem merekomendasikan pasangan kawin terbaik menggunakan metode Wright Coefficient, AHP, dan MOORA.';

  static const List<_FeatureItem> _features = [
    _FeatureItem(
      icon: Icons.analytics_rounded,
      title: 'Prediksi EBV Pintar',
      description:
          'Menghitung tiga nilai Estimated Breeding Value (EBV) — EBV Berat Badan, EBV ADG (pertambahan berat badan harian), dan EBV Kesehatan — menggunakan model Random Forest berdasarkan data berat badan dan riwayat kesehatan domba. EBV diperbarui otomatis setiap ada data baru.',
    ),
    _FeatureItem(
      icon: Icons.account_tree_rounded,
      title: 'Manajemen Silsilah',
      description:
          'Menyimpan hubungan induk (dam), pejantan (sire), dan keturunan secara terstruktur untuk mendukung analisis genetik, perhitungan EBV, dan pengendalian inbreeding menggunakan Wright Coefficient.',
    ),
    _FeatureItem(
      icon: Icons.favorite_rounded,
      title: 'Monitoring Kesehatan & IoT',
      description:
          'Pencatatan kondisi kesehatan domba oleh staff, dilengkapi deteksi heat stress otomatis dari sensor DHT22 di kandang. Jika suhu rata-rata 20 menit ≥ 35°C, sistem membuat catatan kesehatan otomatis dan mengirim notifikasi ke aplikasi.',
    ),
    _FeatureItem(
      icon: Icons.device_thermostat_rounded,
      title: 'Pemantauan Lingkungan Kandang',
      description:
          'Sensor DHT22 + ESP32 membaca suhu dan kelembaban kandang setiap 5 menit via MQTT. Data ditampilkan real-time di aplikasi dan tersimpan sebagai riwayat log untuk pemantauan jangka panjang.',
    ),
    _FeatureItem(
      icon: Icons.alt_route_rounded,
      title: 'Rekomendasi Perkawinan',
      description:
          'Sistem seleksi AI empat tahap: filter usia & status aktif → filter inbreeding Wright Coefficient (COI ≥ 6,25% dibuang) → prediksi Expected EBV Offspring → ranking MOORA dengan bobot kriteria AHP.',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        foregroundColor: Colors.white,
        backgroundColor: scheme.primary,
        centerTitle: true,
        title: const Text(
          'Tentang Aplikasi',
          style: TextStyle(fontWeight: FontWeight.w700, fontSize: 18),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: double.infinity,
              color: scheme.primary,
              padding: const EdgeInsets.fromLTRB(24, 4, 24, 32),
              child: Column(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(20),
                    child: Image.asset(
                      'assets/images/goSheep_logo.png',
                      width: 76,
                      height: 76,
                      fit: BoxFit.cover,
                    ),
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    'GoSheep Mobile',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Versi $_appVersion',
                    style: TextStyle(
                      color: Colors.white.withValues(alpha: 0.7),
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),

            Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const _SectionLabel('DESKRIPSI APLIKASI'),
                  const SizedBox(height: 12),
                  const Text(
                    _appDescription,
                    style: TextStyle(
                      fontSize: 13,
                      color: Colors.black,
                      height: 1.6,
                    ),
                  ),
                  const SizedBox(height: 28),
                  const _SectionLabel('FITUR UNGGULAN'),
                  const SizedBox(height: 12),

                  ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: _features.length,
                    itemBuilder: (context, index) {
                      return _FeatureCard(feature: _features[index]);
                    },
                  ),

                  const SizedBox(height: 16),
                  const Divider(color: Colors.black12),
                  const SizedBox(height: 16),

                  const Center(
                    child: Text(
                      '© 2026 GoSheep Team. All Rights Reserved.',
                      style: TextStyle(
                        color: Colors.black38,
                        fontSize: 11,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _FeatureItem {
  final IconData icon;
  final String title;
  final String description;

  const _FeatureItem({
    required this.icon,
    required this.title,
    required this.description,
  });
}

class _FeatureCard extends StatelessWidget {
  final _FeatureItem feature;

  const _FeatureCard({required this.feature});

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.black12),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: scheme.primary.withValues(alpha: 0.08),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(feature.icon, color: scheme.primary, size: 20),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  feature.title,
                  style: const TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: Colors.black87,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  feature.description,
                  style: const TextStyle(
                    fontSize: 12,
                    color: Colors.black54,
                    height: 1.4,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _SectionLabel extends StatelessWidget {
  final String text;
  const _SectionLabel(this.text);

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: const TextStyle(
        fontWeight: FontWeight.w700,
        color: Colors.black38,
        fontSize: 11,
        letterSpacing: 1.2,
      ),
    );
  }
}
