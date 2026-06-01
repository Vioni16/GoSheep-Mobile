import 'package:flutter/foundation.dart';
import 'package:gosheep_mobile/data/models/sheep_health_overview.dart';
import 'package:gosheep_mobile/data/services/health_record_service.dart';

class HealthProvider with ChangeNotifier {
  final HealthRecordService _service = HealthRecordService();

  List<SheepHealthOverview> _healths = [];
  List<SheepHealthOverview> get healths => _healths;

  String _message = '';
  String get message => _message;

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

  Future<void> fetchInitial({bool forceRefresh = false}) async {
    if (_isInitialized && !forceRefresh) return;

    _isInitialized = true;

    _healths = [];
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
      final response = await _service.getSheepHealth(
        lastId: _lastId,
        limit: _limit,
        search: _search,
      );

      _healths.addAll(response.data);
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

  Future<void> search(String value) async {
    _search = value;

    _healths = [];
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
