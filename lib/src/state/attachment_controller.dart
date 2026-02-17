import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import '../models/attachment.dart';
import '../client/chat_kit_client.dart';
import '../client/request_types.dart';

/// Upload state for a single attachment
class AttachmentUploadState {
  const AttachmentUploadState({
    required this.attachment,
    this.progress = 0.0,
    this.isUploading = false,
    this.error,
  });
  final Attachment attachment;
  final double progress;
  final bool isUploading;
  final String? error;
}

/// Manages attachment uploads
class AttachmentController extends ChangeNotifier {
  AttachmentController({
    required this.client,
    http.Client? httpClient,
  }) : _httpClient = httpClient ?? http.Client();

  final ChatKitClient client;
  final http.Client _httpClient;

  final Map<String, AttachmentUploadState> _uploads = {};
  Map<String, AttachmentUploadState> get uploads => Map.unmodifiable(_uploads);

  /// Create an attachment and get upload descriptor
  Future<Attachment> createAttachment({
    required String name,
    required int size,
    required String mimeType,
    required Uint8List data,
  }) async {
    final attachment = await client.createAttachment(
      AttachmentCreateRequest(name: name, size: size, mimeType: mimeType),
    );

    _uploads[attachment.id] = AttachmentUploadState(
      attachment: attachment,
      isUploading: true,
    );
    notifyListeners();

    try {
      // Upload the file using the descriptor
      if (attachment.uploadDescriptor != null) {
        final descriptor = attachment.uploadDescriptor!;
        final request =
            http.Request(descriptor.method, Uri.parse(descriptor.url));
        descriptor.headers.forEach((key, value) {
          request.headers[key] = value;
        });
        request.bodyBytes = data;
        await _httpClient.send(request);
      }

      _uploads[attachment.id] = AttachmentUploadState(
        attachment: attachment,
        progress: 1.0,
        isUploading: false,
      );
      notifyListeners();

      return attachment;
    } catch (e) {
      _uploads[attachment.id] = AttachmentUploadState(
        attachment: attachment,
        isUploading: false,
        error: e.toString(),
      );
      notifyListeners();
      rethrow;
    }
  }

  /// Delete an attachment
  Future<void> deleteAttachment(String attachmentId) async {
    await client.deleteAttachment(
      AttachmentDeleteRequest(attachmentId: attachmentId),
    );
    _uploads.remove(attachmentId);
    notifyListeners();
  }

  /// Clear all uploads
  void clearUploads() {
    _uploads.clear();
    notifyListeners();
  }

  @override
  void dispose() {
    _httpClient.close();
    super.dispose();
  }
}
