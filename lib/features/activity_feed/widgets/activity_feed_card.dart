import 'package:flutter/material.dart';
import 'package:gosheep_mobile/core/enums/mating_result_enum.dart';
import 'package:gosheep_mobile/core/extensions/string_extension.dart';
import 'package:gosheep_mobile/core/utils/format_helper.dart';
import 'package:gosheep_mobile/core/utils/sheep_status_util.dart';
import 'package:gosheep_mobile/data/models/activity_feed.dart';

class ActivityFeedCard extends StatelessWidget {
  final ActivityFeed activity;
  final VoidCallback? onTap;

  const ActivityFeedCard({super.key, required this.activity, this.onTap});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 14),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _Avatar(activity: activity),
          const SizedBox(width: 10),
          Expanded(
            child: _ContentCard(activity: activity, onTap: onTap),
          ),
        ],
      ),
    );
  }
}

class _Avatar extends StatelessWidget {
  final ActivityFeed activity;
  const _Avatar({required this.activity});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 34,
      height: 34,
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
    );
  }
}

class _ContentCard extends StatelessWidget {
  final ActivityFeed activity;
  final VoidCallback? onTap;

  const _ContentCard({required this.activity, this.onTap});

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.white,
      borderRadius: BorderRadius.circular(10),
      child: InkWell(
        onTap: activity.canNavigate ? onTap : null,
        borderRadius: BorderRadius.circular(10),
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color: Colors.grey.shade100),
          ),
          padding: const EdgeInsets.all(12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _CardHeader(activity: activity),
              const SizedBox(height: 4),
              Text(
                activity.description,
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.grey.shade600,
                  height: 1.4,
                ),
              ),
              const SizedBox(height: 8),
              _PropertiesBlock(activity: activity),
              const SizedBox(height: 8),
              _EntityBadge(activity: activity),
            ],
          ),
        ),
      ),
    );
  }
}

class _CardHeader extends StatelessWidget {
  final ActivityFeed activity;
  const _CardHeader({required this.activity});

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: RichText(
            text: TextSpan(
              style: const TextStyle(fontSize: 12),
              children: [
                TextSpan(
                  text: activity.user?.name ?? 'Unknown',
                  style: const TextStyle(
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF2D3132),
                  ),
                ),
                TextSpan(
                  text:
                      ' · ${activity.actionLabel.capitalizeFirst} ${_entityLabel(activity.entity)}',
                  style: TextStyle(
                    fontWeight: FontWeight.w400,
                    color: Colors.grey.shade500,
                  ),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(width: 8),
        Text(
          FormatHelper.formatTime(activity.createdAt),
          style: TextStyle(fontSize: 10, color: Colors.grey.shade400),
        ),
      ],
    );
  }

  String _entityLabel(String entity) => switch (entity) {
    'sheep' => 'domba',
    'health_record' => 'rekam kesehatan',
    'weight_record' => 'berat badan',
    'breeding' => 'perkawinan',
    'mating_check' => 'pemeriksaan perkawinan',
    _ => entity,
  };
}

class _PropertiesBlock extends StatelessWidget {
  final ActivityFeed activity;
  const _PropertiesBlock({required this.activity});

  @override
  Widget build(BuildContext context) {
    final props = activity.properties;
    if (props == null) return const SizedBox.shrink();

    final rows = switch (props) {
      CreatedProperties p => _createdRows(p),
      UpdatedProperties p => _updatedRows(p),
      DeletedProperties p => _deletedRows(p),
    };

    if (rows.isEmpty) return const SizedBox.shrink();

    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: const Color(0xFFF5F4F0),
        borderRadius: BorderRadius.circular(6),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
      child: Column(
        children: [
          for (int i = 0; i < rows.length; i++) ...[
            rows[i],
            if (i < rows.length - 1)
              Divider(height: 10, color: Colors.grey.shade200),
          ],
        ],
      ),
    );
  }

  static const Map<String, String> _createdLabels = {
    'weight': 'Berat (Kg)',
    'breed': 'Ras',
    'gender': 'Jenis kelamin',
    'cage': 'Kandang',
    'condition': 'Kondisi',
    'severity': 'Tingkat',
    'category': 'Kategori',
    'sheep_eartag': 'Eartag',
    'result': 'Hasil',
    'check_date': 'Tanggal Pemeriksaan',
  };

  static const Map<String, String> _deletedLabels = {
    'breed': 'Ras',
    'gender': 'Jenis kelamin',
    'cage': 'Kandang',
    'eartag': 'Eartag',
    'condition': 'Kondisi',
    'category': 'Kategori',
    'severity': 'Tingkat',
    'notes': 'Catatan',
  };

  List<Widget> _createdRows(CreatedProperties p) {
    return p.data.entries
        .where((e) => e.value != null && _createdLabels.containsKey(e.key))
        .map(
          (e) => _KVRow(
            label: _createdLabels[e.key]!,
            value: _transformValue(e.key, e.value.toString()),
          ),
        )
        .toList();
  }

  List<Widget> _updatedRows(UpdatedProperties p) {
    return p.next.entries
        .where((e) => p.old[e.key]?.toString() != e.value?.toString())
        .map(
          (e) => _KVChangeRow(
            label: UpdatedProperties.label(e.key),
            from: _transformValue(e.key, p.old[e.key]?.toString() ?? '-'),
            to: _transformValue(e.key, e.value?.toString() ?? '-'),
          ),
        )
        .toList();
  }

  List<Widget> _deletedRows(DeletedProperties p) {
    return p.snapshot.entries
        .where((e) => e.value != null && _deletedLabels.containsKey(e.key))
        .map(
          (e) => _KVRow(
            label: _deletedLabels[e.key]!,
            value: _transformValue(e.key, e.value.toString()),
          ),
        )
        .toList();
  }

  String _transformValue(String key, String value) {
    return switch (key) {
      'gender' => SheepStatusUtil.getGenderLabel(value),
      'severity' => value.capitalizeFirst,
      'category' => SheepStatusUtil.healthCategoryLabel(value),
      'result' => MatingResult.fromString(value).label,
      'check_date' => FormatHelper.formatDate(DateTime.parse(value)),
      _ => value,
    };
  }
}

class _KVRow extends StatelessWidget {
  final String label;
  final String value;
  const _KVRow({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          width: 80,
          child: Text(
            label,
            style: const TextStyle(fontSize: 11, color: Colors.black38),
          ),
        ),
        Expanded(
          child: Text(
            value,
            style: const TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w600,
              color: Color(0xFF2D3132),
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }
}

class _KVChangeRow extends StatelessWidget {
  final String label;
  final String from;
  final String to;
  const _KVChangeRow({
    required this.label,
    required this.from,
    required this.to,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        SizedBox(
          width: 80,
          child: Text(
            label,
            style: const TextStyle(fontSize: 11, color: Colors.black38),
          ),
        ),
        Expanded(
          child: Row(
            children: [
              Flexible(
                child: Text(
                  from,
                  style: const TextStyle(
                    fontSize: 11,
                    color: Colors.black38,
                    decoration: TextDecoration.lineThrough,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 5),
                child: Icon(
                  Icons.arrow_forward_rounded,
                  size: 11,
                  color: Colors.black26,
                ),
              ),
              Flexible(
                child: Text(
                  to,
                  style: const TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF2D3132),
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _EntityBadge extends StatelessWidget {
  final ActivityFeed activity;
  const _EntityBadge({required this.activity});

  String get _label => switch (activity.entity) {
    'sheep' => 'Domba',
    'health_record' => 'Rekam kesehatan',
    'weight_record' => 'Berat badan',
    'breeding' => 'Perkawinan',
    'mating_check' => 'Pemeriksaan perkawinan',
    _ => activity.entity,
  };

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: activity.avatarColor,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        _label,
        style: const TextStyle(
          fontSize: 10,
          color: Colors.white,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }
}
