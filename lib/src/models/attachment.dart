class AttachmentUploadDescriptor {
  const AttachmentUploadDescriptor({
    required this.url,
    required this.method,
    this.headers = const {},
  });
  final String url;
  final String method;
  final Map<String, String> headers;

  factory AttachmentUploadDescriptor.fromJson(Map<String, dynamic> json) {
    return AttachmentUploadDescriptor(
      url: json['url'] as String,
      method: json['method'] as String,
      headers: (json['headers'] as Map<String, dynamic>?)
              ?.cast<String, String>() ??
          const {},
    );
  }

  Map<String, dynamic> toJson() => {
    'url': url,
    'method': method,
    if (headers.isNotEmpty) 'headers': headers,
  };
}

sealed class Attachment {
  const Attachment();
  String get id;
  String get name;
  String get mimeType;
  String get type;
  String? get threadId;
  AttachmentUploadDescriptor? get uploadDescriptor;
  Map<String, dynamic>? get metadata;

  factory Attachment.fromJson(Map<String, dynamic> json) {
    return switch (json['type']) {
      'file' => FileAttachment.fromJson(json),
      'image' => ImageAttachment.fromJson(json),
      _ => throw ArgumentError('Unknown attachment type: ${json['type']}'),
    };
  }
  Map<String, dynamic> toJson();
}

class FileAttachment extends Attachment {
  const FileAttachment({
    required this.id,
    required this.name,
    required this.mimeType,
    this.threadId,
    this.uploadDescriptor,
    this.metadata,
  });
  @override
  final String id;
  @override
  final String name;
  @override
  final String mimeType;
  @override
  String get type => 'file';
  @override
  final String? threadId;
  @override
  final AttachmentUploadDescriptor? uploadDescriptor;
  @override
  final Map<String, dynamic>? metadata;

  factory FileAttachment.fromJson(Map<String, dynamic> json) {
    return FileAttachment(
      id: json['id'] as String,
      name: json['name'] as String,
      mimeType: json['mime_type'] as String,
      threadId: json['thread_id'] as String?,
      uploadDescriptor: json['upload_descriptor'] != null
          ? AttachmentUploadDescriptor.fromJson(
              json['upload_descriptor'] as Map<String, dynamic>,)
          : null,
      metadata: json['metadata'] as Map<String, dynamic>?,
    );
  }

  @override
  Map<String, dynamic> toJson() => {
    'type': type,
    'id': id,
    'name': name,
    'mime_type': mimeType,
    if (threadId != null) 'thread_id': threadId,
    if (uploadDescriptor != null)
      'upload_descriptor': uploadDescriptor!.toJson(),
    if (metadata != null) 'metadata': metadata,
  };
}

class ImageAttachment extends Attachment {
  const ImageAttachment({
    required this.id,
    required this.name,
    required this.mimeType,
    this.previewUrl,
    this.threadId,
    this.uploadDescriptor,
    this.metadata,
  });
  @override
  final String id;
  @override
  final String name;
  @override
  final String mimeType;
  @override
  String get type => 'image';
  final String? previewUrl;
  @override
  final String? threadId;
  @override
  final AttachmentUploadDescriptor? uploadDescriptor;
  @override
  final Map<String, dynamic>? metadata;

  factory ImageAttachment.fromJson(Map<String, dynamic> json) {
    return ImageAttachment(
      id: json['id'] as String,
      name: json['name'] as String,
      mimeType: json['mime_type'] as String,
      previewUrl: json['preview_url'] as String?,
      threadId: json['thread_id'] as String?,
      uploadDescriptor: json['upload_descriptor'] != null
          ? AttachmentUploadDescriptor.fromJson(
              json['upload_descriptor'] as Map<String, dynamic>,)
          : null,
      metadata: json['metadata'] as Map<String, dynamic>?,
    );
  }

  @override
  Map<String, dynamic> toJson() => {
    'type': type,
    'id': id,
    'name': name,
    'mime_type': mimeType,
    if (previewUrl != null) 'preview_url': previewUrl,
    if (threadId != null) 'thread_id': threadId,
    if (uploadDescriptor != null)
      'upload_descriptor': uploadDescriptor!.toJson(),
    if (metadata != null) 'metadata': metadata,
  };
}
