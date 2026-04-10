import 'package:flutter/material.dart';
import 'package:gosheep_mobile/core/widgets/custom_button.dart';

// ── Model ─────────────────────────────────────────────────────────────────────
class Sheep {
  final String id, nama, jenis, statusKesehatan;
  final double berat;
  const Sheep({
    required this.id,
    required this.nama,
    required this.jenis,
    required this.berat,
    required this.statusKesehatan,
  });
}

// ── Constants ─────────────────────────────────────────────────────────────────
const _jenisList = ['Merino', 'Garut', 'Texel', 'Dorper', 'Suffolk'];

final _initialData = [
  Sheep(
    id: 'D-001',
    nama: 'Shaun',
    jenis: 'Merino',
    berat: 45.5,
    statusKesehatan: 'Sehat',
  ),
  Sheep(
    id: 'D-002',
    nama: 'Mbandot',
    jenis: 'Garut',
    berat: 50.2,
    statusKesehatan: 'Sakit',
  ),
  Sheep(
    id: 'D-003',
    nama: 'Bolly',
    jenis: 'Texel',
    berat: 42.0,
    statusKesehatan: 'Sehat',
  ),
];

// ── Screen ────────────────────────────────────────────────────────────────────
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
    return (_filter == 'all' || s.statusKesehatan.toLowerCase() == _filter) &&
        (q.isEmpty ||
            s.nama.toLowerCase().contains(q) ||
            s.id.toLowerCase().contains(q));
  }).toList();

  double get _maxBerat => _sheep.isEmpty
      ? 1
      : _sheep.map((s) => s.berat).reduce((a, b) => a > b ? a : b);

  void _delete(Sheep s) {
    setState(() => _sheep.remove(s));
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('${s.nama} berhasil dihapus'),
        behavior: SnackBarBehavior.floating,
        backgroundColor: Colors.black87,
      ),
    );
  }

  void _openAdd() => showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    builder: (_) => _AddSheepSheet(
      onAdd: (s) {
        setState(() => _sheep.insert(0, s));
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Data domba berhasil ditambahkan'),
            behavior: SnackBarBehavior.floating,
            backgroundColor: Color(0xFF3B6D11),
          ),
        );
      },
    ),
  );

  @override
  Widget build(BuildContext context) {
    final list = _filtered;
    final sehat = _sheep.where((s) => s.statusKesehatan == 'Sehat').length;

    return Scaffold(
      backgroundColor: const Color(0xFFF5F4F0),
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ── AppBar
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
            // ── Body
            Expanded(
              child: ListView(
                padding: const EdgeInsets.fromLTRB(16, 16, 16, 24),
                children: [
                  // Stats
                  Row(
                    children: [
                      _StatCard(label: 'Total', value: '${_sheep.length}'),
                      const SizedBox(width: 10),
                      _StatCard(
                        label: 'Sehat',
                        value: '$sehat',
                        valueColor: const Color(0xFF3B6D11),
                      ),
                      const SizedBox(width: 10),
                      _StatCard(
                        label: 'Sakit',
                        value: '${_sheep.length - sehat}',
                        valueColor: const Color(0xFFA32D2D),
                      ),
                    ],
                  ),
                  const SizedBox(height: 14),
                  // Search
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: Colors.black.withOpacity(0.05)),
                    ),
                    child: Row(
                      children: [
                        Icon(
                          Icons.search_rounded,
                          size: 18,
                          color: Colors.black.withOpacity(0.4),
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
                                color: Colors.black.withOpacity(0.3),
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
                              color: Colors.black.withOpacity(0.4),
                            ),
                          ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 10),
                  // Filter
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: [
                        for (final f in [
                          ('Semua', 'all'),
                          ('Sehat', 'sehat'),
                          ('Sakit', 'sakit'),
                        ]) ...[
                          _FilterPill(
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
                      color: Colors.black.withOpacity(0.4),
                      letterSpacing: 1.2,
                    ),
                  ),
                  const SizedBox(height: 12),
                  // List or empty state
                  if (list.isEmpty)
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 40),
                      child: Center(
                        child: Column(
                          children: [
                            Icon(
                              Icons.search_off_rounded,
                              size: 48,
                              color: Colors.black.withOpacity(0.2),
                            ),
                            const SizedBox(height: 12),
                            Text(
                              'Tidak ada domba ditemukan',
                              style: TextStyle(
                                color: Colors.black.withOpacity(0.5),
                                fontSize: 14,
                              ),
                            ),
                          ],
                        ),
                      ),
                    )
                  else
                    ...list.map(
                      (s) => _SheepCard(
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

// ── Sheep Card ────────────────────────────────────────────────────────────────
class _SheepCard extends StatelessWidget {
  final Sheep sheep;
  final double maxBerat;
  final VoidCallback onDelete;
  const _SheepCard({
    super.key,
    required this.sheep,
    required this.maxBerat,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    final isSehat = sheep.statusKesehatan == 'Sehat';
    final bg = isSehat ? const Color(0xFFEAF3DE) : const Color(0xFFFCEBEB);
    final fg = isSehat ? const Color(0xFF3B6D11) : const Color(0xFFA32D2D);
    final bar = isSehat ? const Color(0xFF639922) : const Color(0xFFE24B4A);
    final border = isSehat ? const Color(0xFFC0DD97) : const Color(0xFFF7C1C1);
    final progress = (sheep.berat / maxBerat).clamp(0.0, 1.0);

    return Dismissible(
      key: ValueKey(sheep.id),
      direction: DismissDirection.endToStart,
      onDismissed: (_) => onDelete(),
      background: Container(
        margin: const EdgeInsets.only(bottom: 10),
        decoration: BoxDecoration(
          color: const Color(0xFFE24B4A),
          borderRadius: BorderRadius.circular(14),
        ),
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.only(right: 20),
        child: const Icon(Icons.delete_outline_rounded, color: Colors.white),
      ),
      child: Container(
        margin: const EdgeInsets.only(bottom: 10),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: Colors.black.withOpacity(0.05)),
        ),
        child: Material(
          color: Colors.transparent,
          borderRadius: BorderRadius.circular(14),
          child: InkWell(
            borderRadius: BorderRadius.circular(14),
            onTap: () {},
            child: Padding(
              padding: const EdgeInsets.all(14),
              child: Row(
                children: [
                  Container(
                    width: 48,
                    height: 48,
                    decoration: BoxDecoration(
                      color: bg,
                      shape: BoxShape.circle,
                    ),
                    child: Icon(Icons.pets_rounded, color: fg, size: 24),
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Text(
                              sheep.nama,
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            const SizedBox(width: 6),
                            Text(
                              '• ${sheep.id}',
                              style: const TextStyle(
                                fontSize: 12,
                                color: Colors.black45,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 4),
                        Text(
                          '${sheep.jenis}  ·  ${sheep.berat} kg',
                          style: const TextStyle(
                            fontSize: 13,
                            color: Colors.black54,
                          ),
                        ),
                        const SizedBox(height: 8),
                        ClipRRect(
                          borderRadius: BorderRadius.circular(4),
                          child: LinearProgressIndicator(
                            value: progress,
                            backgroundColor: Colors.black.withOpacity(0.04),
                            valueColor: AlwaysStoppedAnimation(bar),
                            minHeight: 4,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 12),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      color: bg,
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(color: border),
                    ),
                    child: Text(
                      sheep.statusKesehatan,
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: fg,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

// ── Add Sheet ─────────────────────────────────────────────────────────────────
class _AddSheepSheet extends StatefulWidget {
  final void Function(Sheep) onAdd;
  const _AddSheepSheet({required this.onAdd});
  @override
  State<_AddSheepSheet> createState() => _AddSheepSheetState();
}

class _AddSheepSheetState extends State<_AddSheepSheet> {
  final _formKey = GlobalKey<FormState>();
  final _nama = TextEditingController();
  final _id = TextEditingController();
  final _berat = TextEditingController();
  String? _jenis;
  String _status = 'Sehat';

  @override
  void dispose() {
    _nama.dispose();
    _id.dispose();
    _berat.dispose();
    super.dispose();
  }

  void _submit() {
    if (!_formKey.currentState!.validate()) return;
    widget.onAdd(
      Sheep(
        id: _id.text.trim(),
        nama: _nama.text.trim(),
        jenis: _jenis!,
        berat: double.parse(_berat.text.trim()),
        statusKesehatan: _status,
      ),
    );
    Navigator.pop(context);
  }

  OutlineInputBorder _border([Color? color, double width = 1]) =>
      OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(
          color: color ?? Colors.black.withOpacity(0.1),
          width: width,
        ),
      );

  @override
  Widget build(BuildContext context) {
    final bottom = MediaQuery.of(context).viewInsets.bottom;
    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      padding: EdgeInsets.fromLTRB(20, 16, 20, 20 + bottom),
      child: Form(
        key: _formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Handle + header
            Center(
              child: Container(
                width: 40,
                height: 4,
                margin: const EdgeInsets.only(bottom: 16),
                decoration: BoxDecoration(
                  color: Colors.black.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),
            Row(
              children: [
                const Expanded(
                  child: Text(
                    'Tambah Domba Baru',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700),
                  ),
                ),
                GestureDetector(
                  onTap: () => Navigator.pop(context),
                  child: Container(
                    padding: const EdgeInsets.all(6),
                    decoration: BoxDecoration(
                      color: Colors.black.withOpacity(0.05),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.close_rounded,
                      size: 18,
                      color: Colors.black54,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            // Fields
            _SheetField(
              label: 'Nama Domba',
              controller: _nama,
              hint: 'Contoh: Shaun',
              icon: Icons.badge_outlined,
              validator: (v) => (v?.isEmpty ?? true) ? 'Wajib diisi' : null,
            ),
            const SizedBox(height: 14),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: _SheetField(
                    label: 'ID Domba',
                    controller: _id,
                    hint: 'D-004',
                    icon: Icons.tag_rounded,
                    validator: (v) =>
                        (v?.isEmpty ?? true) ? 'Wajib diisi' : null,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _SheetField(
                    label: 'Berat (kg)',
                    controller: _berat,
                    hint: '45.0',
                    icon: Icons.scale_rounded,
                    keyboardType: const TextInputType.numberWithOptions(
                      decimal: true,
                    ),
                    validator: (v) => (v?.isEmpty ?? true)
                        ? 'Wajib diisi'
                        : double.tryParse(v!) == null
                        ? 'Angka tidak valid'
                        : null,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 14),
            // Jenis dropdown
            const Text(
              'Jenis Domba',
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w500,
                color: Colors.black87,
              ),
            ),
            const SizedBox(height: 8),
            DropdownButtonFormField<String>(
              value: _jenis,
              hint: const Text(
                'Pilih jenis...',
                style: TextStyle(fontSize: 14),
              ),
              icon: const Icon(
                Icons.keyboard_arrow_down_rounded,
                color: Colors.black54,
              ),
              items: _jenisList
                  .map(
                    (j) => DropdownMenuItem(
                      value: j,
                      child: Text(j, style: const TextStyle(fontSize: 14)),
                    ),
                  )
                  .toList(),
              onChanged: (v) => setState(() => _jenis = v),
              validator: (v) => v == null ? 'Pilih jenis domba' : null,
              decoration: InputDecoration(
                prefixIcon: Icon(
                  Icons.category_outlined,
                  size: 20,
                  color: Colors.black.withOpacity(0.4),
                ),
                isDense: true,
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 12,
                ),
                border: _border(),
                enabledBorder: _border(),
                focusedBorder: _border(Colors.black, 1.5),
              ),
            ),
            const SizedBox(height: 14),
            // Status toggle
            const Text(
              'Status Kesehatan',
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w500,
                color: Colors.black87,
              ),
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                Expanded(
                  child: _StatusToggle(
                    label: 'Sehat',
                    selected: _status == 'Sehat',
                    bg: const Color(0xFFEAF3DE),
                    border: const Color(0xFFC0DD97),
                    text: const Color(0xFF3B6D11),
                    onTap: () => setState(() => _status = 'Sehat'),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _StatusToggle(
                    label: 'Sakit',
                    selected: _status == 'Sakit',
                    bg: const Color(0xFFFCEBEB),
                    border: const Color(0xFFF7C1C1),
                    text: const Color(0xFFA32D2D),
                    onTap: () => setState(() => _status = 'Sakit'),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),
            CustomButton(text: 'Simpan Data Domba', onPressed: _submit),
          ],
        ),
      ),
    );
  }
}

// ── Helper Widgets ────────────────────────────────────────────────────────────
class _StatCard extends StatelessWidget {
  final String label, value;
  final Color? valueColor;
  const _StatCard({required this.label, required this.value, this.valueColor});

  @override
  Widget build(BuildContext context) => Expanded(
    child: Container(
      padding: const EdgeInsets.symmetric(vertical: 14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.black.withOpacity(0.04)),
      ),
      child: Column(
        children: [
          Text(
            value,
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.w700,
              color: valueColor ?? Colors.black87,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: const TextStyle(
              fontSize: 12,
              color: Colors.black54,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    ),
  );
}

class _FilterPill extends StatelessWidget {
  final String label;
  final bool active;
  final VoidCallback onTap;
  const _FilterPill({
    required this.label,
    required this.active,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) => GestureDetector(
    onTap: onTap,
    child: AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: active ? Colors.black : Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: active ? Colors.black : Colors.black.withOpacity(0.1),
        ),
      ),
      child: Text(
        label,
        style: TextStyle(
          fontSize: 13,
          fontWeight: active ? FontWeight.w600 : FontWeight.w500,
          color: active ? Colors.white : Colors.black54,
        ),
      ),
    ),
  );
}

class _SheetField extends StatelessWidget {
  final String label, hint;
  final IconData icon;
  final TextEditingController controller;
  final TextInputType? keyboardType;
  final String? Function(String?)? validator;
  const _SheetField({
    required this.label,
    required this.hint,
    required this.icon,
    required this.controller,
    this.keyboardType,
    this.validator,
  });

  @override
  Widget build(BuildContext context) => Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text(
        label,
        style: const TextStyle(
          fontSize: 13,
          fontWeight: FontWeight.w500,
          color: Colors.black87,
        ),
      ),
      const SizedBox(height: 8),
      TextFormField(
        controller: controller,
        keyboardType: keyboardType,
        validator: validator,
        style: const TextStyle(fontSize: 14),
        decoration: InputDecoration(
          prefixIcon: Icon(
            icon,
            size: 20,
            color: Colors.black.withOpacity(0.4),
          ),
          hintText: hint,
          hintStyle: const TextStyle(color: Colors.black26, fontSize: 14),
          isDense: true,
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 12,
            vertical: 12,
          ),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(color: Colors.black.withOpacity(0.1)),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(color: Colors.black.withOpacity(0.1)),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: Colors.black, width: 1.5),
          ),
          errorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: Colors.red),
          ),
        ),
      ),
    ],
  );
}

class _StatusToggle extends StatelessWidget {
  final String label;
  final bool selected;
  final Color bg, border, text;
  final VoidCallback onTap;
  const _StatusToggle({
    required this.label,
    required this.selected,
    required this.bg,
    required this.border,
    required this.text,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) => GestureDetector(
    onTap: onTap,
    child: AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      padding: const EdgeInsets.symmetric(vertical: 12),
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: selected ? bg : Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: selected ? border : Colors.black.withOpacity(0.08),
          width: selected ? 1.5 : 1,
        ),
      ),
      child: Text(
        label,
        style: TextStyle(
          fontSize: 14,
          fontWeight: selected ? FontWeight.w600 : FontWeight.w500,
          color: selected ? text : Colors.black54,
        ),
      ),
    ),
  );
}
