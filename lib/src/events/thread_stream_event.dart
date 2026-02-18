import '../models/thread.dart';
import '../models/thread_item.dart';
import 'thread_item_update.dart';

/// All possible server-sent events during a thread stream
sealed class ThreadStreamEvent {
  const ThreadStreamEvent();

  factory ThreadStreamEvent.fromJson(Map<String, dynamic> json) {
    return switch (json['type']) {
      'thread.created' => ThreadCreatedEvent.fromJson(json),
      'thread.updated' => ThreadUpdatedEvent.fromJson(json),
      'thread.item.added' => ThreadItemAddedEvent.fromJson(json),
      'thread.item.updated' => ThreadItemUpdatedEvent.fromJson(json),
      'thread.item.done' => ThreadItemDoneEvent.fromJson(json),
      'thread.item.removed' => ThreadItemRemovedEvent.fromJson(json),
      'thread.item.replaced' => ThreadItemReplacedEvent.fromJson(json),
      'stream.options' => StreamOptionsEvent.fromJson(json),
      'progress.update' || 'progress_update' => ProgressUpdateEvent.fromJson(json),
      'client.effect' || 'client_effect' => ClientEffectEvent.fromJson(json),
      'error' => ErrorEvent.fromJson(json),
      'notice' => NoticeEvent.fromJson(json),
      _ => throw ArgumentError('Unknown event type: ${json['type']}'),
    };
  }
}

class ThreadCreatedEvent extends ThreadStreamEvent {
  const ThreadCreatedEvent({required this.thread});
  final Thread thread;
  factory ThreadCreatedEvent.fromJson(Map<String, dynamic> json) {
    return ThreadCreatedEvent(
      thread: Thread.fromJson(json['thread'] as Map<String, dynamic>),
    );
  }
}

class ThreadUpdatedEvent extends ThreadStreamEvent {
  const ThreadUpdatedEvent({required this.thread});
  final Thread thread;
  factory ThreadUpdatedEvent.fromJson(Map<String, dynamic> json) {
    return ThreadUpdatedEvent(
      thread: Thread.fromJson(json['thread'] as Map<String, dynamic>),
    );
  }
}

class ThreadItemAddedEvent extends ThreadStreamEvent {
  const ThreadItemAddedEvent({required this.item});
  final ThreadItem item;
  factory ThreadItemAddedEvent.fromJson(Map<String, dynamic> json) {
    return ThreadItemAddedEvent(
      item: ThreadItem.fromJson(json['item'] as Map<String, dynamic>),
    );
  }
}

class ThreadItemUpdatedEvent extends ThreadStreamEvent {
  const ThreadItemUpdatedEvent({required this.itemId, required this.update});
  final String itemId;
  final ThreadItemUpdate update;
  factory ThreadItemUpdatedEvent.fromJson(Map<String, dynamic> json) {
    return ThreadItemUpdatedEvent(
      itemId: json['item_id'] as String,
      update: ThreadItemUpdate.fromJson(json['update'] as Map<String, dynamic>),
    );
  }
}

class ThreadItemDoneEvent extends ThreadStreamEvent {
  const ThreadItemDoneEvent({required this.item});
  final ThreadItem item;
  factory ThreadItemDoneEvent.fromJson(Map<String, dynamic> json) {
    return ThreadItemDoneEvent(
      item: ThreadItem.fromJson(json['item'] as Map<String, dynamic>),
    );
  }
}

class ThreadItemRemovedEvent extends ThreadStreamEvent {
  const ThreadItemRemovedEvent({required this.itemId});
  final String itemId;
  factory ThreadItemRemovedEvent.fromJson(Map<String, dynamic> json) {
    return ThreadItemRemovedEvent(itemId: json['item_id'] as String);
  }
}

class ThreadItemReplacedEvent extends ThreadStreamEvent {
  const ThreadItemReplacedEvent({required this.item});
  final ThreadItem item;
  factory ThreadItemReplacedEvent.fromJson(Map<String, dynamic> json) {
    return ThreadItemReplacedEvent(
      item: ThreadItem.fromJson(json['item'] as Map<String, dynamic>),
    );
  }
}

class StreamOptionsEvent extends ThreadStreamEvent {
  const StreamOptionsEvent({required this.streamOptions});
  final Map<String, dynamic> streamOptions;
  factory StreamOptionsEvent.fromJson(Map<String, dynamic> json) {
    return StreamOptionsEvent(
      streamOptions: json['stream_options'] as Map<String, dynamic>,
    );
  }
}

class ProgressUpdateEvent extends ThreadStreamEvent {
  const ProgressUpdateEvent({this.icon, this.text});
  final String? icon;
  final String? text;
  factory ProgressUpdateEvent.fromJson(Map<String, dynamic> json) {
    return ProgressUpdateEvent(
      icon: json['icon'] as String?,
      text: json['text'] as String?,
    );
  }
}

class ClientEffectEvent extends ThreadStreamEvent {
  const ClientEffectEvent({required this.name, this.data});
  final String name;
  final Map<String, dynamic>? data;
  factory ClientEffectEvent.fromJson(Map<String, dynamic> json) {
    return ClientEffectEvent(
      name: json['name'] as String,
      data: json['data'] as Map<String, dynamic>?,
    );
  }
}

class ErrorEvent extends ThreadStreamEvent {
  const ErrorEvent({this.code, required this.message, this.allowRetry = false});
  final String? code;
  final String message;
  final bool allowRetry;
  factory ErrorEvent.fromJson(Map<String, dynamic> json) {
    return ErrorEvent(
      code: json['code'] as String?,
      message: json['message'] as String,
      allowRetry: json['allow_retry'] as bool? ?? false,
    );
  }
}

class NoticeEvent extends ThreadStreamEvent {
  const NoticeEvent({required this.level, required this.message, this.title});
  final String level;
  final String message;
  final String? title;
  factory NoticeEvent.fromJson(Map<String, dynamic> json) {
    return NoticeEvent(
      level: json['level'] as String,
      message: json['message'] as String,
      title: json['title'] as String?,
    );
  }
}
