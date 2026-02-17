import 'package:flutter/material.dart';
import '../../models/thread_item.dart';
import '../../theme/chat_kit_theme.dart';
import 'message_bubble.dart';

/// Displays a user message
class UserMessageWidget extends StatelessWidget {
  const UserMessageWidget({super.key, required this.item});

  final UserMessageItem item;

  @override
  Widget build(BuildContext context) {
    final theme = ChatKitTheme.of(context);

    return MessageBubble(
      isUser: true,
      child: Text(
        item.plainText,
        style: theme.typography.bodyLarge.copyWith(
          color: theme.colorScheme.onUserBubble,
        ),
      ),
    );
  }
}
