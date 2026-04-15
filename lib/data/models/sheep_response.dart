import 'package:gosheep_mobile/data/models/meta.dart';
import 'package:gosheep_mobile/data/models/sheep.dart';

class SheepResponse {
  final List<Sheep> data;
  final Meta meta;
  final bool success;
  final String message;

  const SheepResponse({
    required this.data,
    required this.meta,
    required this.success,
    required this.message,
  });

  factory SheepResponse.fromJson(Map<String, dynamic> json) {
    return SheepResponse(
      data: (json['data'] as List)
          .map((e) => Sheep.fromJson(e))
          .toList(),
      meta: Meta.fromJson(json['meta']),
      success: json['success'],
      message: json['message'],
    );
  }
}