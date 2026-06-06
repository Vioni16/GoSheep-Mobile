import 'package:flutter/material.dart';
import 'package:gosheep_mobile/core/utils/format_helper.dart';
import 'package:gosheep_mobile/data/models/activity_feed.dart';
import 'package:gosheep_mobile/data/services/activity_feed_service.dart';

class ActivityFeedProvider with ChangeNotifier {
  final ActivityFeedService _service = ActivityFeedService();

  List<ActivityFeed> _feeds = [];
  List<ActivityFeed> get feeds => _feeds;

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  bool _hasMore = true;
  bool get hasMore => _hasMore;

  int? _lastId;
  final int _limit = 10;

  String? _error;
  String? get error => _error;

  Map<String, List<ActivityFeed>> get groupedFeeds {
    final map = <String, List<ActivityFeed>>{};
    for (final feed in _feeds) {
      final key = _dateKey(feed.createdAt);
      map.putIfAbsent(key, () => []).add(feed);
    }
    return map;
  }

  String _dateKey(DateTime dt) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final yesterday = today.subtract(const Duration(days: 1));
    final date = DateTime(dt.year, dt.month, dt.day);

    if (date == today) return 'Hari ini';
    if (date == yesterday) return 'Kemarin';
    return FormatHelper.formatDate(dt);
  }

  Future<void> fetchInitial() async {
    _feeds = [];
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
      final response = await _service.getActivityFeed(
        lastId: _lastId,
        limit: _limit,
      );

      _feeds.addAll(response.data);
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

  Future<void> refresh() async {
    await fetchInitial();
  }
}
