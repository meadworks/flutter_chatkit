import 'package:flutter/widgets.dart';
import '../../models/thread_item.dart';
import '../../theme/chat_kit_theme.dart';
import '../../theme/chat_kit_theme_data.dart';
import '../primitives/chatkit_icons.dart';
import '../primitives/chatkit_primitives.dart';

/// Displays a single workflow task
class TaskWidget extends StatelessWidget {
  const TaskWidget({super.key, required this.task});

  final Task task;

  IconData get _icon => switch (task) {
    CustomTask() => ChatKitIcons.taskAlt,
    SearchTask() => ChatKitIcons.search,
    ThoughtTask() => ChatKitIcons.psychology,
    FileTask() => ChatKitIcons.description,
    ImageTask() => ChatKitIcons.image,
  };

  String get _title => switch (task) {
    CustomTask(:final title) => title,
    SearchTask(:final title) => title,
    ThoughtTask(:final title) => title,
    FileTask(:final title) => title,
    ImageTask(:final title) => title,
  };

  Widget _statusWidget(ChatKitThemeData theme) {
    return switch (task.statusIndicator) {
      'loading' => ChatKitSpinner(
          size: 14,
          strokeWidth: 2,
          color: theme.colorScheme.primary,
        ),
      'complete' => Icon(ChatKitIcons.check, size: 14, color: theme.colorScheme.primary),
      _ => const SizedBox(width: 14, height: 14),
    };
  }

  @override
  Widget build(BuildContext context) {
    final theme = ChatKitTheme.of(context);

    return Row(
      children: [
        _statusWidget(theme),
        SizedBox(width: theme.density.spacingMedium),
        Icon(_icon, size: 16, color: theme.colorScheme.onSurfaceVariant),
        SizedBox(width: theme.density.spacingSmall),
        Expanded(
          child: Text(
            _title,
            style: theme.typography.bodySmall.copyWith(
              color: theme.colorScheme.onSurface,
            ),
          ),
        ),
      ],
    );
  }
}
