part of 'thread_item.dart';

class EndOfTurnItem extends ThreadItem {
  const EndOfTurnItem({
    required this.id,
    required this.threadId,
    required this.createdAt,
  });
  @override
  final String id;
  @override
  final String threadId;
  @override
  final DateTime createdAt;
  @override
  String get type => 'end_of_turn';

  factory EndOfTurnItem.fromJson(Map<String, dynamic> json) {
    return EndOfTurnItem(
      id: json['id'] as String,
      threadId: json['thread_id'] as String,
      createdAt: DateTime.parse(json['created_at'] as String),
    );
  }

  @override
  Map<String, dynamic> toJson() => {
    'type': type,
    'id': id,
    'thread_id': threadId,
    'created_at': createdAt.toIso8601String(),
  };
}
