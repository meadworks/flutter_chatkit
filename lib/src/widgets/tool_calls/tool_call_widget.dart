import 'package:flutter/material.dart';
import '../../models/thread_item.dart';
import '../../theme/chat_kit_theme.dart';
import '../../theme/chat_kit_theme_data.dart';

/// Displays a client tool call
class ToolCallWidget extends StatelessWidget {
  const ToolCallWidget({super.key, required this.item});

  final ClientToolCallItem item;

  IconData get _statusIcon => switch (item.status) {
    ToolCallStatus.pending => Icons.hourglass_empty,
    ToolCallStatus.completed => Icons.check_circle,
    ToolCallStatus.failed => Icons.error,
  };

  Color _statusColor(ChatKitThemeData theme) => switch (item.status) {
    ToolCallStatus.pending => theme.colorScheme.onSurfaceVariant,
    ToolCallStatus.completed => theme.colorScheme.primary,
    ToolCallStatus.failed => theme.colorScheme.error,
  };

  @override
  Widget build(BuildContext context) {
    final theme = ChatKitTheme.of(context);

    return Container(
      padding: EdgeInsets.all(theme.density.paddingLarge),
      decoration: BoxDecoration(
        color: theme.colorScheme.surfaceVariant,
        borderRadius: theme.radius.mediumBorderRadius,
      ),
      child: Row(
        children: [
          Icon(_statusIcon, size: 20, color: _statusColor(theme)),
          SizedBox(width: theme.density.spacingMedium),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  item.name,
                  style: theme.typography.labelLarge.copyWith(
                    color: theme.colorScheme.onSurface,
                  ),
                ),
                if (item.status == ToolCallStatus.pending)
                  Padding(
                    padding: EdgeInsets.only(top: theme.density.spacingSmall),
                    child: Text(
                      'Running...',
                      style: theme.typography.bodySmall.copyWith(
                        color: theme.colorScheme.onSurfaceVariant,
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
