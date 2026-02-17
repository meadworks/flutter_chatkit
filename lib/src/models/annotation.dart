sealed class Source {
  const Source();
  String? get title;
  String? get description;
  String? get timestamp;
  String? get group;

  factory Source.fromJson(Map<String, dynamic> json) {
    return switch (json['type']) {
      'url' => UrlSource.fromJson(json),
      'file' => FileSource.fromJson(json),
      'entity' => EntitySource.fromJson(json),
      _ => throw ArgumentError('Unknown source type: ${json['type']}'),
    };
  }
  Map<String, dynamic> toJson();
}

class UrlSource extends Source {
  const UrlSource({
    required this.url,
    this.title,
    this.description,
    this.timestamp,
    this.group,
    this.attribution,
  });
  final String url;
  @override
  final String? title;
  @override
  final String? description;
  @override
  final String? timestamp;
  @override
  final String? group;
  final String? attribution;

  factory UrlSource.fromJson(Map<String, dynamic> json) {
    return UrlSource(
      url: json['url'] as String,
      title: json['title'] as String?,
      description: json['description'] as String?,
      timestamp: json['timestamp'] as String?,
      group: json['group'] as String?,
      attribution: json['attribution'] as String?,
    );
  }

  @override
  Map<String, dynamic> toJson() => {
    'type': 'url',
    'url': url,
    if (title != null) 'title': title,
    if (description != null) 'description': description,
    if (timestamp != null) 'timestamp': timestamp,
    if (group != null) 'group': group,
    if (attribution != null) 'attribution': attribution,
  };
}

class FileSource extends Source {
  const FileSource({
    required this.filename,
    this.title,
    this.description,
    this.timestamp,
    this.group,
  });
  final String filename;
  @override
  final String? title;
  @override
  final String? description;
  @override
  final String? timestamp;
  @override
  final String? group;

  factory FileSource.fromJson(Map<String, dynamic> json) {
    return FileSource(
      filename: json['filename'] as String,
      title: json['title'] as String?,
      description: json['description'] as String?,
      timestamp: json['timestamp'] as String?,
      group: json['group'] as String?,
    );
  }

  @override
  Map<String, dynamic> toJson() => {
    'type': 'file',
    'filename': filename,
    if (title != null) 'title': title,
    if (description != null) 'description': description,
    if (timestamp != null) 'timestamp': timestamp,
    if (group != null) 'group': group,
  };
}

class EntitySource extends Source {
  const EntitySource({
    required this.entityId,
    this.title,
    this.description,
    this.timestamp,
    this.group,
    this.icon,
    this.label,
    this.inlineLabel,
    this.interactive = false,
    this.data,
  });
  final String entityId;
  @override
  final String? title;
  @override
  final String? description;
  @override
  final String? timestamp;
  @override
  final String? group;
  final String? icon;
  final String? label;
  final String? inlineLabel;
  final bool interactive;
  final Map<String, dynamic>? data;

  factory EntitySource.fromJson(Map<String, dynamic> json) {
    return EntitySource(
      entityId: json['id'] as String,
      title: json['title'] as String?,
      description: json['description'] as String?,
      timestamp: json['timestamp'] as String?,
      group: json['group'] as String?,
      icon: json['icon'] as String?,
      label: json['label'] as String?,
      inlineLabel: json['inline_label'] as String?,
      interactive: json['interactive'] as bool? ?? false,
      data: json['data'] as Map<String, dynamic>?,
    );
  }

  @override
  Map<String, dynamic> toJson() => {
    'type': 'entity',
    'id': entityId,
    if (title != null) 'title': title,
    if (description != null) 'description': description,
    if (timestamp != null) 'timestamp': timestamp,
    if (group != null) 'group': group,
    if (icon != null) 'icon': icon,
    if (label != null) 'label': label,
    if (inlineLabel != null) 'inline_label': inlineLabel,
    'interactive': interactive,
    if (data != null) 'data': data,
  };
}

class Annotation {
  const Annotation({
    required this.type,
    required this.source,
    this.index,
  });
  final String type;
  final Source source;
  final int? index;

  factory Annotation.fromJson(Map<String, dynamic> json) {
    return Annotation(
      type: json['type'] as String,
      source: Source.fromJson(json['source'] as Map<String, dynamic>),
      index: json['index'] as int?,
    );
  }

  Map<String, dynamic> toJson() => {
    'type': type,
    'source': source.toJson(),
    if (index != null) 'index': index,
  };
}
