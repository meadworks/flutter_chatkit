import 'package:flutter/widgets.dart';
import '../../models/thread.dart';
import '../../theme/chat_kit_theme.dart';
import '../primitives/chatkit_primitives.dart';
import 'package:intl/intl.dart';

/// A tile representing a thread in the history panel
class ThreadListTile extends StatelessWidget {
  const ThreadListTile({
    super.key,
    required this.metadata,
    this.isActive = false,
    this.onTap,
  });

  final ThreadMetadata metadata;
  final bool isActive;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final theme = ChatKitTheme.of(context);

    return ChatKitTappable(
      onTap: onTap,
      color: isActive ? theme.colorScheme.secondary : const Color(0x00000000),
      child: Padding(
        padding: EdgeInsets.symmetric(
          horizontal: theme.density.paddingLarge,
          vertical: theme.density.paddingMedium,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              metadata.title ?? 'Untitled',
              style: theme.typography.bodyMedium.copyWith(
                color: isActive
                    ? theme.colorScheme.onSecondary
                    : theme.colorScheme.onSurface,
                fontWeight: isActive ? FontWeight.w600 : FontWeight.w400,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            SizedBox(height: theme.density.spacingSmall),
            Text(
              DateFormat.MMMd().add_jm().format(metadata.createdAt),
              style: theme.typography.labelSmall.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
