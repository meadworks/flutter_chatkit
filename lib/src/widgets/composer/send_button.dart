import 'package:flutter/material.dart';
import '../../theme/chat_kit_theme.dart';
import '../chat_kit_inherited.dart';

/// Send / Cancel button in the composer
class SendButton extends StatelessWidget {
  const SendButton({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = ChatKitInherited.of(context);
    final theme = ChatKitTheme.of(context);

    if (controller.isStreamActive) {
      return IconButton(
        onPressed: controller.cancelStream,
        icon: Container(
          width: 36,
          height: 36,
          decoration: BoxDecoration(
            color: theme.colorScheme.error,
            shape: BoxShape.circle,
          ),
          child: Icon(
            Icons.stop,
            color: theme.colorScheme.onError,
            size: 20,
          ),
        ),
        tooltip: 'Stop generating',
      );
    }

    final canSend = controller.canSend && !controller.isSending;

    return IconButton(
      onPressed: canSend ? () {
        controller.send();
      } : null,
      icon: Container(
        width: 36,
        height: 36,
        decoration: BoxDecoration(
          color: canSend ? theme.colorScheme.primary : theme.colorScheme.surfaceVariant,
          shape: BoxShape.circle,
        ),
        child: Icon(
          Icons.arrow_upward,
          color: canSend ? theme.colorScheme.onPrimary : theme.colorScheme.onSurfaceVariant,
          size: 20,
        ),
      ),
      tooltip: 'Send message',
    );
  }
}
