import '../models/annotation.dart';
import '../models/thread_item.dart';

/// Granular updates to thread items during streaming
sealed class ThreadItemUpdate {
  const ThreadItemUpdate();

  factory ThreadItemUpdate.fromJson(Map<String, dynamic> json) {
    return switch (json['type']) {
      'assistant_message.content_part.added' => AssistantMessageContentPartAdded.fromJson(json),
      'assistant_message.content_part.text.delta' => TextDelta.fromJson(json),
      'assistant_message.content_part.annotation.added' => AnnotationAdded.fromJson(json),
      'assistant_message.content_part.done' => ContentPartDone.fromJson(json),
      'widget.delta' => WidgetDelta.fromJson(json),
      'workflow.task.added' => WorkflowTaskAdded.fromJson(json),
      'workflow.task.updated' => WorkflowTaskUpdated.fromJson(json),
      'workflow.task.done' => WorkflowTaskDone.fromJson(json),
      'workflow.summary.updated' => WorkflowSummaryUpdated.fromJson(json),
      'workflow.expanded.updated' => WorkflowExpandedUpdated.fromJson(json),
      'generated_image.updated' => GeneratedImageUpdated.fromJson(json),
      _ => throw ArgumentError('Unknown update type: ${json['type']}'),
    };
  }
}

class AssistantMessageContentPartAdded extends ThreadItemUpdate {
  const AssistantMessageContentPartAdded({required this.partIndex, required this.part});
  final int partIndex;
  final AssistantMessageContent part;
  factory AssistantMessageContentPartAdded.fromJson(Map<String, dynamic> json) {
    return AssistantMessageContentPartAdded(
      partIndex: json['part_index'] as int,
      part: AssistantMessageContent.fromJson(json['part'] as Map<String, dynamic>),
    );
  }
}

class TextDelta extends ThreadItemUpdate {
  const TextDelta({required this.partIndex, required this.delta});
  final int partIndex;
  final String delta;
  factory TextDelta.fromJson(Map<String, dynamic> json) {
    return TextDelta(
      partIndex: json['part_index'] as int,
      delta: json['delta'] as String,
    );
  }
}

class AnnotationAdded extends ThreadItemUpdate {
  const AnnotationAdded({required this.partIndex, required this.annotation});
  final int partIndex;
  final Annotation annotation;
  factory AnnotationAdded.fromJson(Map<String, dynamic> json) {
    return AnnotationAdded(
      partIndex: json['part_index'] as int,
      annotation: Annotation.fromJson(json['annotation'] as Map<String, dynamic>),
    );
  }
}

class ContentPartDone extends ThreadItemUpdate {
  const ContentPartDone({required this.partIndex, required this.part});
  final int partIndex;
  final AssistantMessageContent part;
  factory ContentPartDone.fromJson(Map<String, dynamic> json) {
    return ContentPartDone(
      partIndex: json['part_index'] as int,
      part: AssistantMessageContent.fromJson(json['part'] as Map<String, dynamic>),
    );
  }
}

class WidgetDelta extends ThreadItemUpdate {
  const WidgetDelta({required this.delta});
  final Map<String, dynamic> delta;
  factory WidgetDelta.fromJson(Map<String, dynamic> json) {
    return WidgetDelta(delta: json['delta'] as Map<String, dynamic>);
  }
}

class WorkflowTaskAdded extends ThreadItemUpdate {
  const WorkflowTaskAdded({required this.taskIndex, required this.task});
  final int taskIndex;
  final Map<String, dynamic> task;
  factory WorkflowTaskAdded.fromJson(Map<String, dynamic> json) {
    return WorkflowTaskAdded(
      taskIndex: json['task_index'] as int,
      task: json['task'] as Map<String, dynamic>,
    );
  }
}

class WorkflowTaskUpdated extends ThreadItemUpdate {
  const WorkflowTaskUpdated({required this.taskIndex, required this.task});
  final int taskIndex;
  final Map<String, dynamic> task;
  factory WorkflowTaskUpdated.fromJson(Map<String, dynamic> json) {
    return WorkflowTaskUpdated(
      taskIndex: json['task_index'] as int,
      task: json['task'] as Map<String, dynamic>,
    );
  }
}

class WorkflowTaskDone extends ThreadItemUpdate {
  const WorkflowTaskDone({required this.taskIndex, required this.task});
  final int taskIndex;
  final Map<String, dynamic> task;
  factory WorkflowTaskDone.fromJson(Map<String, dynamic> json) {
    return WorkflowTaskDone(
      taskIndex: json['task_index'] as int,
      task: json['task'] as Map<String, dynamic>,
    );
  }
}

class WorkflowSummaryUpdated extends ThreadItemUpdate {
  const WorkflowSummaryUpdated({required this.summary});
  final Map<String, dynamic> summary;
  factory WorkflowSummaryUpdated.fromJson(Map<String, dynamic> json) {
    return WorkflowSummaryUpdated(
      summary: json['summary'] as Map<String, dynamic>,
    );
  }
}

class WorkflowExpandedUpdated extends ThreadItemUpdate {
  const WorkflowExpandedUpdated({required this.expanded});
  final bool expanded;
  factory WorkflowExpandedUpdated.fromJson(Map<String, dynamic> json) {
    return WorkflowExpandedUpdated(expanded: json['expanded'] as bool);
  }
}

class GeneratedImageUpdated extends ThreadItemUpdate {
  const GeneratedImageUpdated({required this.image});
  final Map<String, dynamic> image;
  factory GeneratedImageUpdated.fromJson(Map<String, dynamic> json) {
    return GeneratedImageUpdated(image: json['image'] as Map<String, dynamic>);
  }
}
