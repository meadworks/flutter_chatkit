import 'package:flutter/material.dart';
import '../../theme/chat_kit_theme.dart';

/// Displays a progress indicator for streaming operations
class ProgressIndicatorWidget extends StatelessWidget {
  const ProgressIndicatorWidget({
    super.key,
    this.icon,
    this.text,
  });

  final String? icon;
  final String? text;

  @override
  Widget build(BuildContext context) {
    final theme = ChatKitTheme.of(context);

    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: theme.density.paddingExtraLarge,
        vertical: theme.density.paddingMedium,
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(
            width: 16,
            height: 16,
            child: CircularProgressIndicator(
              strokeWidth: 2,
              color: theme.colorScheme.primary,
            ),
          ),
          if (text != null) ...[
            SizedBox(width: theme.density.spacingMedium),
            Text(
              text!,
              style: theme.typography.bodySmall.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
              ),
            ),
          ],
        ],
      ),
    );
  }
}
