import 'package:flutter/material.dart';

class BreedingSearchBar extends StatefulWidget {
  final TextEditingController controller;
  final VoidCallback onSearch;
  final bool isLoading; // 1. Tambahkan parameter untuk status loading

  const BreedingSearchBar({
    super.key,
    required this.controller,
    required this.onSearch,
    this.isLoading = false, // Default-nya false agar tidak langsung loading
  });

  @override
  State<BreedingSearchBar> createState() => _BreedingSearchBarState();
}

class _BreedingSearchBarState extends State<BreedingSearchBar> {
  bool _hasText = false;

  @override
  void initState() {
    super.initState();
    widget.controller.addListener(_onTextChanged);
  }

  void _onTextChanged() {
    final hasText = widget.controller.text.isNotEmpty;
    if (hasText != _hasText) {
      setState(() => _hasText = hasText);
    }
  }

  @override
  void dispose() {
    widget.controller.removeListener(_onTextChanged);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: widget.controller,
      textCapitalization: TextCapitalization.characters,
      // 2. Mencegah submit berulang ketika sedang loading
      onSubmitted: (_) {
        if (!widget.isLoading) widget.onSearch();
      },
      // 3. (Opsional) Membuat text field read-only saat loading agar user tidak mengetik
      readOnly: widget.isLoading,
      style: const TextStyle(fontSize: 14),
      decoration: InputDecoration(
        hintText: 'Masukkan eartag (e.g. M001)...',
        hintStyle: TextStyle(color: Colors.grey[400], fontSize: 14),
        prefixIcon: const Icon(
          Icons.search_rounded,
          size: 20,
          color: Color(0xFF2E7D32),
        ),
        // 4. Memisahkan logika suffix icon agar lebih rapi
        suffixIcon: _buildSuffixIcon(),
        isDense: true,
        filled: true,
        fillColor: Colors.white,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 12,
          vertical: 14,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.grey.withValues(alpha: 0.2)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Color(0xFF2E7D32), width: 1.5),
        ),
      ),
    );
  }

  // Fungsi khusus untuk mengatur apa yang tampil di sebelah kanan TextField
  Widget? _buildSuffixIcon() {
    if (widget.isLoading) {
      // Tampilkan indikator loading kecil
      return const Padding(
        padding: EdgeInsets.all(12.0),
        child: SizedBox(
          width: 20,
          height: 20,
          child: CircularProgressIndicator(
            strokeWidth: 2.5,
            color: Color(0xFF2E7D32),
          ),
        ),
      );
    } else if (_hasText) {
      // Tampilkan tombol clear jika ada teks dan tidak sedang loading
      return IconButton(
        icon: const Icon(Icons.clear, size: 18),
        color: Colors.grey,
        onPressed: widget.controller.clear,
      );
    }
    // Kosongkan jika tidak ada teks dan tidak loading
    return null;
  }
}
