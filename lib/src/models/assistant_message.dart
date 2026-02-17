part of 'thread_item.dart';

/// Content part of an assistant message
class AssistantMessageContent {
  const AssistantMessageContent({
    required this.text,
    this.annotations = const [],
  });
  final String text;
  final List<Annotation> annotations;

  factory AssistantMessageContent.fromJson(Map<String, dynamic> json) {
    return AssistantMessageContent(
      text: json['text'] as String,
      annotations: (json['annotations'] as List?)
              ?.map((a) => Annotation.fromJson(a as Map<String, dynamic>))
              .toList() ??
          const [],
    );
  }

  Map<String, dynamic> toJson() => {
    'type': 'output_text',
    'text': text,
    if (annotations.isNotEmpty)
      'annotations': annotations.map((a) => a.toJson()).toList(),
  };

  AssistantMessageContent copyWith({
    String? text,
    List<Annotation>? annotations,
  }) {
    return AssistantMessageContent(
      text: text ?? this.text,
      annotations: annotations ?? this.annotations,
    );
  }
}

/// Assistant message thread item
class AssistantMessageItem extends ThreadItem {
  const AssistantMessageItem({
    required this.id,
    required this.threadId,
    required this.createdAt,
    required this.content,
  });
  @override
  final String id;
  @override
  final String threadId;
  @override
  final DateTime createdAt;
  @override
  String get type => 'assistant_message';
  final List<AssistantMessageContent> content;

  factory AssistantMessageItem.fromJson(Map<String, dynamic> json) {
    return AssistantMessageItem(
      id: json['id'] as String,
      threadId: json['thread_id'] as String,
      createdAt: DateTime.parse(json['created_at'] as String),
      content: (json['content'] as List)
          .map((c) =>
              AssistantMessageContent.fromJson(c as Map<String, dynamic>))
          .toList(),
    );
  }

  @override
  Map<String, dynamic> toJson() => {
    'type': type,
    'id': id,
    'thread_id': threadId,
    'created_at': createdAt.toIso8601String(),
    'content': content.map((c) => c.toJson()).toList(),
  };

  /// Get the full text of all content parts
  String get fullText => content.map((c) => c.text).join('');

  /// Get all annotations across all content parts
  List<Annotation> get allAnnotations =>
      content.expand((c) => c.annotations).toList();
}
