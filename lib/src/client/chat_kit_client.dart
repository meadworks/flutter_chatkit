import 'dart:async';
import '../models/thread.dart';
import '../models/thread_item.dart';
import '../models/attachment.dart';
import '../models/page.dart';
import '../events/thread_stream_event.dart';
import 'request_types.dart';

/// Callback for cancelling an active stream
typedef CancelStream = void Function();

/// Result of a streaming request
class StreamResult {
  const StreamResult({
    required this.events,
    required this.cancel,
  });
  final Stream<ThreadStreamEvent> events;
  final CancelStream cancel;
}

/// Abstract interface for ChatKit API communication
abstract class ChatKitClient {
  // Streaming endpoints (return SSE streams)

  /// Create a new thread with initial message
  Future<StreamResult> createThread(ThreadCreateRequest request);

  /// Add a message to an existing thread
  Future<StreamResult> addMessage(ThreadAddMessageRequest request);

  /// Submit tool call output
  Future<StreamResult> addToolOutput(ThreadAddToolOutputRequest request);

  /// Retry from a specific item
  Future<StreamResult> retryAfterItem(ThreadRetryRequest request);

  /// Execute a custom action (widget)
  Future<StreamResult> customAction(ThreadCustomActionRequest request);

  // Non-streaming endpoints (return JSON)

  /// Get a thread by ID
  Future<Thread> getThread(ThreadGetByIdRequest request);

  /// List threads
  Future<Page<ThreadMetadata>> listThreads(ThreadListRequest request);

  /// List items in a thread
  Future<Page<ThreadItem>> listItems(ItemsListRequest request);

  /// Submit feedback on items
  Future<void> submitFeedback(ItemsFeedbackRequest request);

  /// Create an attachment upload descriptor
  Future<Attachment> createAttachment(AttachmentCreateRequest request);

  /// Delete an attachment
  Future<void> deleteAttachment(AttachmentDeleteRequest request);

  /// Update thread title
  Future<void> updateThread(ThreadUpdateRequest request);

  /// Delete a thread
  Future<void> deleteThread(ThreadDeleteRequest request);

  /// Dispose resources
  void dispose();
}
