import 'package:flutter/material.dart';
import 'package:gosheep_mobile/data/models/sheep.dart';
import 'package:gosheep_mobile/data/models/sheep_health_stats.dart';
import '../services/sheep_service.dart';

class SheepProvider with ChangeNotifier {
  final SheepService _service = SheepService();

  SheepHealthStats? _healthStats;
  SheepHealthStats? get healthStats => _healthStats;

  List<Sheep> _sheepList = [];
  List<Sheep> get sheepList => _sheepList;

  String _message = '';
  String get message => _message;

  bool _isInitialized = false;

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  bool _hasMore = true;
  bool get hasMore => _hasMore;

  int? _lastId;
  final int _limit = 10;

  String? _error;
  String? get error => _error;

  String _search = '';
  bool get isSearching => _search.isNotEmpty;

  Future<void> fetchInitial({bool forceRefresh = false}) async {
    if (_isInitialized && !forceRefresh) {
      return;
    }

    _isInitialized = true;

    _sheepList = [];
    _lastId = null;
    _hasMore = true;
    _error = null;
    _isLoading = false;

    await fetchMore();
  }

  Future<void> fetchMore() async {
    if (_isLoading || !_hasMore) {
      return;
    }

    _isLoading = true;
    notifyListeners();

    try {
      final response = await _service.getSheep(
        lastId: _lastId,
        limit: _limit,
        search: _search,
      );

      _sheepList.addAll(response.data);

      _lastId = response.nextCursor;

      _hasMore = response.hasMore;
      _error = null;
    } catch (e) {
      _error = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> searchSheep(String value) async {
    _search = value;

    _sheepList = [];
    _lastId = null;
    _hasMore = true;
    _error = null;

    notifyListeners();

    await fetchMore();
  }

  Future<void> refresh() async {
    await fetchInitial(forceRefresh: true);
  }

  Future<bool> deleteSheep(int sheepId) async {
    try {
      _isLoading = true;
      notifyListeners();

      final deletedIndex = _sheepList.indexWhere(
        (sheep) => sheep.id == sheepId,
      );

      if (deletedIndex == -1) {
        _isLoading = false;
        notifyListeners();

        return false;
      }

      final deletedSheep = _sheepList[deletedIndex];

      _sheepList.removeAt(deletedIndex);

      notifyListeners();

      try {
        final message = await _service.deleteSheep(sheepId);

        _message = message;
        _error = null;
        _isLoading = false;

        notifyListeners();

        return true;
      } catch (e) {
        _sheepList.insert(deletedIndex, deletedSheep);

        _error = e.toString();
        _isLoading = false;

        notifyListeners();

        return false;
      }
    } catch (e) {
      _error = e.toString();
      _isLoading = false;

      notifyListeners();

      return false;
    }
  }
}
