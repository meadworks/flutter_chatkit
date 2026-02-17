import 'package:flutter/material.dart';
import '../../theme/chat_kit_theme.dart';

/// Displays an error message in the chat
class ErrorMessageWidget extends StatelessWidget {
  const ErrorMessageWidget({
    super.key,
    required this.message,
    this.allowRetry = false,
    this.onRetry,
  });

  final String message;
  final bool allowRetry;
  final VoidCallback? onRetry;

  @override
  Widget build(BuildContext context) {
    final theme = ChatKitTheme.of(context);

    return Container(
      padding: EdgeInsets.all(theme.density.paddingLarge),
      margin: EdgeInsets.symmetric(horizontal: theme.density.paddingExtraLarge),
      decoration: BoxDecoration(
        color: theme.colorScheme.error.withValues(alpha: 0.1),
        borderRadius: theme.radius.mediumBorderRadius,
        border: Border.all(color: theme.colorScheme.error.withValues(alpha: 0.3)),
      ),
      child: Row(
        children: [
          Icon(Icons.error_outline, color: theme.colorScheme.error, size: 20),
          SizedBox(width: theme.density.spacingMedium),
          Expanded(
            child: Text(
              message,
              style: theme.typography.bodyMedium.copyWith(
                color: theme.colorScheme.error,
              ),
            ),
          ),
          if (allowRetry && onRetry != null)
            TextButton(
              onPressed: onRetry,
              child: Text(
                'Retry',
                style: theme.typography.labelLarge.copyWith(
                  color: theme.colorScheme.error,
                ),
              ),
            ),
        ],
      ),
    );
  }
}
