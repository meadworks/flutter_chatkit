import 'package:flutter/widgets.dart';
import '../../theme/chat_kit_theme.dart';
import '../chat_kit_inherited.dart';
import 'composer_text_field.dart';
import 'attachment_bar.dart';
import 'send_button.dart';

/// The message composer area
class Composer extends StatelessWidget {
  const Composer({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = ChatKitInherited.of(context);
    final theme = ChatKitTheme.of(context);

    return Container(
      decoration: BoxDecoration(
        color: theme.colorScheme.composerBackground,
        border: Border(
          top: BorderSide(color: theme.colorScheme.outline, width: 0.5),
        ),
      ),
      child: SafeArea(
        top: false,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (controller.messageController.pendingAttachments.isNotEmpty)
              const AttachmentBar(),
            Padding(
              padding: EdgeInsets.all(theme.density.composerPadding),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const Expanded(child: ComposerTextField()),
                  SizedBox(width: theme.density.spacingMedium),
                  const SendButton(),
                ],
              ),
            ),
            if (controller.options.disclaimer.enabled &&
                controller.options.disclaimer.text != null)
              Padding(
                padding: EdgeInsets.only(
                  bottom: theme.density.paddingMedium,
                  left: theme.density.composerPadding,
                  right: theme.density.composerPadding,
                ),
                child: Text(
                  controller.options.disclaimer.text!,
                  style: theme.typography.labelSmall.copyWith(
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
          ],
        ),
      ),
    );
  }
}
