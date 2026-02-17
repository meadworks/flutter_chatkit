import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../models/thread_item.dart';
import '../../theme/chat_kit_theme.dart';
import '../chat_kit_inherited.dart';
import 'feedback_button.dart';

/// Action bar for thread items (feedback, copy, retry)
class ThreadItemActionsBar extends StatelessWidget {
  const ThreadItemActionsBar({
    super.key,
    required this.item,
    this.copyText,
  });

  final ThreadItem item;
  final String? copyText;

  @override
  Widget build(BuildContext context) {
    final controller = ChatKitInherited.of(context);
    final theme = ChatKitTheme.of(context);
    final actions = controller.options.threadItemActions;

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        if (actions.showFeedback) ...[
          FeedbackButton(
            icon: Icons.thumb_up_outlined,
            tooltip: 'Good response',
            onPressed: () => controller.submitFeedback([item.id], 'positive'),
          ),
          SizedBox(width: theme.density.spacingSmall),
          FeedbackButton(
            icon: Icons.thumb_down_outlined,
            tooltip: 'Bad response',
            onPressed: () => controller.submitFeedback([item.id], 'negative'),
          ),
        ],
        if (actions.showCopy && copyText != null) ...[
          SizedBox(width: theme.density.spacingSmall),
          FeedbackButton(
            icon: Icons.copy,
            tooltip: 'Copy',
            onPressed: () {
              Clipboard.setData(ClipboardData(text: copyText!));
            },
          ),
        ],
        if (actions.showRetry) ...[
          SizedBox(width: theme.density.spacingSmall),
          FeedbackButton(
            icon: Icons.refresh,
            tooltip: 'Retry',
            onPressed: () => controller.retryFromItem(item.id),
          ),
        ],
      ],
    );
  }
}
