import 'package:flutter/material.dart';
import 'package:gosheep_mobile/data/models/pregnancy.dart';
import 'package:gosheep_mobile/data/models/statistics/pregnancy_stats.dart';
import 'package:gosheep_mobile/data/services/pregnant_sheep_service.dart';

class PregnantSheepProvider with ChangeNotifier {
  final PregnantSheepService _service = PregnantSheepService();

  List<Pregnancy> _pregnancies = [];
  List<Pregnancy> get pregnancies => _pregnancies;

  PregnancyStats? _stats;
  PregnancyStats? get stats => _stats;

  final String _message = '';
  String get message => _message;

  bool _isInitialized = false;

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  bool _isStatsLoading = false;
  bool get isStatsLoading => _isStatsLoading;

  bool _hasMore = true;
  bool get hasMore => _hasMore;

  int? _lastId;
  final int _limit = 10;

  String _search = '';
  bool get isSearching => _search.isNotEmpty;

  String? _error;
  String? get error => _error;

  Future<void> fetchInitial({bool forceRefresh = false}) async {
    if (_isInitialized && !forceRefresh) return;

    _isInitialized = true;

    _pregnancies = [];
    _lastId = null;
    _hasMore = true;
    _error = null;
    _isLoading = false;

    await fetchMore();
  }

  Future<void> fetchMore() async {
    if (_isLoading || !_hasMore) return;

    _isLoading = true;
    notifyListeners();

    try {
      final response = await _service.getPregnancies(
        lastId: _lastId,
        limit: _limit,
        search: _search,
      );

      _pregnancies.addAll(response.data);
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

  Future<void> fetchSummary() async {
    if (_isStatsLoading) return;

    _isStatsLoading = true;
    notifyListeners();

    try {
      _stats = await _service.getSummary();
      _error = null;
    } catch (e) {
      _error = e.toString();
    } finally {
      _isStatsLoading = false;
      notifyListeners();
    }
  }

  Future<void> searchPregnancies(String value) async {
    _search = value;

    _pregnancies = [];
    _lastId = null;
    _hasMore = true;

    _error = null;

    notifyListeners();

    await fetchMore();
  }

  Future<void> refresh() async {
    await Future.wait([
      fetchInitial(forceRefresh: true),
      fetchSummary(),
    ]);
  }
}
