import 'package:flutter/widgets.dart';
import '../../theme/chat_kit_theme.dart';
import '../chat_kit_inherited.dart';
import '../primitives/chatkit_icons.dart';

/// Displays pending attachments in the composer
class AttachmentBar extends StatelessWidget {
  const AttachmentBar({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = ChatKitInherited.of(context);
    final theme = ChatKitTheme.of(context);
    final attachments = controller.messageController.pendingAttachments;

    return Container(
      height: 64,
      padding: EdgeInsets.symmetric(
        horizontal: theme.density.composerPadding,
        vertical: theme.density.paddingSmall,
      ),
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: attachments.length,
        separatorBuilder: (_, __) => SizedBox(width: theme.density.spacingMedium),
        itemBuilder: (context, index) {
          final attachment = attachments[index];
          return Container(
            padding: EdgeInsets.symmetric(
              horizontal: theme.density.paddingMedium,
              vertical: theme.density.paddingSmall,
            ),
            decoration: BoxDecoration(
              color: theme.colorScheme.surfaceVariant,
              borderRadius: theme.radius.mediumBorderRadius,
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  attachment.name,
                  style: theme.typography.labelMedium.copyWith(
                    color: theme.colorScheme.onSurface,
                  ),
                ),
                SizedBox(width: theme.density.spacingSmall),
                GestureDetector(
                  onTap: () => controller.messageController.removeAttachment(attachment.id),
                  child: Icon(ChatKitIcons.close, size: 16, color: theme.colorScheme.onSurfaceVariant),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
