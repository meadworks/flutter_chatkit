import 'package:flutter/material.dart';
import '../../theme/chat_kit_theme.dart';
import '../chat_kit_inherited.dart';

/// The header bar with title and controls
class ChatKitHeaderBar extends StatelessWidget {
  const ChatKitHeaderBar({
    super.key,
    this.onHistoryToggle,
    this.isHistoryOpen = false,
  });

  final VoidCallback? onHistoryToggle;
  final bool isHistoryOpen;

  @override
  Widget build(BuildContext context) {
    final controller = ChatKitInherited.of(context);
    final theme = ChatKitTheme.of(context);
    final options = controller.options.header;

    return Container(
      height: theme.density.headerHeight,
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        border: Border(
          bottom: BorderSide(color: theme.colorScheme.outline, width: 0.5),
        ),
      ),
      padding: EdgeInsets.symmetric(horizontal: theme.density.paddingExtraLarge),
      child: Row(
        children: [
          if (options.showHistoryButton && onHistoryToggle != null)
            IconButton(
              icon: Icon(
                isHistoryOpen ? Icons.menu_open : Icons.menu,
                color: theme.colorScheme.onSurface,
              ),
              onPressed: onHistoryToggle,
              tooltip: isHistoryOpen ? 'Close history' : 'Open history',
            ),
          if (options.showTitle) ...[
            SizedBox(width: theme.density.spacingMedium),
            Expanded(
              child: Text(
                options.title ?? controller.activeThread?.title ?? 'New chat',
                style: theme.typography.headingSmall.copyWith(
                  color: theme.colorScheme.onSurface,
                ),
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ] else
            const Spacer(),
          IconButton(
            icon: Icon(Icons.add, color: theme.colorScheme.onSurface),
            onPressed: controller.startNewThread,
            tooltip: 'New chat',
          ),
        ],
      ),
    );
  }
}
