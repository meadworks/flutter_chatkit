import 'package:flutter/foundation.dart';
import '../models/thread.dart';
import '../models/thread_item.dart';
import '../config/chat_kit_options.dart';
import '../config/api_config.dart';
import '../client/chat_kit_client.dart';
import '../client/custom_client.dart';
import '../client/hosted_client.dart';
import '../client/request_types.dart';
import 'stream_controller_mixin.dart';
import 'thread_controller.dart';
import 'message_controller.dart';
import 'attachment_controller.dart';
import 'widget_action_controller.dart';

/// The main controller for ChatKit.
/// Exposes the full API surface and coordinates sub-controllers.
class ChatKitController extends ChangeNotifier with StreamProcessingMixin {
  ChatKitController({required ChatKitOptions options})
      : _options = options,
        _client = _createClient(options) {
    _threadController = ThreadController(
      client: _client,
      pageSize: options.history.pageSize,
    );
    _messageController = MessageController(client: _client);
    _attachmentController = AttachmentController(client: _client);
    _widgetActionController = WidgetActionController(client: _client);

    // Forward sub-controller notifications
    _threadController.addListener(notifyListeners);
    _messageController.addListener(notifyListeners);
    _attachmentController.addListener(notifyListeners);
    _widgetActionController.addListener(notifyListeners);
  }

  final ChatKitOptions _options;
  final ChatKitClient _client;
  late final ThreadController _threadController;
  late final MessageController _messageController;
  late final AttachmentController _attachmentController;
  late final WidgetActionController _widgetActionController;

  // Stream processing state
  @override
  List<ThreadItem> currentItems = [];

  bool _isStreaming = false;

  // Progress state
  String? _progressIcon;
  String? get progressIcon => _progressIcon;
  String? _progressText;
  String? get progressText => _progressText;

  // Error state
  String? _errorMessage;
  String? get errorMessage => _errorMessage;
  bool _allowRetry = false;
  bool get allowRetry => _allowRetry;

  static ChatKitClient _createClient(ChatKitOptions options) {
    return switch (options.api) {
      CustomApiConfig(:final url, :final headers) => CustomClient(
          baseUrl: url,
          headers: headers,
        ),
      HostedApiConfig(:final getClientSecret, :final baseUrl) => HostedClient(
          getClientSecret: getClientSecret,
          baseUrl: '$baseUrl/chatkit',
        ),
    };
  }

  // ---- Accessors for sub-controllers ----

  ChatKitOptions get options => _options;
  ThreadController get threadController => _threadController;
  MessageController get messageController => _messageController;
  AttachmentController get attachmentController => _attachmentController;
  WidgetActionController get widgetActionController => _widgetActionController;

  // ---- Thread list accessors ----

  List<ThreadMetadata> get threads => _threadController.threads;
  String? get activeThreadId => _threadController.activeThreadId;
  Thread? get activeThread => _threadController.activeThread;
  bool get isLoadingThreads => _threadController.isLoadingThreads;

  // ---- Message list ----

  /// Current visible items (from active thread or current stream)
  List<ThreadItem> get items => currentItems;

  // ---- Composer accessors ----

  String get composerText => _messageController.composerText;
  bool get isSending => _messageController.isSending;
  bool get canSend => _messageController.canSend;

  // ---- Stream state ----

  bool get isStreamActive => _isStreaming;

  // ---- Initialization ----

  /// Initialize the controller (load thread list)
  Future<void> initialize() async {
    if (_options.history.enabled) {
      await _threadController.loadThreads();
    }
  }

  // ---- Thread operations ----

  Future<void> selectThread(String threadId) async {
    await _threadController.setActiveThread(threadId);
    if (_threadController.activeThread != null) {
      currentItems = _threadController.activeThread!.items.data;
      notifyListeners();
    }
  }

  void startNewThread() {
    _threadController.clearActiveThread();
    currentItems = [];
    _clearStreamState();
    notifyListeners();
  }

  Future<void> loadMoreThreads() => _threadController.loadMoreThreads();

  // ---- Sending messages ----

  void setComposerText(String text) =>
      _messageController.setComposerText(text);

  /// Send the current composer content
  Future<void> send() async {
    if (!_messageController.canSend) return;

    _clearStreamState();

    // Add user message to items immediately so it's visible in the UI
    final input = _messageController.buildInput();
    final optimisticMessage = UserMessageItem(
      id: 'pending-${DateTime.now().millisecondsSinceEpoch}',
      threadId: _threadController.activeThreadId ?? '',
      createdAt: DateTime.now(),
      content: input.content,
      attachments: input.attachments,
      quotedText: input.quotedText,
      inferenceOptions: input.inferenceOptions,
    );
    currentItems = [...currentItems, optimisticMessage];
    notifyListeners();

    try {
      StreamResult result;
      if (_threadController.activeThreadId != null) {
        result = await _messageController.sendMessage(
          _threadController.activeThreadId!,
        );
      } else {
        result = await _messageController.sendNewThread();
      }

      _isStreaming = true;
      notifyListeners();
      await processStream(result);
    } catch (e) {
      // Remove optimistic message on error
      currentItems = currentItems.where(
        (i) => !(i is UserMessageItem && i.id.startsWith('pending-')),
      ).toList();
      _isStreaming = false;
      _errorMessage = e.toString();
      notifyListeners();
    }
  }

  /// Dismiss the current error message
  void dismissError() {
    _errorMessage = null;
    _allowRetry = false;
    notifyListeners();
  }

  /// Cancel the current streaming response
  void cancelStream() {
    cancelCurrentStream();
    _isStreaming = false;
    notifyListeners();
  }

  /// Retry from a specific item
  Future<void> retryFromItem(String itemId) async {
    final threadId = _threadController.activeThreadId;
    if (threadId == null) return;

    _clearStreamState();
    _isStreaming = true;
    notifyListeners();

    try {
      final result = await _client.retryAfterItem(
        ThreadRetryRequest(threadId: threadId, itemId: itemId),
      );
      await processStream(result);
    } catch (e) {
      _errorMessage = e.toString();
      _isStreaming = false;
      notifyListeners();
    }
  }

  /// Submit feedback on items
  Future<void> submitFeedback(List<String> itemIds, String kind) async {
    final threadId = _threadController.activeThreadId;
    if (threadId == null) return;
    await _client.submitFeedback(
      ItemsFeedbackRequest(threadId: threadId, itemIds: itemIds, kind: kind),
    );
  }

  // ---- Stream processing callbacks ----

  @override
  void onThreadCreatedFromStream(Thread thread) {
    _threadController.upsertThread(thread);
    // If no active thread, set this as active
    if (_threadController.activeThreadId == null) {
      _threadController.setActiveThreadDirect(thread.id, thread);
    }
    _options.events.onThreadCreated?.call(thread);
    notifyListeners();
  }

  @override
  void onThreadUpdatedFromStream(Thread thread) {
    _threadController.upsertThread(thread);
    if (_threadController.activeThreadId == thread.id) {
      _threadController.setActiveThreadDirect(thread.id, thread);
    }
    _options.events.onThreadUpdated?.call(thread);
    notifyListeners();
  }

  @override
  void onItemsChanged() {
    notifyListeners();
  }

  @override
  void onStreamError(String? code, String message, bool allowRetry) {
    _isStreaming = false;
    _errorMessage = message;
    _allowRetry = allowRetry;
    _options.events.onError?.call(code, message, allowRetry);
    notifyListeners();
  }

  @override
  void onStreamProgress(String? icon, String? text) {
    _progressIcon = icon;
    _progressText = text;
    _options.events.onProgress?.call(icon, text);
    notifyListeners();
  }

  @override
  void onStreamDone() {
    _isStreaming = false;
    _progressIcon = null;
    _progressText = null;
    notifyListeners();
  }

  void _clearStreamState() {
    _errorMessage = null;
    _allowRetry = false;
    _progressIcon = null;
    _progressText = null;
  }

  @override
  void dispose() {
    cancelCurrentStream();
    _threadController.removeListener(notifyListeners);
    _messageController.removeListener(notifyListeners);
    _attachmentController.removeListener(notifyListeners);
    _widgetActionController.removeListener(notifyListeners);
    _threadController.dispose();
    _messageController.dispose();
    _attachmentController.dispose();
    _widgetActionController.dispose();
    _client.dispose();
    super.dispose();
  }
}
