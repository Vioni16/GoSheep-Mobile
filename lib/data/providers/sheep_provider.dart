import 'package:flutter/material.dart';
import 'package:gosheep_mobile/data/models/sheep.dart';
import '../services/sheep_service.dart';

class SheepProvider with ChangeNotifier {
  final SheepService _service = SheepService();

  List<Sheep> _sheepList = [];
  List<Sheep> get sheepList => _sheepList;

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  bool _hasMore = true;
  bool get hasMore => _hasMore;

  int _currentPage = 1;

  String? _error;
  String? get error => _error;

  Future<void> fetchInitial() async {
    _sheepList = [];
    _currentPage = 1;
    _hasMore = true;
    _error = null;

    await fetchMore();
  }

  Future<void> fetchMore() async {
    if (_isLoading || !_hasMore) return;

    _isLoading = true;
    notifyListeners();

    try {
      final response = await _service.getSheep(page: _currentPage);

      _sheepList.addAll(response.data);

      _currentPage++;

      if (_currentPage > response.meta.lastPage) {
        _hasMore = false;
      }
    } catch (e) {
      _error = e.toString();
    }

    _isLoading = false;
    notifyListeners();
  }

  Future<void> refresh() async {
    await fetchInitial();
  }
}