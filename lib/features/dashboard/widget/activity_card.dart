import 'package:flutter/material.dart';
import 'package:gosheep_mobile/core/utils/format_helper.dart';
import 'package:gosheep_mobile/data/models/activity_feed.dart';
import 'package:gosheep_mobile/data/services/activity_feed_service.dart';
import 'package:gosheep_mobile/features/activity_feed/screens/activity_feed_screen.dart';

class ActivityCard extends StatefulWidget {
  const ActivityCard({super.key});

  @override
  State<ActivityCard> createState() => _ActivityCardState();
}

class _ActivityCardState extends State<ActivityCard> {
  final ActivityFeedService _service = ActivityFeedService();

  List<ActivityFeed> _feeds = [];
  bool _isLoading = true;
  bool _hasError = false;

  @override
  void initState() {
    super.initState();
    _fetchRecentActivities();
  }

  Future<void> _fetchRecentActivities() async {
    setState(() {
      _isLoading = true;
      _hasError = false;
    });

    try {
      final response = await _service.getActivityFeed(limit: 3);
      if (!mounted) return;
      setState(() {
        _feeds = response.data;
        _isLoading = false;
      });
    } catch (_) {
      if (!mounted) return;
      setState(() {
        _hasError = true;
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              'Aktivitas Terkini',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Color.fromARGB(255, 115, 115, 115),
              ),
            ),
            InkWell(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const ActivityFeedScreen()),
                );
              },
              borderRadius: BorderRadius.circular(6),
              child: const Padding(
                padding: EdgeInsets.symmetric(horizontal: 6, vertical: 4),
                child: Text(
                  'Lihat semua',
                  style: TextStyle(color: Color(0xFF0F5132)),
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        _buildContent(),
      ],
    );
  }

  Widget _buildContent() {
    if (_isLoading) {
      return _buildSkeleton();
    }

    if (_hasError) {
      return _buildError();
    }

    if (_feeds.isEmpty) {
      return _buildEmpty();
    }

    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        children: [
          for (int i = 0; i < _feeds.length; i++) ...[
            _ActivityItem(activity: _feeds[i]),
            if (i < _feeds.length - 1)
              Divider(height: 1, color: Colors.grey.shade100),
          ],
        ],
      ),
    );
  }

  Widget _buildSkeleton() {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        children: List.generate(
          3,
          (i) => Padding(
            padding: const EdgeInsets.symmetric(vertical: 10),
            child: Row(
              children: [
                Container(
                  width: 32,
                  height: 32,
                  decoration: BoxDecoration(
                    color: Colors.grey.shade200,
                    shape: BoxShape.circle,
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        width: double.infinity,
                        height: 12,
                        decoration: BoxDecoration(
                          color: Colors.grey.shade200,
                          borderRadius: BorderRadius.circular(6),
                        ),
                      ),
                      const SizedBox(height: 6),
                      Container(
                        width: 100,
                        height: 10,
                        decoration: BoxDecoration(
                          color: Colors.grey.shade100,
                          borderRadius: BorderRadius.circular(6),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildError() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Center(
        child: Column(
          children: [
            Icon(Icons.wifi_off_rounded, size: 28, color: Colors.grey.shade300),
            const SizedBox(height: 8),
            Text(
              'Gagal memuat aktivitas',
              style: TextStyle(fontSize: 12, color: Colors.grey.shade500),
            ),
            const SizedBox(height: 8),
            InkWell(
              onTap: _fetchRecentActivities,
              borderRadius: BorderRadius.circular(6),
              child: const Padding(
                padding: EdgeInsets.symmetric(horizontal: 6, vertical: 4),
                child: Text(
                  'Coba lagi',
                  style: TextStyle(
                    fontSize: 12,
                    color: Color(0xFF0F5132),
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEmpty() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Center(
        child: Text(
          'Belum ada aktivitas',
          style: TextStyle(fontSize: 13, color: Colors.grey.shade400),
        ),
      ),
    );
  }
}

class _ActivityItem extends StatelessWidget {
  final ActivityFeed activity;

  const _ActivityItem({required this.activity});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Row(
        children: [
          Container(
            width: 32,
            height: 32,
            decoration: BoxDecoration(
              color: activity.avatarColor,
              shape: BoxShape.circle,
            ),
            child: Center(
              child: Text(
                activity.userInitials,
                style: const TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.w600,
                  color: Colors.white,
                ),
              ),
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  activity.description,
                  style: const TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w500,
                    color: Color(0xFF2D3132),
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 2),
                Text(
                  '${activity.user?.name ?? 'Unknown'} · ${FormatHelper.timeAgo(activity.createdAt)}',
                  style: TextStyle(fontSize: 11, color: Colors.grey.shade500),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
