import 'package:flutter/material.dart';
import '../../theme/chat_kit_theme.dart';

/// A small icon button for thread item actions
class FeedbackButton extends StatelessWidget {
  const FeedbackButton({
    super.key,
    required this.icon,
    required this.tooltip,
    this.onPressed,
  });

  final IconData icon;
  final String tooltip;
  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    final theme = ChatKitTheme.of(context);

    return SizedBox(
      width: 28,
      height: 28,
      child: IconButton(
        onPressed: onPressed,
        icon: Icon(icon, size: 16),
        color: theme.colorScheme.onSurfaceVariant,
        tooltip: tooltip,
        padding: EdgeInsets.zero,
        constraints: const BoxConstraints(),
        splashRadius: 14,
      ),
    );
  }
}
