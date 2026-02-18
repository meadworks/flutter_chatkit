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
            ChatKitIcons.stop,
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
      icon: Container(
        width: 36,
        height: 36,
        decoration: BoxDecoration(
          color: canSend ? theme.colorScheme.primary : theme.colorScheme.surfaceVariant,
          shape: BoxShape.circle,
        ),
        child: Icon(
          ChatKitIcons.arrowUpward,
          color: canSend ? theme.colorScheme.onPrimary : theme.colorScheme.onSurfaceVariant,
          size: 20,
        ),
      ),
    );
  }
}
