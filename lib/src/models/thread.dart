import 'package:flutter_chatkit/src/models/page.dart';
import 'package:flutter_chatkit/src/models/thread_item.dart';

/// Thread status sealed class hierarchy.
///
/// Represents the lifecycle state of a thread:
/// - [ActiveStatus]: Thread is open and accepting new messages.
/// - [LockedStatus]: Thread is locked (e.g., while AI is responding).
/// - [ClosedStatus]: Thread is closed and no longer accepts messages.
sealed class ThreadStatus {
  const ThreadStatus();

  /// Deserializes a [ThreadStatus] from JSON.
  factory ThreadStatus.fromJson(Map<String, dynamic> json) {
    return switch (json['type']) {
      'active' => const ActiveStatus(),
      'locked' => LockedStatus(reason: json['reason'] as String?),
      'closed' => ClosedStatus(reason: json['reason'] as String?),
      _ => throw ArgumentError('Unknown thread status type: ${json['type']}'),
    };
  }

  /// Serializes this [ThreadStatus] to JSON.
  Map<String, dynamic> toJson();
}

/// Thread is open and accepting new messages.
class ActiveStatus extends ThreadStatus {
  const ActiveStatus();

  @override
  Map<String, dynamic> toJson() => {'type': 'active'};
}

/// Thread is locked, optionally with a [reason].
class LockedStatus extends ThreadStatus {
  const LockedStatus({this.reason});

  /// Optional reason for why the thread is locked.
  final String? reason;

  @override
  Map<String, dynamic> toJson() => {
        'type': 'locked',
        if (reason != null) 'reason': reason,
      };
}

/// Thread is closed, optionally with a [reason].
class ClosedStatus extends ThreadStatus {
  const ClosedStatus({this.reason});

  /// Optional reason for why the thread was closed.
  final String? reason;

  @override
  Map<String, dynamic> toJson() => {
        'type': 'closed',
        if (reason != null) 'reason': reason,
      };
}

/// Thread metadata used in thread lists.
///
/// Contains the essential information about a thread without its items.
/// Use [Thread] when you need the full thread with its items.
class ThreadMetadata {
  const ThreadMetadata({
    required this.id,
    required this.title,
    required this.createdAt,
    required this.status,
    this.metadata = const {},
  });

  /// Unique identifier for the thread.
  final String id;

  /// Display title for the thread. May be null if not yet generated.
  final String? title;

  /// When the thread was created.
  final DateTime createdAt;

  /// Current status of the thread.
  final ThreadStatus status;

  /// Arbitrary metadata attached to the thread.
  final Map<String, dynamic> metadata;

  /// Deserializes a [ThreadMetadata] from JSON.
  factory ThreadMetadata.fromJson(Map<String, dynamic> json) {
    return ThreadMetadata(
      id: json['id'] as String,
      title: json['title'] as String?,
      createdAt: DateTime.parse(json['created_at'] as String),
      status: ThreadStatus.fromJson(json['status'] as Map<String, dynamic>),
      metadata: (json['metadata'] as Map<String, dynamic>?) ?? const {},
    );
  }

  /// Serializes this [ThreadMetadata] to JSON.
  Map<String, dynamic> toJson() => {
        'id': id,
        'title': title,
        'created_at': createdAt.toIso8601String(),
        'status': status.toJson(),
        'metadata': metadata,
      };

  /// Creates a copy of this [ThreadMetadata] with the given fields replaced.
  ThreadMetadata copyWith({
    String? id,
    String? title,
    DateTime? createdAt,
    ThreadStatus? status,
    Map<String, dynamic>? metadata,
  }) {
    return ThreadMetadata(
      id: id ?? this.id,
      title: title ?? this.title,
      createdAt: createdAt ?? this.createdAt,
      status: status ?? this.status,
      metadata: metadata ?? this.metadata,
    );
  }
}

/// A thread with its items (messages, tool calls, etc.).
///
/// Extends [ThreadMetadata] with a paginated list of [ThreadItem]s.
class Thread extends ThreadMetadata {
  const Thread({
    required super.id,
    required super.title,
    required super.createdAt,
    required super.status,
    super.metadata,
    required this.items,
  });

  /// Paginated list of items in this thread.
  final Page<ThreadItem> items;

  /// Deserializes a [Thread] from JSON.
  factory Thread.fromJson(Map<String, dynamic> json) {
    return Thread(
      id: json['id'] as String,
      title: json['title'] as String?,
      createdAt: DateTime.parse(json['created_at'] as String),
      status: ThreadStatus.fromJson(json['status'] as Map<String, dynamic>),
      metadata: (json['metadata'] as Map<String, dynamic>?) ?? const {},
      items: Page.fromJson(
        json['items'] as Map<String, dynamic>,
        (item) => ThreadItem.fromJson(item as Map<String, dynamic>),
      ),
    );
  }

  @override
  Map<String, dynamic> toJson() => {
        ...super.toJson(),
        'items': items.toJson((item) => item.toJson()),
      };
}
