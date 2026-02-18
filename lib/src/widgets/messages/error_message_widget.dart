import 'package:flutter/widgets.dart';
import '../../theme/chat_kit_theme.dart';
import '../primitives/chatkit_icons.dart';
import '../primitives/chatkit_primitives.dart';

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
          Icon(ChatKitIcons.errorOutline, color: theme.colorScheme.error, size: 20),
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
            ChatKitTappable(
              onTap: onRetry,
              borderRadius: theme.radius.smallBorderRadius,
              child: Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: theme.density.paddingMedium,
                  vertical: theme.density.paddingSmall,
                ),
                child: Text(
                  'Retry',
                  style: theme.typography.labelLarge.copyWith(
                    color: theme.colorScheme.error,
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
