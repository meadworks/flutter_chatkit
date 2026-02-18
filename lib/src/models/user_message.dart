part of 'thread_item.dart';

/// User message content sealed class
sealed class UserMessageContent {
  const UserMessageContent();
  factory UserMessageContent.fromJson(Map<String, dynamic> json) {
    return switch (json['type']) {
      'input_text' => UserMessageTextContent(text: json['text'] as String),
      'input_tag' => UserMessageTagContent(
        id: json['id'] as String,
        text: json['text'] as String,
        data: json['data'] as Map<String, dynamic>?,
        group: json['group'] as String?,
        interactive: json['interactive'] as bool? ?? false,
      ),
      _ => throw ArgumentError('Unknown content type: ${json['type']}'),
    };
  }
  Map<String, dynamic> toJson();
}

class UserMessageTextContent extends UserMessageContent {
  const UserMessageTextContent({required this.text});
  final String text;
  @override
  Map<String, dynamic> toJson() => {'type': 'input_text', 'text': text};
}

class UserMessageTagContent extends UserMessageContent {
  const UserMessageTagContent({
    required this.id,
    required this.text,
    this.data,
    this.group,
    this.interactive = false,
  });
  final String id;
  final String text;
  final Map<String, dynamic>? data;
  final String? group;
  final bool interactive;
  @override
  Map<String, dynamic> toJson() => {
    'type': 'input_tag',
    'id': id,
    'text': text,
    if (data != null) 'data': data,
    if (group != null) 'group': group,
    'interactive': interactive,
  };
}

/// User message input (for sending)
class UserMessageInput {
  const UserMessageInput({
    required this.content,
    this.attachments = const [],
    this.quotedText,
    this.inferenceOptions,
  });
  final List<UserMessageContent> content;
  final List<Attachment> attachments;
  final String? quotedText;
  final InferenceOptions? inferenceOptions;

  Map<String, dynamic> toJson() => {
    'content': content.map((c) => c.toJson()).toList(),
    if (attachments.isNotEmpty)
      'attachments': attachments.map((a) => a.toJson()).toList(),
    if (quotedText != null) 'quoted_text': quotedText,
    if (inferenceOptions != null)
      'inference_options': inferenceOptions!.toJson(),
  };
}

/// User message thread item
class UserMessageItem extends ThreadItem {
  const UserMessageItem({
    required this.id,
    required this.threadId,
    required this.createdAt,
    required this.content,
    this.attachments = const [],
    this.quotedText,
    this.inferenceOptions,
  });
  @override
  final String id;
  @override
  final String threadId;
  @override
  final DateTime createdAt;
  @override
  String get type => 'user_message';
  final List<UserMessageContent> content;
  final List<Attachment> attachments;
  final String? quotedText;
  final InferenceOptions? inferenceOptions;

  factory UserMessageItem.fromJson(Map<String, dynamic> json) {
    return UserMessageItem(
      id: json['id'] as String,
      threadId: json['thread_id'] as String,
      createdAt: DateTime.parse(json['created_at'] as String),
      content: (json['content'] as List)
          .map((c) => UserMessageContent.fromJson(c as Map<String, dynamic>))
          .toList(),
      attachments: (json['attachments'] as List?)
              ?.map((a) => Attachment.fromJson(a as Map<String, dynamic>))
              .toList() ??
          const [],
      quotedText: json['quoted_text'] as String?,
      inferenceOptions: json['inference_options'] != null
          ? InferenceOptions.fromJson(
              json['inference_options'] as Map<String, dynamic>,
            )
          : null,
    );
  }

  @override
  Map<String, dynamic> toJson() => {
    'type': type,
    'id': id,
    'thread_id': threadId,
    'created_at': createdAt.toIso8601String(),
    'content': content.map((c) => c.toJson()).toList(),
    if (attachments.isNotEmpty)
      'attachments': attachments.map((a) => a.toJson()).toList(),
    if (quotedText != null) 'quoted_text': quotedText,
    if (inferenceOptions != null)
      'inference_options': inferenceOptions!.toJson(),
  };

  /// Get the plain text representation of all content
  String get plainText => content
      .map((c) => switch (c) {
            UserMessageTextContent(:final text) => text,
            UserMessageTagContent(:final text) => text,
          },)
      .join('');
}
