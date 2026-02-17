import 'annotation.dart';
import 'attachment.dart';
import 'inference_options.dart';

part 'user_message.dart';
part 'assistant_message.dart';
part 'tool_call.dart';
part 'widget_item.dart';
part 'workflow.dart';
part 'generated_image.dart';
part 'end_of_turn.dart';

/// Base fields shared by all thread items
abstract class ThreadItemBase {
  String get id;
  String get threadId;
  DateTime get createdAt;
  String get type;
  Map<String, dynamic> toJson();
}

/// Sealed class for all thread item types
sealed class ThreadItem implements ThreadItemBase {
  const ThreadItem();

  factory ThreadItem.fromJson(Map<String, dynamic> json) {
    return switch (json['type']) {
      'user_message' => UserMessageItem.fromJson(json),
      'assistant_message' => AssistantMessageItem.fromJson(json),
      'tool_call' => ClientToolCallItem.fromJson(json),
      'widget' => WidgetItem.fromJson(json),
      'workflow' => WorkflowItem.fromJson(json),
      'generated_image' => GeneratedImageItem.fromJson(json),
      'end_of_turn' => EndOfTurnItem.fromJson(json),
      _ => throw ArgumentError('Unknown thread item type: ${json['type']}'),
    };
  }
}
