import 'dart:async';
import '../models/thread.dart';
import '../models/thread_item.dart';
import '../events/thread_stream_event.dart';
import '../events/thread_item_update.dart';
import '../client/chat_kit_client.dart';

/// Mixin that processes SSE events and updates local state
mixin StreamProcessingMixin {
  /// Current thread items (mutable, updated by events)
  List<ThreadItem> get currentItems;
  set currentItems(List<ThreadItem> value);

  /// Callbacks
  void onThreadCreatedFromStream(Thread thread);
  void onThreadUpdatedFromStream(Thread thread);
  void onItemsChanged();
  void onStreamError(String? code, String message, bool allowRetry);
  void onStreamProgress(String? icon, String? text);
  void onStreamDone();

  StreamSubscription<ThreadStreamEvent>? _activeSubscription;
  CancelStream? _cancelStream;

  bool get isStreaming => _activeSubscription != null;

  /// Process a stream result from the client
  Future<void> processStream(StreamResult result) async {
    // Cancel any existing stream
    cancelCurrentStream();

    _cancelStream = result.cancel;

    _activeSubscription = result.events.listen(
      _handleEvent,
      onError: (Object error) {
        onStreamError(null, error.toString(), false);
        _cleanupStream();
      },
      onDone: () {
        onStreamDone();
        _cleanupStream();
      },
    );
  }

  void _handleEvent(ThreadStreamEvent event) {
    switch (event) {
      case ThreadCreatedEvent(:final thread):
        onThreadCreatedFromStream(thread);

      case ThreadUpdatedEvent(:final thread):
        onThreadUpdatedFromStream(thread);

      case ThreadItemAddedEvent(:final item):
        // If the server echoes back a user message, replace the optimistic one
        if (item is UserMessageItem) {
          final hasOptimistic = currentItems.any(
            (i) => i is UserMessageItem && i.id.startsWith('pending-'),
          );
          if (hasOptimistic) {
            currentItems = [
              ...currentItems.where(
                (i) => !(i is UserMessageItem && i.id.startsWith('pending-')),
              ),
              item,
            ];
            onItemsChanged();
            break;
          }
        }
        currentItems = [...currentItems, item];
        onItemsChanged();

      case ThreadItemUpdatedEvent(:final itemId, :final update):
        _applyItemUpdate(itemId, update);
        onItemsChanged();

      case ThreadItemDoneEvent(:final item):
        _replaceItem(item.id, item);
        onItemsChanged();

      case ThreadItemRemovedEvent(:final itemId):
        currentItems = currentItems.where((i) => i.id != itemId).toList();
        onItemsChanged();

      case ThreadItemReplacedEvent(:final item):
        _replaceItem(item.id, item);
        onItemsChanged();

      case StreamOptionsEvent():
        // Store stream options if needed
        break;

      case ProgressUpdateEvent(:final icon, :final text):
        onStreamProgress(icon, text);

      case ClientEffectEvent():
        // Handle client effects
        break;

      case ErrorEvent(:final code, :final message, :final allowRetry):
        onStreamError(code, message, allowRetry);

      case NoticeEvent():
        // Handle notices
        break;
    }
  }

  void _replaceItem(String itemId, ThreadItem newItem) {
    currentItems =
        currentItems.map((i) => i.id == itemId ? newItem : i).toList();
  }

  void _applyItemUpdate(String itemId, ThreadItemUpdate update) {
    currentItems = currentItems.map((item) {
      if (item.id != itemId) return item;
      return _applyUpdate(item, update);
    }).toList();
  }

  ThreadItem _applyUpdate(ThreadItem item, ThreadItemUpdate update) {
    switch (update) {
      case AssistantMessageContentPartAdded(:final partIndex, :final part):
        if (item is AssistantMessageItem) {
          final newContent = List<AssistantMessageContent>.from(item.content);
          if (partIndex >= newContent.length) {
            newContent.add(part);
          } else {
            newContent[partIndex] = part;
          }
          return AssistantMessageItem(
            id: item.id,
            threadId: item.threadId,
            createdAt: item.createdAt,
            content: newContent,
          );
        }
        return item;

      case TextDelta(:final partIndex, :final delta):
        if (item is AssistantMessageItem && partIndex < item.content.length) {
          final newContent = List<AssistantMessageContent>.from(item.content);
          newContent[partIndex] = newContent[partIndex].copyWith(
            text: newContent[partIndex].text + delta,
          );
          return AssistantMessageItem(
            id: item.id,
            threadId: item.threadId,
            createdAt: item.createdAt,
            content: newContent,
          );
        }
        return item;

      case AnnotationAdded(:final partIndex, :final annotation):
        if (item is AssistantMessageItem && partIndex < item.content.length) {
          final newContent = List<AssistantMessageContent>.from(item.content);
          newContent[partIndex] = newContent[partIndex].copyWith(
            annotations: [...newContent[partIndex].annotations, annotation],
          );
          return AssistantMessageItem(
            id: item.id,
            threadId: item.threadId,
            createdAt: item.createdAt,
            content: newContent,
          );
        }
        return item;

      case ContentPartDone(:final partIndex, :final part):
        if (item is AssistantMessageItem && partIndex < item.content.length) {
          final newContent = List<AssistantMessageContent>.from(item.content);
          newContent[partIndex] = part;
          return AssistantMessageItem(
            id: item.id,
            threadId: item.threadId,
            createdAt: item.createdAt,
            content: newContent,
          );
        }
        return item;

      case WidgetDelta(:final delta):
        if (item is WidgetItem) {
          final newWidget = Map<String, dynamic>.from(item.widget)
            ..addAll(delta);
          return WidgetItem(
            id: item.id,
            threadId: item.threadId,
            createdAt: item.createdAt,
            widget: newWidget,
            copyText: item.copyText,
          );
        }
        return item;

      case WorkflowTaskAdded(:final task):
        if (item is WorkflowItem) {
          final newTasks = List<Task>.from(item.workflow.tasks);
          newTasks.add(Task.fromJson(task));
          return WorkflowItem(
            id: item.id,
            threadId: item.threadId,
            createdAt: item.createdAt,
            workflow: Workflow(
              workflowType: item.workflow.workflowType,
              tasks: newTasks,
              summary: item.workflow.summary,
              expanded: item.workflow.expanded,
            ),
          );
        }
        return item;

      case WorkflowTaskUpdated(:final taskIndex, :final task):
        if (item is WorkflowItem && taskIndex < item.workflow.tasks.length) {
          final newTasks = List<Task>.from(item.workflow.tasks);
          newTasks[taskIndex] = Task.fromJson(task);
          return WorkflowItem(
            id: item.id,
            threadId: item.threadId,
            createdAt: item.createdAt,
            workflow: Workflow(
              workflowType: item.workflow.workflowType,
              tasks: newTasks,
              summary: item.workflow.summary,
              expanded: item.workflow.expanded,
            ),
          );
        }
        return item;

      case WorkflowTaskDone(:final taskIndex, :final task):
        if (item is WorkflowItem && taskIndex < item.workflow.tasks.length) {
          final newTasks = List<Task>.from(item.workflow.tasks);
          newTasks[taskIndex] = Task.fromJson(task);
          return WorkflowItem(
            id: item.id,
            threadId: item.threadId,
            createdAt: item.createdAt,
            workflow: Workflow(
              workflowType: item.workflow.workflowType,
              tasks: newTasks,
              summary: item.workflow.summary,
              expanded: item.workflow.expanded,
            ),
          );
        }
        return item;

      case WorkflowSummaryUpdated(:final summary):
        if (item is WorkflowItem) {
          return WorkflowItem(
            id: item.id,
            threadId: item.threadId,
            createdAt: item.createdAt,
            workflow: Workflow(
              workflowType: item.workflow.workflowType,
              tasks: item.workflow.tasks,
              summary: WorkflowSummary.fromJson(summary),
              expanded: item.workflow.expanded,
            ),
          );
        }
        return item;

      case WorkflowExpandedUpdated(:final expanded):
        if (item is WorkflowItem) {
          return WorkflowItem(
            id: item.id,
            threadId: item.threadId,
            createdAt: item.createdAt,
            workflow: Workflow(
              workflowType: item.workflow.workflowType,
              tasks: item.workflow.tasks,
              summary: item.workflow.summary,
              expanded: expanded,
            ),
          );
        }
        return item;

      case GeneratedImageUpdated(:final image):
        if (item is GeneratedImageItem) {
          return GeneratedImageItem(
            id: item.id,
            threadId: item.threadId,
            createdAt: item.createdAt,
            image: GeneratedImage.fromJson(image),
          );
        }
        return item;
    }
  }

  void cancelCurrentStream() {
    _cancelStream?.call();
    _activeSubscription?.cancel();
    _cleanupStream();
  }

  void _cleanupStream() {
    _activeSubscription = null;
    _cancelStream = null;
  }
}
