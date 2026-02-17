part of 'thread_item.dart';

/// Status of a client tool call
enum ToolCallStatus {
  pending,
  completed,
  failed;

  factory ToolCallStatus.fromJson(String value) {
    return switch (value) {
      'pending' => ToolCallStatus.pending,
      'completed' => ToolCallStatus.completed,
      'failed' => ToolCallStatus.failed,
      _ => throw ArgumentError('Unknown tool call status: $value'),
    };
  }

  String toJson() => name;
}

/// Client tool call thread item
class ClientToolCallItem extends ThreadItem {
  const ClientToolCallItem({
    required this.id,
    required this.threadId,
    required this.createdAt,
    required this.callId,
    required this.name,
    required this.arguments,
    this.status = ToolCallStatus.pending,
    this.output,
  });
  @override
  final String id;
  @override
  final String threadId;
  @override
  final DateTime createdAt;
  @override
  String get type => 'tool_call';
  final String callId;
  final String name;
  final String arguments;
  final ToolCallStatus status;
  final String? output;

  factory ClientToolCallItem.fromJson(Map<String, dynamic> json) {
    return ClientToolCallItem(
      id: json['id'] as String,
      threadId: json['thread_id'] as String,
      createdAt: DateTime.parse(json['created_at'] as String),
      callId: json['call_id'] as String,
      name: json['name'] as String,
      arguments: json['arguments'] as String,
      status: ToolCallStatus.fromJson(json['status'] as String? ?? 'pending'),
      output: json['output'] as String?,
    );
  }

  @override
  Map<String, dynamic> toJson() => {
    'type': type,
    'id': id,
    'thread_id': threadId,
    'created_at': createdAt.toIso8601String(),
    'call_id': callId,
    'name': name,
    'arguments': arguments,
    'status': status.toJson(),
    if (output != null) 'output': output,
  };

  ClientToolCallItem copyWith({
    ToolCallStatus? status,
    String? output,
  }) {
    return ClientToolCallItem(
      id: id,
      threadId: threadId,
      createdAt: createdAt,
      callId: callId,
      name: name,
      arguments: arguments,
      status: status ?? this.status,
      output: output ?? this.output,
    );
  }
}
