import 'package:flutter/material.dart';
import 'package:gosheep_mobile/data/models/inactive_sheep.dart';
import 'package:gosheep_mobile/data/models/statistics/inactive_sheep_stats.dart';
import '../services/inactive_sheep_service.dart';

class InactiveSheepProvider with ChangeNotifier {
  final InactiveSheepService _service = InactiveSheepService();

  List<InactiveSheep> _inactiveSheepList = [];
  List<InactiveSheep> get inactiveSheepList => _inactiveSheepList;

  bool _isInitialized = false;

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  bool _hasMore = true;
  bool get hasMore => _hasMore;

  int? _lastId;
  final int _limit = 10;

  String _search = '';
  bool get isSearching => _search.isNotEmpty;

  String? _error;
  String? get error => _error;

  InactiveSheepStats? _stats;
  InactiveSheepStats? get stats => _stats;

  int get soldCount => _stats?.soldTotal ?? 0;
  int get deadCount => _stats?.deadTotal ?? 0;
  int get inactiveCount => _stats?.inactiveTotal ?? 0;

  Future<void> fetchInitial({bool forceRefresh = false}) async {
    if (_isInitialized && !forceRefresh) return;

    _isInitialized = true;

    _inactiveSheepList = [];
    _lastId = null;
    _hasMore = true;
    _error = null;
    _isLoading = false;

    await Future.wait([
      fetchStats(),
      fetchMore(),
    ]);
  }

  Future<void> fetchStats() async {
    try {
      _stats = await _service.getInactiveSheepStats();
    } catch (e) {
      // ignore
    }
    notifyListeners();
  }

  Future<void> fetchMore() async {
    if (_isLoading || !_hasMore) return;

    _isLoading = true;
    notifyListeners();

    try {
      final response = await _service.getInactiveSheep(
        lastId: _lastId,
        limit: _limit,
        search: _search,
      );

      _inactiveSheepList.addAll(response.data);
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

  Future<void> searchInactiveSheep(String value) async {
    _search = value;

    _inactiveSheepList = [];
    _lastId = null;
    _hasMore = true;
    _error = null;

    notifyListeners();

    await fetchMore();
  }

  Future<void> refresh() async {
    await fetchInitial(forceRefresh: true);
  }
}
