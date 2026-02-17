import '../models/thread.dart';
import '../models/thread_item.dart';
import 'thread_stream_event.dart';

/// Callback for when a thread is created
typedef OnThreadCreated = void Function(Thread thread);

/// Callback for when a thread is updated
typedef OnThreadUpdated = void Function(Thread thread);

/// Callback for when a thread item is added
typedef OnThreadItemAdded = void Function(ThreadItem item);

/// Callback for when a thread item is done (finalized)
typedef OnThreadItemDone = void Function(ThreadItem item);

/// Callback for when any stream event is received
typedef OnStreamEvent = void Function(ThreadStreamEvent event);

/// Callback for errors
typedef OnError = void Function(String? code, String message, bool allowRetry);

/// Callback for progress updates
typedef OnProgress = void Function(String? icon, String? text);

/// Collection of optional event callbacks
class ChatKitEventCallbacks {
  const ChatKitEventCallbacks({
    this.onThreadCreated,
    this.onThreadUpdated,
    this.onThreadItemAdded,
    this.onThreadItemDone,
    this.onStreamEvent,
    this.onError,
    this.onProgress,
  });

  final OnThreadCreated? onThreadCreated;
  final OnThreadUpdated? onThreadUpdated;
  final OnThreadItemAdded? onThreadItemAdded;
  final OnThreadItemDone? onThreadItemDone;
  final OnStreamEvent? onStreamEvent;
  final OnError? onError;
  final OnProgress? onProgress;
}
