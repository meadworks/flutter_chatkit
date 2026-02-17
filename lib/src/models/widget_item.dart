part of 'thread_item.dart';

class WidgetItem extends ThreadItem {
  const WidgetItem({
    required this.id,
    required this.threadId,
    required this.createdAt,
    required this.widget,
    this.copyText,
  });
  @override
  final String id;
  @override
  final String threadId;
  @override
  final DateTime createdAt;
  @override
  String get type => 'widget';
  final Map<String, dynamic> widget;
  final String? copyText;

  factory WidgetItem.fromJson(Map<String, dynamic> json) {
    return WidgetItem(
      id: json['id'] as String,
      threadId: json['thread_id'] as String,
      createdAt: DateTime.parse(json['created_at'] as String),
      widget: json['widget'] as Map<String, dynamic>,
      copyText: json['copy_text'] as String?,
    );
  }

  @override
  Map<String, dynamic> toJson() => {
    'type': type,
    'id': id,
    'thread_id': threadId,
    'created_at': createdAt.toIso8601String(),
    'widget': widget,
    if (copyText != null) 'copy_text': copyText,
  };
}
