import 'package:flutter/widgets.dart';
import '../../models/thread_item.dart';
import '../../theme/chat_kit_theme.dart';
import '../primitives/chatkit_icons.dart';
import '../primitives/chatkit_primitives.dart';

/// Displays a thought/reasoning task with expandable content
class ReasoningWidget extends StatefulWidget {
  const ReasoningWidget({super.key, required this.task});

  final ThoughtTask task;

  @override
  State<ReasoningWidget> createState() => _ReasoningWidgetState();
}

class _ReasoningWidgetState extends State<ReasoningWidget> {
  bool _expanded = false;

  @override
  Widget build(BuildContext context) {
    final theme = ChatKitTheme.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ChatKitTappable(
          onTap: widget.task.content != null
              ? () => setState(() => _expanded = !_expanded)
              : null,
          child: Row(
            children: [
              Icon(ChatKitIcons.psychology, size: 16, color: theme.colorScheme.onSurfaceVariant),
              SizedBox(width: theme.density.spacingSmall),
              Expanded(
                child: Text(
                  widget.task.title,
                  style: theme.typography.bodySmall.copyWith(
                    color: theme.colorScheme.onSurfaceVariant,
                    fontStyle: FontStyle.italic,
                  ),
                ),
              ),
              if (widget.task.content != null)
                Icon(
                  _expanded ? ChatKitIcons.expandLess : ChatKitIcons.expandMore,
                  size: 16,
                  color: theme.colorScheme.onSurfaceVariant,
                ),
            ],
          ),
        ),
        if (_expanded && widget.task.content != null) ...[
          SizedBox(height: theme.density.spacingSmall),
          Container(
            padding: EdgeInsets.all(theme.density.paddingMedium),
            decoration: BoxDecoration(
              color: theme.colorScheme.surface,
              borderRadius: theme.radius.smallBorderRadius,
            ),
            child: Text(
              widget.task.content!,
              style: theme.typography.bodySmall.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
              ),
            ),
          ),
        ],
      ],
    );
  }
}
