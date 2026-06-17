import 'package:flutter/material.dart';

/// Widget footer untuk infinite scroll pagination.
///
/// Tampilkan di akhir list (`itemCount: data.length + 1`) sebagai item terakhir.
/// Jika [hasMore] true → tampil loading spinner kecil.
/// Jika [hasMore] false → tidak tampil apa-apa (SizedBox.shrink).
class PaginationLoadingFooter extends StatelessWidget {
  final bool hasMore;

  const PaginationLoadingFooter({super.key, required this.hasMore});

  @override
  Widget build(BuildContext context) {
    if (!hasMore) return const SizedBox.shrink();

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 16),
      child: Center(
        child: SizedBox(
          width: 20,
          height: 20,
          child: CircularProgressIndicator(
            strokeWidth: 2,
            color: Theme.of(context).colorScheme.primary,
          ),
        ),
      ),
    );
  }
}
