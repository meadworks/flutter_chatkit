import 'package:http/http.dart' as http;
import '../models/thread.dart';
import '../models/thread_item.dart';
import '../models/attachment.dart';
import '../models/page.dart';
import 'chat_kit_client.dart';
import 'custom_client.dart';
import 'request_types.dart';
import 'token_manager.dart';

/// Client for the OpenAI-hosted ChatKit backend.
/// Wraps CustomClient with token management.
class HostedClient implements ChatKitClient {
  HostedClient({
    required Future<String> Function(String? existingSecret) getClientSecret,
    String baseUrl = 'https://api.openai.com/v1/chatkit',
    http.Client? httpClient,
  }) : _tokenManager = TokenManager(getClientSecret: getClientSecret),
       _baseUrl = baseUrl,
       _httpClient = httpClient ?? http.Client();

  final TokenManager _tokenManager;
  final String _baseUrl;
  final http.Client _httpClient;
  CustomClient? _delegate;

  Future<CustomClient> _getClient() async {
    final token = await _tokenManager.getToken();
    _delegate?.dispose();
    _delegate = CustomClient(
      baseUrl: _baseUrl,
      headers: {'Authorization': 'Bearer $token'},
      httpClient: _httpClient,
    );
    return _delegate!;
  }

  Future<T> _withTokenRefresh<T>(Future<T> Function(CustomClient client) fn) async {
    try {
      final client = await _getClient();
      return await fn(client);
    } on ChatKitApiException catch (e) {
      if (e.statusCode == 401) {
        // Token expired, refresh and retry
        await _tokenManager.refreshToken();
        final client = await _getClient();
        return await fn(client);
      }
      rethrow;
    }
  }

  @override
  Future<StreamResult> createThread(ThreadCreateRequest request) =>
      _withTokenRefresh((c) => c.createThread(request));

  @override
  Future<StreamResult> addMessage(ThreadAddMessageRequest request) =>
      _withTokenRefresh((c) => c.addMessage(request));

  @override
  Future<StreamResult> addToolOutput(ThreadAddToolOutputRequest request) =>
      _withTokenRefresh((c) => c.addToolOutput(request));

  @override
  Future<StreamResult> retryAfterItem(ThreadRetryRequest request) =>
      _withTokenRefresh((c) => c.retryAfterItem(request));

  @override
  Future<StreamResult> customAction(ThreadCustomActionRequest request) =>
      _withTokenRefresh((c) => c.customAction(request));

  @override
  Future<Thread> getThread(ThreadGetByIdRequest request) =>
      _withTokenRefresh((c) => c.getThread(request));

  @override
  Future<Page<ThreadMetadata>> listThreads(ThreadListRequest request) =>
      _withTokenRefresh((c) => c.listThreads(request));

  @override
  Future<Page<ThreadItem>> listItems(ItemsListRequest request) =>
      _withTokenRefresh((c) => c.listItems(request));

  @override
  Future<void> submitFeedback(ItemsFeedbackRequest request) =>
      _withTokenRefresh((c) => c.submitFeedback(request));

  @override
  Future<Attachment> createAttachment(AttachmentCreateRequest request) =>
      _withTokenRefresh((c) => c.createAttachment(request));

  @override
  Future<void> deleteAttachment(AttachmentDeleteRequest request) =>
      _withTokenRefresh((c) => c.deleteAttachment(request));

  @override
  Future<void> updateThread(ThreadUpdateRequest request) =>
      _withTokenRefresh((c) => c.updateThread(request));

  @override
  Future<void> deleteThread(ThreadDeleteRequest request) =>
      _withTokenRefresh((c) => c.deleteThread(request));

  @override
  void dispose() {
    _delegate?.dispose();
    _httpClient.close();
  }
}
