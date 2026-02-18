import 'package:flutter/widgets.dart';
import '../../theme/chat_kit_theme.dart';
import '../chat_kit_inherited.dart';
import '../primitives/chatkit_icons.dart';
import '../primitives/chatkit_primitives.dart';
import 'thread_list_tile.dart';

/// The history panel showing thread list
class HistoryPanel extends StatelessWidget {
  const HistoryPanel({super.key, this.onClose});

  final VoidCallback? onClose;

  @override
  Widget build(BuildContext context) {
    final controller = ChatKitInherited.of(context);
    final theme = ChatKitTheme.of(context);
    final threads = controller.threads;

    return Container(
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        border: Border(
          right: BorderSide(color: theme.colorScheme.outline, width: 0.5),
        ),
      ),
      child: Column(
        children: [
          // Panel header
          Container(
            height: theme.density.headerHeight,
            padding: EdgeInsets.symmetric(horizontal: theme.density.paddingLarge),
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    'History',
                    style: theme.typography.headingSmall.copyWith(
                      color: theme.colorScheme.onSurface,
                    ),
                  ),
                ),
                ChatKitIconButton(
                  icon: Icon(ChatKitIcons.close, size: 20, color: theme.colorScheme.onSurfaceVariant),
                  onPressed: onClose,
                  size: 32,
                ),
              ],
            ),
          ),
          ChatKitDivider(height: 1, color: theme.colorScheme.outline),
          // Thread list
          Expanded(
            child: threads.isEmpty
                ? Center(
                    child: Text(
                      'No conversations yet',
                      style: theme.typography.bodyMedium.copyWith(
                        color: theme.colorScheme.onSurfaceVariant,
                      ),
                    ),
                  )
                : NotificationListener<ScrollNotification>(
                    onNotification: (notification) {
                      if (notification is ScrollEndNotification &&
                          notification.metrics.extentAfter < 100 &&
                          controller.threadController.hasMoreThreads) {
                        controller.loadMoreThreads();
                      }
                      return false;
                    },
                    child: ListView.builder(
                      itemCount: threads.length,
                      itemBuilder: (context, index) {
                        return ThreadListTile(
                          metadata: threads[index],
                          isActive: threads[index].id == controller.activeThreadId,
                          onTap: () => controller.selectThread(threads[index].id),
                        );
                      },
                    ),
                  ),
          ),
        ],
      ),
    );
  }
}
