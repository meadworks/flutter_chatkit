import 'package:flutter/foundation.dart';
import '../models/attachment.dart';
import '../models/inference_options.dart';
import '../models/thread_item.dart';
import '../client/chat_kit_client.dart';
import '../client/request_types.dart';

/// Manages message composition and sending state
class MessageController extends ChangeNotifier {
  MessageController({required this.client});

  final ChatKitClient client;

  String _composerText = '';
  String get composerText => _composerText;

  List<Attachment> _pendingAttachments = [];
  List<Attachment> get pendingAttachments => _pendingAttachments;

  InferenceOptions? _inferenceOptions;
  InferenceOptions? get inferenceOptions => _inferenceOptions;

  bool _isSending = false;
  bool get isSending => _isSending;

  String? _quotedText;
  String? get quotedText => _quotedText;

  /// Update composer text
  void setComposerText(String text) {
    _composerText = text;
    notifyListeners();
  }

  /// Set quoted text
  void setQuotedText(String? text) {
    _quotedText = text;
    notifyListeners();
  }

  /// Add a pending attachment
  void addAttachment(Attachment attachment) {
    _pendingAttachments = [..._pendingAttachments, attachment];
    notifyListeners();
  }

  /// Remove a pending attachment
  void removeAttachment(String attachmentId) {
    _pendingAttachments =
        _pendingAttachments.where((a) => a.id != attachmentId).toList();
    notifyListeners();
  }

  /// Set inference options (tool choice, model)
  void setInferenceOptions(InferenceOptions? options) {
    _inferenceOptions = options;
    notifyListeners();
  }

  /// Build the user message input from current composer state
  UserMessageInput buildInput() {
    final content = <UserMessageContent>[
      UserMessageTextContent(text: _composerText.trim()),
    ];

    return UserMessageInput(
      content: content,
      attachments: _pendingAttachments,
      quotedText: _quotedText,
      inferenceOptions: _inferenceOptions,
    );
  }

  /// Create a new thread with the current message
  Future<StreamResult> sendNewThread() async {
    _isSending = true;
    notifyListeners();

    try {
      final input = buildInput();
      final result = await client.createThread(
        ThreadCreateRequest(input: input),
      );
      _clearComposer();
      return result;
    } catch (e) {
      _isSending = false;
      notifyListeners();
      rethrow;
    }
  }

  /// Send a message to an existing thread
  Future<StreamResult> sendMessage(String threadId) async {
    _isSending = true;
    notifyListeners();

    try {
      final input = buildInput();
      final result = await client.addMessage(
        ThreadAddMessageRequest(threadId: threadId, input: input),
      );
      _clearComposer();
      return result;
    } catch (e) {
      _isSending = false;
      notifyListeners();
      rethrow;
    }
  }

  /// Clear the composer state after sending
  void _clearComposer() {
    _composerText = '';
    _pendingAttachments = [];
    _quotedText = null;
    _inferenceOptions = null;
    _isSending = false;
    notifyListeners();
  }

  /// Reset composer without sending
  void clearComposer() {
    _clearComposer();
  }

  /// Whether the composer has content to send
  bool get canSend =>
      _composerText.trim().isNotEmpty || _pendingAttachments.isNotEmpty;
}
