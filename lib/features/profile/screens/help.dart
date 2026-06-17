import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class HelpScreen extends StatefulWidget {
  const HelpScreen({super.key});

  @override
  State<HelpScreen> createState() => _HelpScreenState();
}

class _HelpScreenState extends State<HelpScreen> {
  String _selectedCategory = _categories.first;
  String? _expandedQuestion;

  static const List<String> _categories = [
    'Semua',
    'Pendaftaran Domba',
    'Bobot & IoT',
    'Kesehatan',
    'Perkawinan & Kehamilan',
    'Rekomendasi Kawin',
    'Akun & Profil',
  ];

  static const List<_FaqItem> _faqs = [
    // ── Pendaftaran Domba ─────────────────────────────────────
    _FaqItem(
      category: 'Pendaftaran Domba',
      question: 'Bagaimana cara mendaftarkan domba baru?',
      answer:
          'Buka menu Domba, tekan tombol tambah (+), lalu isi data eartag, jenis kelamin, tanggal lahir, ras, dan kandang. Jika induk (sire/dam) domba sudah terdaftar di sistem, pilih dari daftar agar silsilahnya tercatat dengan benar. Lengkapi kondisi kesehatan domba, berat badan, kategori kesehatan (jika domba sakit), tingkat keparahan, serta catatan (opsional).',
    ),
    _FaqItem(
      category: 'Pendaftaran Domba',
      question: 'Apa yang terjadi setelah domba selesai didaftarkan?',
      answer:
          'Sistem otomatis menghitung EBV (Estimated Breeding Value) domba menggunakan model AI berdasarkan data fenotip dan silsilah yang dimasukkan. Nilai EBV ini akan dipakai saat mencari rekomendasi pasangan kawin.',
    ),
    _FaqItem(
      category: 'Pendaftaran Domba',
      question: 'Apakah eartag domba bisa diubah setelah didaftarkan?',
      answer:
          'Eartag adalah identifikasi utama domba di sistem. Jika perlu diubah, buka halaman detail domba lalu pilih Edit Domba. Pastikan eartag baru belum digunakan oleh domba lain di peternakan Anda.',
    ),
    _FaqItem(
      category: 'Pendaftaran Domba',
      question: 'Bagaimana cara menghapus data domba?',
      answer:
          'Buka halaman detail domba, tekan ikon menu (tiga titik) di pojok kanan atas, lalu pilih Hapus. Penghapusan domba bersifat permanen dan akan menghapus seluruh riwayat terkait domba tersebut secara otomatis.',
    ),
    _FaqItem(
      category: 'Pendaftaran Domba',
      question: 'Apakah informasi silsilah domba bisa dilihat?',
      answer:
          'Ya. Di halaman detail domba, Anda bisa melihat informasi induk (dam) dan pejantan (sire) domba jika sudah terdaftar. Silsilah ini digunakan untuk menghitung koefisien inbreeding saat rekomendasi kawin dibuat.',
    ),

    // ── Bobot & IoT ───────────────────────────────────────────
    _FaqItem(
      category: 'Bobot & IoT',
      question: 'Bagaimana cara mencatat bobot domba secara manual?',
      answer:
          'Buka halaman detail domba, pilih tab Bobot Badan, lalu tekan tombol tambah (+). Masukkan tanggal penimbangan dan nilai bobot dalam kilogram. Catatan bersifat opsional.',
    ),
    _FaqItem(
      category: 'Bobot & IoT',
      question: 'Bagaimana cara mencatat bobot domba secara otomatis?',
      answer:
          'Hubungkan timbangan IoT ke jaringan yang sama dengan ponsel Anda. Saat domba ditimbang, data bobot akan terkirim dan tersimpan otomatis ke riwayat bobot domba tersebut tanpa perlu input manual.',
    ),
    _FaqItem(
      category: 'Bobot & IoT',
      question: 'Timbangan IoT tidak mengirim data, apa yang harus dilakukan?',
      answer:
          'Periksa apakah timbangan dan ponsel terhubung ke jaringan yang sama, lalu pastikan timbangan menyala dan dalam jangkauan. Jika masih gagal, Anda tetap bisa mencatat bobot secara manual dari halaman detail domba.',
    ),
    _FaqItem(
      category: 'Bobot & IoT',
      question: 'Apakah bisa melihat grafik perkembangan bobot domba?',
      answer:
          'Ya. Di tab Bobot Badan pada halaman detail domba, tersedia grafik garis yang menampilkan tren perkembangan bobot dari waktu ke waktu. Grafik ini membantu memantau pertumbuhan secara visual.',
    ),
    _FaqItem(
      category: 'Bobot & IoT',
      question: 'Apakah catatan bobot lama bisa diubah atau dihapus?',
      answer:
          'Hanya catatan bobot yang paling baru yang dapat diubah atau dihapus. Catatan bobot lama dikunci untuk menjaga konsistensi riwayat data.',
    ),

    // ── Kesehatan ─────────────────────────────────────────────
    _FaqItem(
      category: 'Kesehatan',
      question: 'Bagaimana cara mencatat kondisi kesehatan domba?',
      answer:
          'Buka halaman detail domba, pilih tab Kesehatan, lalu tekan tombol tambah (+). Isi kondisi kesehatan (Sehat/Sakit), kategori penyakit jika sakit, tingkat keparahan, dan catatan bila diperlukan. Riwayat ini ikut memengaruhi nilai EBV Kesehatan domba.',
    ),
    _FaqItem(
      category: 'Kesehatan',
      question: 'Apakah catatan kesehatan lama bisa diubah?',
      answer:
          'Hanya catatan kesehatan yang paling baru yang dapat diubah. Catatan lama terkunci untuk menjaga integritas riwayat data domba.',
    ),
    _FaqItem(
      category: 'Kesehatan',
      question: 'Apa yang terjadi jika domba kembali sehat setelah sakit?',
      answer:
          'Tambahkan catatan kesehatan baru dengan kondisi "Sehat". Sistem akan menampilkan status terbaru sebagai kondisi aktif domba, sementara riwayat sakit tetap tersimpan untuk referensi.',
    ),
    _FaqItem(
      category: 'Kesehatan',
      question: 'Apakah kondisi kesehatan memengaruhi rekomendasi kawin?',
      answer:
          'Ya. Riwayat kesehatan domba digunakan untuk menghitung EBV Kesehatan. Domba dengan rekam jejak kesehatan yang baik akan mendapatkan nilai EBV Kesehatan lebih tinggi dan lebih diutamakan dalam rekomendasi.',
    ),

    // ── Perkawinan & Kehamilan ────────────────────────────────
    _FaqItem(
      category: 'Perkawinan & Kehamilan',
      question: 'Bagaimana cara mencatat perkawinan domba?',
      answer:
          'Buka halaman detail domba betina, pilih tab Perkawinan, lalu tekan tombol tambah (+). Pilih pejantan dari daftar, isi tanggal kawin, dan tambahkan catatan bila perlu. Setelah disimpan, catatan perkawinan akan tersimpan di riwayat kedua domba.',
    ),
    _FaqItem(
      category: 'Perkawinan & Kehamilan',
      question: 'Bagaimana cara melakukan pemeriksaan kebuntingan?',
      answer:
          'Buka catatan perkawinan domba, lalu tekan tombol Pemeriksaan (+). Pilih hasil: Tidak Diketahui, Bunting, atau Tidak Bunting, beserta tanggal pemeriksaan. Jika hasilnya Bunting, sistem otomatis membuat data kehamilan baru dan Anda diminta mengisi tanggal perkiraan kelahiran.',
    ),
    _FaqItem(
      category: 'Perkawinan & Kehamilan',
      question:
          'Apakah bisa melakukan lebih dari satu pemeriksaan kebuntingan?',
      answer:
          'Tidak. Setelah hasil pemeriksaan diisi dengan Bunting atau Tidak Bunting, tombol tambah pemeriksaan tidak akan muncul lagi karena status sudah final. Hanya hasil "Tidak Diketahui" yang memperbolehkan pemeriksaan ulang.',
    ),
    _FaqItem(
      category: 'Perkawinan & Kehamilan',
      question: 'Bagaimana cara memantau kehamilan domba?',
      answer:
          'Buka menu Monitoring Kebuntingan. Di sini Anda bisa melihat semua domba yang sedang bunting beserta estimasi tanggal kelahiran dan jumlah hari tersisa. Tekan salah satu kartu untuk melihat detail lengkap dan mengubah status kehamilan.',
    ),
    _FaqItem(
      category: 'Perkawinan & Kehamilan',
      question: 'Bagaimana cara mencatat bahwa domba sudah melahirkan?',
      answer:
          'Buka halaman detail kehamilan, tekan tombol Edit Kehamilan, lalu ubah status menjadi "Melahirkan". Isi tanggal melahirkan, jumlah anak yang lahir, dan catatan kelahiran (opsional). Data ini tersimpan otomatis ke riwayat kelahiran.',
    ),
    _FaqItem(
      category: 'Perkawinan & Kehamilan',
      question:
          'Apa yang terjadi jika status kehamilan diubah dari Melahirkan ke status lain?',
      answer:
          'Data kelahiran (jumlah anak dan catatan) yang sebelumnya tersimpan akan dihapus otomatis oleh sistem. Pastikan perubahan dilakukan dengan benar karena data kelahiran tidak dapat dipulihkan setelah dihapus.',
    ),
    _FaqItem(
      category: 'Perkawinan & Kehamilan',
      question: 'Apakah catatan perkawinan bisa dihapus?',
      answer:
          'Ya. Catatan perkawinan dapat dihapus dari riwayat domba. Namun jika domba sudah dinyatakan bunting dan data kehamilan sudah dibuat, disarankan untuk memperbarui status kehamilan terlebih dahulu sebelum menghapus catatan perkawinan.',
    ),

    // ── Rekomendasi Kawin ─────────────────────────────────────
    _FaqItem(
      category: 'Rekomendasi Kawin',
      question: 'Bagaimana sistem menentukan rekomendasi pasangan kawin?',
      answer:
          'Sistem menyaring kandidat yang terlalu sekerabat menggunakan koefisien inbreeding, lalu memprediksi kualitas genetik anak dari kedua calon induk, dan meranking kandidat sesuai bobot kriteria yang Anda tentukan.',
    ),
    _FaqItem(
      category: 'Rekomendasi Kawin',
      question:
          'Mengapa ada domba yang tidak muncul sebagai kandidat pasangan?',
      answer:
          'Pasangan dengan tingkat kekerabatan yang terlalu tinggi otomatis disaring oleh sistem agar keturunan tidak berisiko mengalami penurunan kualitas genetik akibat perkawinan sedarah.',
    ),
    _FaqItem(
      category: 'Rekomendasi Kawin',
      question: 'Apa itu EBV dan kenapa nilainya penting?',
      answer:
          'EBV adalah perkiraan nilai genetik domba untuk suatu sifat, seperti bobot badan, pertambahan bobot harian, dan kesehatan. Semakin sesuai EBV calon induk dengan kebutuhan Anda, semakin besar potensi keturunan unggul yang dihasilkan.',
    ),
    _FaqItem(
      category: 'Rekomendasi Kawin',
      question: 'Apakah bobot kriteria rekomendasi bisa diatur sendiri?',
      answer:
          'Ya. Saat membuka fitur Rekomendasi Kawin, Anda dapat mengatur bobot prioritas untuk setiap kriteria seperti EBV Bobot, EBV Pertambahan Bobot Harian, EBV Kesehatan, dan Koefisien Inbreeding sesuai kebutuhan peternakan.',
    ),
    _FaqItem(
      category: 'Rekomendasi Kawin',
      question:
          'Apakah hasil rekomendasi bisa langsung dicatat sebagai perkawinan?',
      answer:
          'Ya. Dari halaman hasil rekomendasi, Anda bisa langsung menekan tombol Catat Perkawinan pada pasangan yang dipilih. Data pejantan dan induk akan terisi otomatis sehingga proses pencatatan menjadi lebih cepat.',
    ),

    // ── Akun & Profil ─────────────────────────────────────────
    _FaqItem(
      category: 'Akun & Profil',
      question: 'Bagaimana cara mengubah kata sandi akun saya?',
      answer:
          'Masuk ke menu Profil, pilih Ubah Kata Sandi, lalu masukkan kata sandi lama dan kata sandi baru Anda untuk menyelesaikan perubahan.',
    ),
    _FaqItem(
      category: 'Akun & Profil',
      question: 'Bagaimana jika saya lupa kata sandi akun saya?',
      answer:
          'Pilih menu ‘Lupa Kata Sandi’ pada halaman login. Masukkan email yang telah terdaftar. Setelah permintaan berhasil dikirim, admin akan meninjau dan menyetujui reset kata sandi. Setelah disetujui, Anda dapat membuat kata sandi baru untuk mengakses kembali akun.',
    ),
    _FaqItem(
      category: 'Akun & Profil',
      question: 'Apakah data peternakan saya aman di GoSheep?',
      answer:
          'Data peternakan Anda disimpan di server yang terenkripsi dan hanya dapat diakses melalui akun terdaftar Anda. Pastikan untuk menjaga kerahasiaan kata sandi dan tidak membagikannya kepada pihak yang tidak berkepentingan.',
    ),
    _FaqItem(
      category: 'Akun & Profil',
      question: 'Apakah ada riwayat aktivitas yang bisa dilihat?',
      answer:
          'Ya. GoSheep mencatat seluruh aktivitas perubahan data seperti penambahan, pembaruan, dan penghapusan data domba, kesehatan, bobot, perkawinan, dan kehamilan. Anda bisa melihatnya di menu Aktivitas di halaman utama.',
    ),
  ];

  List<_FaqItem> get _filteredFaqs {
    if (_selectedCategory == 'Semua') return _faqs;
    return _faqs.where((f) => f.category == _selectedCategory).toList();
  }

  void _copyToClipboard(String value, String label) {
    Clipboard.setData(ClipboardData(text: value));
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('$label disalin: $value'),
        duration: const Duration(seconds: 2),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final faqs = _filteredFaqs;

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        foregroundColor: Colors.white,
        backgroundColor: scheme.primary,
        centerTitle: true,
        title: const Text(
          'Pusat Bantuan',
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
              padding: const EdgeInsets.fromLTRB(24, 4, 24, 24),
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.15),
                      borderRadius: BorderRadius.circular(14),
                    ),
                    child: const Icon(
                      Icons.support_agent_rounded,
                      color: Colors.white,
                      size: 28,
                    ),
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Ada kendala di GoSheep?',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 15,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const SizedBox(height: 3),
                        Text(
                          'Temukan panduan penggunaan dan solusi kendala anda.',
                          style: TextStyle(
                            color: Colors.white.withValues(alpha: 0.7),
                            fontSize: 12,
                          ),
                        ),
                      ],
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
                  const _SectionLabel('KATEGORI'),
                  const SizedBox(height: 12),
                  SizedBox(
                    height: 36,
                    child: ListView.separated(
                      scrollDirection: Axis.horizontal,
                      itemCount: _categories.length,
                      separatorBuilder: (_, __) => const SizedBox(width: 8),
                      itemBuilder: (context, index) {
                        final category = _categories[index];
                        return _CategoryChip(
                          label: category,
                          selected: category == _selectedCategory,
                          onTap: () => setState(() {
                            _selectedCategory = category;
                            _expandedQuestion = null;
                          }),
                        );
                      },
                    ),
                  ),
                  const SizedBox(height: 24),
                  const _SectionLabel('PERTANYAAN UMUM'),
                  const SizedBox(height: 12),
                  if (faqs.isEmpty)
                    const Padding(
                      padding: EdgeInsets.symmetric(vertical: 20),
                      child: Center(
                        child: Text(
                          'Belum ada pertanyaan untuk kategori ini',
                          style: TextStyle(color: Colors.black38, fontSize: 12),
                        ),
                      ),
                    )
                  else
                    ListView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: faqs.length,
                      itemBuilder: (context, index) {
                        final faq = faqs[index];
                        final isOpen = _expandedQuestion == faq.question;
                        return _FaqCard(
                          faq: faq,
                          isOpen: isOpen,
                          onTap: () => setState(() {
                            _expandedQuestion = isOpen ? null : faq.question;
                          }),
                        );
                      },
                    ),
                  const SizedBox(height: 32),
                  SizedBox(
                    width: double.infinity,
                    height: 50,
                    child: ElevatedButton.icon(
                      onPressed: () => _copyToClipboard(
                        '+62 812-3456-7890',
                        'Nomor WhatsApp',
                      ),
                      icon: const Icon(
                        Icons.chat_rounded,
                        color: Colors.white,
                        size: 18,
                      ),
                      label: const Text(
                        "Hubungi Customer Support",
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 40),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _FaqItem {
  final String category;
  final String question;
  final String answer;

  const _FaqItem({
    required this.category,
    required this.question,
    required this.answer,
  });
}

class _CategoryChip extends StatelessWidget {
  final String label;
  final bool selected;
  final VoidCallback onTap;

  const _CategoryChip({
    required this.label,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
        decoration: BoxDecoration(
          color: selected
              ? scheme.primary
              : scheme.primary.withValues(alpha: 0.08),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: scheme.primary.withValues(alpha: selected ? 0 : 0.2),
          ),
        ),
        child: Text(
          label,
          style: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w600,
            color: selected ? Colors.white : scheme.primary,
          ),
        ),
      ),
    );
  }
}

class _FaqCard extends StatelessWidget {
  final _FaqItem faq;
  final bool isOpen;
  final VoidCallback onTap;

  const _FaqCard({
    required this.faq,
    required this.isOpen,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;

    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.black12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          InkWell(
            borderRadius: BorderRadius.circular(12),
            onTap: onTap,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      faq.question,
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                        color: isOpen ? scheme.primary : Colors.black87,
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  AnimatedRotation(
                    turns: isOpen ? 0.5 : 0,
                    duration: const Duration(milliseconds: 200),
                    child: Icon(
                      Icons.keyboard_arrow_down_rounded,
                      size: 20,
                      color: scheme.primary,
                    ),
                  ),
                ],
              ),
            ),
          ),
          if (isOpen)
            Padding(
              padding: const EdgeInsets.fromLTRB(14, 0, 14, 14),
              child: Text(
                faq.answer,
                style: const TextStyle(
                  fontSize: 12.5,
                  color: Colors.black54,
                  height: 1.5,
                ),
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
