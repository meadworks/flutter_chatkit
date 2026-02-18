import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/thread.dart';
import '../models/thread_item.dart';
import '../models/attachment.dart';
import '../models/page.dart';
import '../events/thread_stream_event.dart';
import 'chat_kit_client.dart';
import 'request_types.dart';
import 'sse_connection.dart';

/// Client for self-hosted ChatKit backend
class CustomClient implements ChatKitClient {
  CustomClient({
    required this.baseUrl,
    this.headers = const {},
    http.Client? httpClient,
  }) : _httpClient = httpClient ?? http.Client(),
       _sseClient = SseClient(httpClient: httpClient);

  final String baseUrl;
  final Map<String, String> headers;
  final http.Client _httpClient;
  final SseClient _sseClient;

  Map<String, String> get _headers => {
    'Content-Type': 'application/json',
    ...headers,
  };

  Uri get _baseUri => Uri.parse(baseUrl);

  Future<StreamResult> _streamRequest(Map<String, dynamic> body) async {
    final connection = await _sseClient.connect(
      uri: _baseUri,
      headers: _headers,
      body: jsonEncode(body),
    );

    final eventStream = connection.eventStream.map(
      (json) => ThreadStreamEvent.fromJson(json),
    );

    return StreamResult(
      events: eventStream,
      cancel: connection.cancel,
    );
  }

  Future<Map<String, dynamic>> _jsonRequest(Map<String, dynamic> body) async {
    final response = await _httpClient.post(
      _baseUri,
      headers: _headers,
      body: jsonEncode(body),
    );

    if (response.statusCode < 200 || response.statusCode >= 300) {
      throw ChatKitApiException(
        statusCode: response.statusCode,
        message: response.body,
      );
    }

    if (response.body.isEmpty) return {};
    return jsonDecode(response.body) as Map<String, dynamic>;
  }

  @override
  Future<StreamResult> createThread(ThreadCreateRequest request) =>
      _streamRequest(request.toJson());

  @override
  Future<StreamResult> addMessage(ThreadAddMessageRequest request) =>
      _streamRequest(request.toJson());

  @override
  Future<StreamResult> addToolOutput(ThreadAddToolOutputRequest request) =>
      _streamRequest(request.toJson());

  @override
  Future<StreamResult> retryAfterItem(ThreadRetryRequest request) =>
      _streamRequest(request.toJson());

  @override
  Future<StreamResult> customAction(ThreadCustomActionRequest request) =>
      _streamRequest(request.toJson());

  @override
  Future<Thread> getThread(ThreadGetByIdRequest request) async {
    final json = await _jsonRequest({
      'type': 'threads.get_by_id',
      'params': {
        'thread_id': request.threadId,
      },
    });
    return Thread.fromJson(json);
  }

  @override
  Future<Page<ThreadMetadata>> listThreads(ThreadListRequest request) async {
    final json = await _jsonRequest({
      'type': 'threads.list',
      'params': {
        'limit': request.limit,
        'order': request.order,
        if (request.after != null) 'after': request.after,
      },
    });
    return Page.fromJson(json, (item) => ThreadMetadata.fromJson(item as Map<String, dynamic>));
  }

  @override
  Future<Page<ThreadItem>> listItems(ItemsListRequest request) async {
    final json = await _jsonRequest({
      'type': 'items.list',
      'params': {
        'thread_id': request.threadId,
        'limit': request.limit,
        'order': request.order,
        if (request.after != null) 'after': request.after,
      },
    });
    return Page.fromJson(json, (item) => ThreadItem.fromJson(item as Map<String, dynamic>));
  }

  @override
  Future<void> submitFeedback(ItemsFeedbackRequest request) async {
    await _jsonRequest({
      'type': 'items.feedback',
      'params': request.toJson(),
    });
  }

  @override
  Future<Attachment> createAttachment(AttachmentCreateRequest request) async {
    final json = await _jsonRequest({
      'type': 'attachments.create',
      'params': request.toJson(),
    });
    return Attachment.fromJson(json);
  }

  @override
  Future<void> deleteAttachment(AttachmentDeleteRequest request) async {
    await _jsonRequest({
      'type': 'attachments.delete',
      'params': {
        'attachment_id': request.attachmentId,
      },
    });
  }

  @override
  Future<void> updateThread(ThreadUpdateRequest request) async {
    await _jsonRequest({
      'type': 'threads.update',
      'params': {
        'thread_id': request.threadId,
        'title': request.title,
      },
    });
  }

  @override
  Future<void> deleteThread(ThreadDeleteRequest request) async {
    await _jsonRequest({
      'type': 'threads.delete',
      'params': {
        'thread_id': request.threadId,
      },
    });
  }

  @override
  void dispose() {
    _httpClient.close();
    _sseClient.dispose();
  }
}

class ChatKitApiException implements Exception {
  const ChatKitApiException({required this.statusCode, required this.message});
  final int statusCode;
  final String message;

  @override
  String toString() => 'ChatKitApiException($statusCode): $message';
}
