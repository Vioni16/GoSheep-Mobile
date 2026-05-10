class CursorResponse<T> {
  final bool success;
  final String message;
  final List<T> data;
  final bool hasMore;
  final int? nextCursor;

  const CursorResponse({
    required this.success,
    required this.message,
    required this.data,
    required this.hasMore,
    required this.nextCursor,
  });

  factory CursorResponse.fromJson(
    Map<String, dynamic> json,
    T Function(dynamic json) fromJsonT,
  ) {
    return CursorResponse<T>(
      success: json['success'] ?? false,
      message: json['message'] ?? '',
      data: (json['data'] as List).map((e) => fromJsonT(e)).toList(),
      hasMore: json['has_more'] ?? false,
      nextCursor: json['next_cursor'],
    );
  }
}
