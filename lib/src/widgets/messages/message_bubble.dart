import 'package:flutter/material.dart';
import '../../theme/chat_kit_theme.dart';

/// A message bubble wrapper
class MessageBubble extends StatelessWidget {
  const MessageBubble({
    super.key,
    required this.child,
    this.isUser = false,
    this.maxWidth = 680,
  });

  final Widget child;
  final bool isUser;
  final double maxWidth;

  @override
  Widget build(BuildContext context) {
    final theme = ChatKitTheme.of(context);

    return Align(
      alignment: isUser ? Alignment.centerRight : Alignment.centerLeft,
      child: ConstrainedBox(
        constraints: BoxConstraints(maxWidth: maxWidth),
        child: Container(
          padding: EdgeInsets.symmetric(
            horizontal: theme.density.messagePaddingHorizontal,
            vertical: theme.density.messagePaddingVertical,
          ),
          decoration: BoxDecoration(
            color: isUser
                ? theme.colorScheme.userBubble
                : theme.colorScheme.assistantBubble,
            borderRadius: BorderRadius.all(theme.radius.messageBubble),
          ),
          child: child,
        ),
      ),
    );
  }
}
