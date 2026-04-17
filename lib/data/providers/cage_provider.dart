import 'package:flutter/material.dart';
import 'package:gosheep_mobile/data/models/cage.dart';
import 'package:gosheep_mobile/data/services/cage_service.dart';

class CageProvider with ChangeNotifier {
  final CageService _service = CageService();

  List<Cage> _cages = [];
  List<Cage> get cages => _cages;

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  String? _error;
  String? get error => _error;

  bool get hasError => _error != null;

  Future<void> fetchCages({bool forceRefresh = false}) async {
    if (_isLoading) return;

    if (!forceRefresh && _cages.isNotEmpty) return;

    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      final result = await _service.getCages();
      _cages = result;
    } catch (e) {
      _error = e.toString();
      _cages = [];
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> refresh() async {
    await fetchCages(forceRefresh: true);
  }
}
