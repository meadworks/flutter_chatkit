import 'package:flutter/material.dart';
import '../../theme/chat_kit_theme.dart';
import '../chat_kit_inherited.dart';

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
          return Chip(
            label: Text(
              attachment.name,
              style: theme.typography.labelMedium.copyWith(
                color: theme.colorScheme.onSurface,
              ),
            ),
            deleteIcon: Icon(Icons.close, size: 16, color: theme.colorScheme.onSurfaceVariant),
            onDeleted: () => controller.messageController.removeAttachment(attachment.id),
            backgroundColor: theme.colorScheme.surfaceVariant,
            shape: RoundedRectangleBorder(
              borderRadius: theme.radius.mediumBorderRadius,
            ),
          );
        },
      ),
    );
  }
}
