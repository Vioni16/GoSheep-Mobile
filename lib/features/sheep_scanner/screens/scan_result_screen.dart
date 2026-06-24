import 'package:flutter/material.dart';
import 'package:gosheep_mobile/core/utils/format_helper.dart';
import 'package:gosheep_mobile/core/utils/sheep_status_util.dart';
import 'package:gosheep_mobile/data/models/sheep_detail.dart';
import 'package:gosheep_mobile/data/services/sheep_service.dart';
import 'package:gosheep_mobile/features/health_record/screens/health_record_screen.dart';
import 'package:gosheep_mobile/features/sheep/screens/sheep_detail_screen.dart';
import 'package:gosheep_mobile/features/sheep/screens/edit_sheep_screen.dart';
import 'package:gosheep_mobile/features/weight_record/screens/weight_record_screen.dart';

class ScanResultScreen extends StatefulWidget {
  final String earTag;

  const ScanResultScreen({super.key, required this.earTag});

  @override
  State<ScanResultScreen> createState() => _ScanResultScreenState();
}

class _ScanResultScreenState extends State<ScanResultScreen>
    with SingleTickerProviderStateMixin {
  final _service = SheepService();

  SheepDetail? _sheep;
  bool _isLoading = true;
  String? _error;

  late AnimationController _animController;
  late Animation<double> _fadeAnim;
  late Animation<Offset> _slideAnim;

  @override
  void initState() {
    super.initState();

    _animController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );

    _fadeAnim = CurvedAnimation(parent: _animController, curve: Curves.easeOut);

    _slideAnim = Tween<Offset>(
      begin: const Offset(0, 0.12),
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: _animController, curve: Curves.easeOut));

    _fetchSheep();
  }

  Future<void> _fetchSheep() async {
    setState(() {
      _isLoading = true;
      _error = null;
    });

    try {
      final result = await _service.scanByEarTag(widget.earTag);
      if (!mounted) return;
      setState(() => _sheep = result);
      _animController.forward();
    } catch (e) {
      if (!mounted) return;
      setState(() => _error = e.toString().replaceFirst('Exception: ', ''));
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  void dispose() {
    _animController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final primary = Theme.of(context).colorScheme.primary;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: primary,
        foregroundColor: Colors.white,
        centerTitle: false,
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Hasil Scan',
              style: TextStyle(
                fontWeight: FontWeight.w700,
                fontSize: 18,
                letterSpacing: 0.3,
              ),
            ),
            Text(
              'Ear Tag: ${widget.earTag}',
              style: TextStyle(
                color: Colors.white.withValues(alpha: 0.75),
                fontSize: 12,
              ),
            ),
          ],
        ),
      ),
      body: _buildBody(),
    );
  }

  Widget _buildBody() {
    if (_isLoading) return _buildLoading();
    if (_error != null) return _buildError();
    if (_sheep == null) return const SizedBox.shrink();
    return _buildResult();
  }

  Widget _buildLoading() {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const SizedBox(
            width: 40,
            height: 40,
            child: CircularProgressIndicator(strokeWidth: 3),
          ),
          const SizedBox(height: 16),
          const Text(
            'Mencari domba...',
            style: TextStyle(color: Colors.black54, fontSize: 14),
          ),
        ],
      ),
    );
  }

  Widget _buildError() {
    final isNotFound =
        _error?.toLowerCase().contains('tidak ditemukan') ?? false;

    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 72,
              height: 72,
              decoration: BoxDecoration(
                color: isNotFound ? Colors.orange : Colors.red,
                shape: BoxShape.circle,
              ),
              child: Icon(
                isNotFound ? Icons.search_off_rounded : Icons.wifi_off_rounded,
                color: Colors.white,
                size: 34,
              ),
            ),
            const SizedBox(height: 20),
            Text(
              isNotFound ? 'Domba Tidak Ditemukan' : 'Gagal Memuat',
              style: const TextStyle(
                color: Colors.black87,
                fontSize: 18,
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              isNotFound
                  ? 'Tidak ada domba dengan ear tag "${widget.earTag}" yang terdaftar di sistem.'
                  : (_error ?? 'Terjadi kesalahan. Silakan coba lagi.'),
              textAlign: TextAlign.center,
              style: const TextStyle(
                color: Colors.black54,
                fontSize: 13,
                height: 1.5,
              ),
            ),
            const SizedBox(height: 28),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _ActionButton(
                  label: 'Scan Ulang',
                  icon: Icons.qr_code_scanner_rounded,
                  onTap: () => Navigator.pop(context),
                  outline: true,
                ),
                const SizedBox(width: 12),
                _ActionButton(
                  label: 'Coba Lagi',
                  icon: Icons.refresh_rounded,
                  onTap: _fetchSheep,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildResult() {
    final sheep = _sheep!;
    final isHealthy = sheep.statusUi == 'sehat';
    final statusColor = SheepStatusUtil.getHealthColor(sheep.statusUi);

    return FadeTransition(
      opacity: _fadeAnim,
      child: SlideTransition(
        position: _slideAnim,
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(16, 20, 16, 32),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // --- Hero Card ---
              _HeroCard(
                sheep: sheep,
                statusColor: statusColor,
                isHealthy: isHealthy,
              ),

              const SizedBox(height: 16),

              // --- Quick Info ---
              _InfoGrid(sheep: sheep),

              const SizedBox(height: 24),

              // --- Section label ---
              const Text(
                'PILIH TINDAKAN',
                style: TextStyle(
                  color: Colors.black45,
                  fontSize: 11,
                  fontWeight: FontWeight.w700,
                  letterSpacing: 1.5,
                ),
              ),

              const SizedBox(height: 12),

              // --- Action Cards ---
              _buildActionCard(
                icon: Icons.info_outline_rounded,
                color: const Color(0xFF2D9CDB),
                title: 'Detail Domba',
                subtitle: 'Lihat informasi lengkap domba ini',
                onTap: () async {
                  await Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => SheepDetailScreen(id: sheep.id),
                    ),
                  );
                  _fetchSheep();
                },
              ),

              const SizedBox(height: 10),

              _buildActionCard(
                icon: Icons.monitor_weight_outlined,
                color: const Color(0xFF27AE60),
                title: 'Riwayat Berat Badan',
                subtitle: 'Pantau & catat perkembangan berat badan',
                onTap: () async {
                  await Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => WeightRecordScreen(
                        sheepId: sheep.id,
                        earTag: sheep.earTag,
                        gender: sheep.gender,
                      ),
                    ),
                  );
                  _fetchSheep();
                },
              ),

              const SizedBox(height: 10),

              _buildActionCard(
                icon: Icons.medical_services_outlined,
                color: const Color(0xFFEB5757),
                title: 'Riwayat Kesehatan',
                subtitle: 'Lihat & tambah catatan kondisi kesehatan',
                onTap: () async {
                  await Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => HealthRecordScreen(
                        sheepId: sheep.id,
                        earTag: sheep.earTag,
                        gender: sheep.gender,
                      ),
                    ),
                  );
                  _fetchSheep();
                },
              ),

              const SizedBox(height: 10),

              _buildActionCard(
                icon: Icons.edit_outlined,
                color: const Color(0xFFF2994A),
                title: 'Edit Domba',
                subtitle: 'Ubah data dan informasi domba',
                onTap: () => _openEditSheet(context, sheep),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildActionCard({
    required IconData icon,
    required Color color,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(16),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            child: Row(
              children: [
                Container(
                  width: 44,
                  height: 44,
                  decoration: BoxDecoration(
                    color: color,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(icon, color: Colors.white, size: 22),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: const TextStyle(
                          color: Colors.black87,
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        subtitle,
                        style: const TextStyle(
                          color: Colors.black45,
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                ),
                const Icon(
                  Icons.chevron_right_rounded,
                  color: Colors.black26,
                  size: 22,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _openEditSheet(BuildContext context, SheepDetail sheep) async {
    final updated = await Navigator.push<bool>(
      context,
      MaterialPageRoute(builder: (_) => EditSheepScreen(sheep: sheep)),
    );
    if (updated == true) {
      _fetchSheep();
    }
  }
}

// ──────────────────────────────────────────────
// Sub-widgets
// ──────────────────────────────────────────────

class _HeroCard extends StatelessWidget {
  final SheepDetail sheep;
  final Color statusColor;
  final bool isHealthy;

  const _HeroCard({
    required this.sheep,
    required this.statusColor,
    required this.isHealthy,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
        border: Border.all(
          color: Colors.black.withValues(alpha: 0.05),
          width: 0.8,
        ),
      ),
      child: Row(
        children: [
          Container(
            width: 60,
            height: 60,
            decoration: BoxDecoration(
              color: statusColor,
              shape: BoxShape.circle,
            ),
            child: Icon(
              isHealthy
                  ? Icons.check_circle_outline_rounded
                  : Icons.warning_amber_rounded,
              color: Colors.white,
              size: 30,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  sheep.earTag,
                  style: const TextStyle(
                    color: Colors.black87,
                    fontSize: 22,
                    fontWeight: FontWeight.w800,
                    letterSpacing: 0.5,
                  ),
                ),
                const SizedBox(height: 4),
                Row(
                  children: [
                    _GenderChip(gender: sheep.gender),
                    const SizedBox(width: 8),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 3,
                      ),
                      decoration: BoxDecoration(
                        color: statusColor,
                        borderRadius: BorderRadius.circular(100),
                      ),
                      child: Text(
                        SheepStatusUtil.healthConditionStatus(
                          sheep.healthCondition,
                        ),
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 11,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                '${sheep.weight.toStringAsFixed(1)} kg',
                style: const TextStyle(
                  color: Colors.black87,
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                ),
              ),
              const Text(
                'Berat terkini',
                style: TextStyle(color: Colors.black45, fontSize: 11),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _InfoGrid extends StatelessWidget {
  final SheepDetail sheep;

  const _InfoGrid({required this.sheep});

  @override
  Widget build(BuildContext context) {
    final items = [
      ('Breed', sheep.breed ?? '-', Icons.pets_rounded),
      ('Kandang', sheep.cage ?? '-', Icons.home_rounded),
      ('Umur', FormatHelper.formatAge(sheep.birthDate), Icons.cake_rounded),
      ('Status', _statusLabel(sheep.status), Icons.toggle_on_rounded),
    ];

    return GridView.count(
      crossAxisCount: 2,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      mainAxisSpacing: 10,
      crossAxisSpacing: 10,
      childAspectRatio: 2.2,
      children: items.map((e) {
        return Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.02),
                blurRadius: 6,
                offset: const Offset(0, 2),
              ),
            ],
            border: Border.all(
              color: Colors.black.withValues(alpha: 0.04),
              width: 0.7,
            ),
          ),
          child: Row(
            children: [
              Icon(e.$3, color: Colors.black38, size: 16),
              const SizedBox(width: 8),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      e.$1,
                      style: const TextStyle(
                        color: Colors.black45,
                        fontSize: 10,
                      ),
                    ),
                    Text(
                      e.$2,
                      style: const TextStyle(
                        color: Colors.black87,
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      }).toList(),
    );
  }

  String _statusLabel(String status) {
    return switch (status.toLowerCase()) {
      'active' => 'Aktif',
      'sold' => 'Dijual',
      'dead' => 'Mati',
      _ => status,
    };
  }
}

class _GenderChip extends StatelessWidget {
  final String gender;

  const _GenderChip({required this.gender});

  @override
  Widget build(BuildContext context) {
    final isMale = gender.toLowerCase() == 'male';
    final chipColor = isMale ? Colors.blue : Colors.pink;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: chipColor,
        borderRadius: BorderRadius.circular(100),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            isMale ? Icons.male_rounded : Icons.female_rounded,
            color: Colors.white,
            size: 13,
          ),
          const SizedBox(width: 3),
          Text(
            isMale ? 'Jantan' : 'Betina',
            style: const TextStyle(
              color: Colors.white,
              fontSize: 11,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}

class _ActionButton extends StatelessWidget {
  final String label;
  final IconData icon;
  final VoidCallback onTap;
  final bool outline;

  const _ActionButton({
    required this.label,
    required this.icon,
    required this.onTap,
    this.outline = false,
  });

  @override
  Widget build(BuildContext context) {
    final primary = Theme.of(context).colorScheme.primary;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 12),
        decoration: BoxDecoration(
          color: outline ? Colors.transparent : primary,
          borderRadius: BorderRadius.circular(12),
          border: outline
              ? Border.all(color: Colors.grey.shade400, width: 0.8)
              : null,
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              color: outline ? Colors.black87 : Colors.white,
              size: 16,
            ),
            const SizedBox(width: 8),
            Text(
              label,
              style: TextStyle(
                color: outline ? Colors.black87 : Colors.white,
                fontSize: 13,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
