import 'package:gosheep_mobile/data/models/sheep.dart';

class SheepResponse {
  final List<Sheep> data;
  final bool hasMore;
  final int? nextCursor;
  final bool success;
  final String message;

  const SheepResponse({
    required this.data,
    required this.hasMore,
    required this.nextCursor,
    required this.success,
    required this.message,
  });

  factory SheepResponse.fromJson(Map<String, dynamic> json) {
    return SheepResponse(
      data: (json['data'] as List).map((e) => Sheep.fromJson(e)).toList(),
      hasMore: json['has_more'] ?? false,
      nextCursor: json['next_cursor'],
      success: json['success'],
      message: json['message'],
    );
  }
}
