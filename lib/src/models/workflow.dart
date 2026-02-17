part of 'thread_item.dart';

// Task sealed class
sealed class Task {
  const Task();
  String get statusIndicator;
  factory Task.fromJson(Map<String, dynamic> json) {
    return switch (json['type']) {
      'custom' => CustomTask.fromJson(json),
      'web_search' => SearchTask.fromJson(json),
      'thought' => ThoughtTask.fromJson(json),
      'file' => FileTask.fromJson(json),
      'image' => ImageTask.fromJson(json),
      _ => throw ArgumentError('Unknown task type: ${json['type']}'),
    };
  }
  Map<String, dynamic> toJson();
}

class CustomTask extends Task {
  const CustomTask({
    required this.title,
    this.icon,
    this.content,
    this.statusIndicator = 'none',
  });
  final String title;
  final String? icon;
  final String? content;
  @override
  final String statusIndicator;

  factory CustomTask.fromJson(Map<String, dynamic> json) {
    return CustomTask(
      title: json['title'] as String,
      icon: json['icon'] as String?,
      content: json['content'] as String?,
      statusIndicator: json['status_indicator'] as String? ?? 'none',
    );
  }

  @override
  Map<String, dynamic> toJson() => {
    'type': 'custom',
    'title': title,
    if (icon != null) 'icon': icon,
    if (content != null) 'content': content,
    'status_indicator': statusIndicator,
  };
}

class SearchTask extends Task {
  const SearchTask({
    required this.title,
    this.titleQuery,
    this.queries = const [],
    this.sources = const [],
    this.statusIndicator = 'none',
  });
  final String title;
  final String? titleQuery;
  final List<String> queries;
  final List<Source> sources;
  @override
  final String statusIndicator;

  factory SearchTask.fromJson(Map<String, dynamic> json) {
    return SearchTask(
      title: json['title'] as String,
      titleQuery: json['title_query'] as String?,
      queries: (json['queries'] as List?)?.cast<String>() ?? const [],
      sources: (json['sources'] as List?)
              ?.map((s) => Source.fromJson(s as Map<String, dynamic>))
              .toList() ??
          const [],
      statusIndicator: json['status_indicator'] as String? ?? 'none',
    );
  }

  @override
  Map<String, dynamic> toJson() => {
    'type': 'web_search',
    'title': title,
    if (titleQuery != null) 'title_query': titleQuery,
    'queries': queries,
    'sources': sources.map((s) => s.toJson()).toList(),
    'status_indicator': statusIndicator,
  };
}

class ThoughtTask extends Task {
  const ThoughtTask({
    required this.title,
    this.content,
    this.statusIndicator = 'none',
  });
  final String title;
  final String? content;
  @override
  final String statusIndicator;

  factory ThoughtTask.fromJson(Map<String, dynamic> json) {
    return ThoughtTask(
      title: json['title'] as String,
      content: json['content'] as String?,
      statusIndicator: json['status_indicator'] as String? ?? 'none',
    );
  }

  @override
  Map<String, dynamic> toJson() => {
    'type': 'thought',
    'title': title,
    if (content != null) 'content': content,
    'status_indicator': statusIndicator,
  };
}

class FileTask extends Task {
  const FileTask({
    required this.title,
    this.sources = const [],
    this.statusIndicator = 'none',
  });
  final String title;
  final List<Source> sources;
  @override
  final String statusIndicator;

  factory FileTask.fromJson(Map<String, dynamic> json) {
    return FileTask(
      title: json['title'] as String,
      sources: (json['sources'] as List?)
              ?.map((s) => Source.fromJson(s as Map<String, dynamic>))
              .toList() ??
          const [],
      statusIndicator: json['status_indicator'] as String? ?? 'none',
    );
  }

  @override
  Map<String, dynamic> toJson() => {
    'type': 'file',
    'title': title,
    'sources': sources.map((s) => s.toJson()).toList(),
    'status_indicator': statusIndicator,
  };
}

class ImageTask extends Task {
  const ImageTask({
    required this.title,
    this.statusIndicator = 'none',
  });
  final String title;
  @override
  final String statusIndicator;

  factory ImageTask.fromJson(Map<String, dynamic> json) {
    return ImageTask(
      title: json['title'] as String,
      statusIndicator: json['status_indicator'] as String? ?? 'none',
    );
  }

  @override
  Map<String, dynamic> toJson() => {
    'type': 'image',
    'title': title,
    'status_indicator': statusIndicator,
  };
}

// Workflow summary
sealed class WorkflowSummary {
  const WorkflowSummary();
  factory WorkflowSummary.fromJson(Map<String, dynamic> json) {
    if (json.containsKey('duration')) {
      return DurationSummary(duration: json['duration'] as int);
    }
    return CustomSummary(
      title: json['title'] as String,
      icon: json['icon'] as String?,
    );
  }
  Map<String, dynamic> toJson();
}

class CustomSummary extends WorkflowSummary {
  const CustomSummary({required this.title, this.icon});
  final String title;
  final String? icon;
  @override
  Map<String, dynamic> toJson() => {
    'title': title,
    if (icon != null) 'icon': icon,
  };
}

class DurationSummary extends WorkflowSummary {
  const DurationSummary({required this.duration});
  final int duration;
  @override
  Map<String, dynamic> toJson() => {'duration': duration};
}

// Workflow model
class Workflow {
  const Workflow({
    this.workflowType = 'custom',
    this.tasks = const [],
    this.summary,
    this.expanded = false,
  });
  final String workflowType;
  final List<Task> tasks;
  final WorkflowSummary? summary;
  final bool expanded;

  factory Workflow.fromJson(Map<String, dynamic> json) {
    return Workflow(
      workflowType: json['type'] as String? ?? 'custom',
      tasks: (json['tasks'] as List?)
              ?.map((t) => Task.fromJson(t as Map<String, dynamic>))
              .toList() ??
          const [],
      summary: json['summary'] != null
          ? WorkflowSummary.fromJson(
              json['summary'] as Map<String, dynamic>,
            )
          : null,
      expanded: json['expanded'] as bool? ?? false,
    );
  }

  Map<String, dynamic> toJson() => {
    'type': workflowType,
    'tasks': tasks.map((t) => t.toJson()).toList(),
    if (summary != null) 'summary': summary!.toJson(),
    'expanded': expanded,
  };
}

// WorkflowItem
class WorkflowItem extends ThreadItem {
  const WorkflowItem({
    required this.id,
    required this.threadId,
    required this.createdAt,
    required this.workflow,
  });
  @override
  final String id;
  @override
  final String threadId;
  @override
  final DateTime createdAt;
  @override
  String get type => 'workflow';
  final Workflow workflow;

  factory WorkflowItem.fromJson(Map<String, dynamic> json) {
    return WorkflowItem(
      id: json['id'] as String,
      threadId: json['thread_id'] as String,
      createdAt: DateTime.parse(json['created_at'] as String),
      workflow: Workflow.fromJson(json['workflow'] as Map<String, dynamic>),
    );
  }

  @override
  Map<String, dynamic> toJson() => {
    'type': type,
    'id': id,
    'thread_id': threadId,
    'created_at': createdAt.toIso8601String(),
    'workflow': workflow.toJson(),
  };
}
