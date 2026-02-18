import 'package:flutter/widgets.dart';
import '../../theme/chat_kit_theme.dart';
import '../chat_kit_inherited.dart';
import '../primitives/chatkit_icons.dart';
import '../primitives/chatkit_primitives.dart';

/// Send / Cancel button in the composer
class SendButton extends StatelessWidget {
  const SendButton({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = ChatKitInherited.of(context);
    final theme = ChatKitTheme.of(context);
    final composerOptions = controller.options.composer;

    if (controller.isStreamActive) {
      return ChatKitIconButton(
        onPressed: controller.cancelStream,
        tooltip: 'Stop generating',
        icon: Container(
          width: 36,
          height: 36,
          decoration: BoxDecoration(
            color: theme.colorScheme.error,
            shape: BoxShape.circle,
          ),
          child: Icon(
            composerOptions.cancelIcon ?? ChatKitIcons.stop,
            color: theme.colorScheme.onError,
            size: 20,
          ),
        ),
      );
    }

    final canSend = controller.canSend && !controller.isSending;

    return ChatKitIconButton(
      onPressed: canSend ? () {
        controller.send();
      } : null,
      tooltip: 'Send message',
      icon: Opacity(
        opacity: canSend ? 1.0 : 0.4,
        child: Container(
          width: 36,
          height: 36,
          decoration: BoxDecoration(
            color: theme.colorScheme.primary,
            shape: BoxShape.circle,
          ),
          child: Icon(
            composerOptions.sendIcon ?? ChatKitIcons.arrowUpward,
            color: theme.colorScheme.onPrimary,
            size: 20,
          ),
        ),
      ),
    );
  }
}
