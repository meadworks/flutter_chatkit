part of 'thread_item.dart';

class GeneratedImage {
  const GeneratedImage({required this.id, this.url});
  final String id;
  final String? url;

  factory GeneratedImage.fromJson(Map<String, dynamic> json) {
    return GeneratedImage(
      id: json['id'] as String,
      url: json['url'] as String?,
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    if (url != null) 'url': url,
  };
}

class GeneratedImageItem extends ThreadItem {
  const GeneratedImageItem({
    required this.id,
    required this.threadId,
    required this.createdAt,
    required this.image,
  });
  @override
  final String id;
  @override
  final String threadId;
  @override
  final DateTime createdAt;
  @override
  String get type => 'generated_image';
  final GeneratedImage image;

  factory GeneratedImageItem.fromJson(Map<String, dynamic> json) {
    return GeneratedImageItem(
      id: json['id'] as String,
      threadId: json['thread_id'] as String,
      createdAt: DateTime.parse(json['created_at'] as String),
      image: GeneratedImage.fromJson(json['image'] as Map<String, dynamic>),
    );
  }

  @override
  Map<String, dynamic> toJson() => {
    'type': type,
    'id': id,
    'thread_id': threadId,
    'created_at': createdAt.toIso8601String(),
    'image': image.toJson(),
  };
}
