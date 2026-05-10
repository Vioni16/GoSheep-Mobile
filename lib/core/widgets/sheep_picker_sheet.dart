import 'dart:async';

import 'package:flutter/material.dart';
import 'package:gosheep_mobile/core/widgets/async_state_sliver.dart';
import 'package:gosheep_mobile/core/widgets/sheep_chip.dart';
import 'package:gosheep_mobile/data/models/sheep_option.dart';
import 'package:gosheep_mobile/data/providers/sheep_form_option_provider.dart';
import 'package:gosheep_mobile/core/widgets/sheep_picker_field.dart';
import 'package:provider/provider.dart';

class SheepPickerSheet extends StatefulWidget {
  final String title;
  final SheepPickerType type;
  final SheepOption? initialValue;

  final void Function(SheepOption) onSelected;

  const SheepPickerSheet({
    super.key,
    required this.title,
    required this.type,
    this.initialValue,
    required this.onSelected,
  });

  @override
  State<SheepPickerSheet> createState() => _SheepPickerSheetState();
}

class _SheepPickerSheetState extends State<SheepPickerSheet> {
  final _searchController = TextEditingController();

  Timer? _debounce;

  bool _isLoadMoreLoading = false;

  bool get _isSire => widget.type == SheepPickerType.sire;

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      final provider = context.read<SheepFormOptionProvider>();

      if (_isSire) {
        await provider.loadInitialSires();
      } else {
        await provider.loadInitialDams();
      }
    });
  }

  Future<void> _loadMore() async {
    final provider = context.read<SheepFormOptionProvider>();

    setState(() {
      _isLoadMoreLoading = true;
    });

    if (_isSire) {
      await provider.loadMoreSires();
    } else {
      await provider.loadMoreDams();
    }

    if (!mounted) return;

    setState(() {
      _isLoadMoreLoading = false;
    });
  }

  void _onSearchChanged(String value) {
    final provider = context.read<SheepFormOptionProvider>();

    _debounce?.cancel();

    _debounce = Timer(const Duration(milliseconds: 400), () {
      if (_isSire) {
        provider.searchSires(value);
      } else {
        provider.searchDams(value);
      }
    });
  }

  @override
  void dispose() {
    _debounce?.cancel();
    _searchController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<SheepFormOptionProvider>();

    final items = _isSire ? provider.sireOptions : provider.damOptions;

    final isLoading = _isSire
        ? provider.isLoadingSires
        : provider.isLoadingDams;

    final hasMore = _isSire ? provider.sireHasMore : provider.damHasMore;

    final error = provider.error;

    return Container(
      height: MediaQuery.of(context).size.height * 0.75,
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      widget.title,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    GestureDetector(
                      onTap: () => Navigator.pop(context),
                      child: const Icon(Icons.close),
                    ),
                  ],
                ),

                const SizedBox(height: 12),

                TextField(
                  controller: _searchController,
                  onChanged: _onSearchChanged,
                  decoration: InputDecoration(
                    hintText: 'Cari ${widget.title.toLowerCase()}...',
                    prefixIcon: const Icon(Icons.search),
                    filled: true,
                    fillColor: Colors.grey.shade100,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide.none,
                    ),
                  ),
                ),
              ],
            ),
          ),

          Expanded(
            child: AsyncStateSliver<SheepOption>(
              isLoading: isLoading && items.isEmpty,
              error: error,
              data: items,

              onLoading: () => const Center(child: CircularProgressIndicator()),

              onError: (err) => Center(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Text(err, textAlign: TextAlign.center),
                ),
              ),

              onEmpty: () => const Center(child: Text("Tidak ada data")),

              onSuccess: (data) {
                return ListView(
                  padding: const EdgeInsets.all(16),
                  children: [
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: data.map((item) {
                        final isSelected = widget.initialValue?.id == item.id;

                        return SheepChip(
                          label: item.label,
                          backgroundColor: isSelected
                              ? const Color(0xFF8D6E63)
                              : const Color(0xFFFAEEDA),
                          borderColor: const Color(0xFF8D6E63),
                          textColor: isSelected ? Colors.white : Colors.black,
                          onTap: () {
                            widget.onSelected(item);

                            Navigator.pop(context);
                          },
                        );
                      }).toList(),
                    ),

                    const SizedBox(height: 20),

                    if (hasMore)
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: _isLoadMoreLoading ? null : _loadMore,
                          child: _isLoadMoreLoading
                              ? const SizedBox(
                                  height: 18,
                                  width: 18,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2,
                                  ),
                                )
                              : const Text("Load More"),
                        ),
                      ),
                  ],
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
