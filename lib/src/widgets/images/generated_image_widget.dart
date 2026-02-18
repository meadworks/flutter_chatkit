import 'package:flutter/widgets.dart';
import '../../models/thread_item.dart';
import '../../theme/chat_kit_theme.dart';
import '../primitives/chatkit_icons.dart';
import '../primitives/chatkit_primitives.dart';

/// Displays a generated image
class GeneratedImageWidget extends StatelessWidget {
  const GeneratedImageWidget({super.key, required this.item});

  final GeneratedImageItem item;

  @override
  Widget build(BuildContext context) {
    final theme = ChatKitTheme.of(context);

    if (item.image.url == null) {
      // Image still generating
      return Container(
        width: 256,
        height: 256,
        decoration: BoxDecoration(
          color: theme.colorScheme.surfaceVariant,
          borderRadius: theme.radius.mediumBorderRadius,
        ),
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ChatKitSpinner(
                color: theme.colorScheme.primary,
              ),
              SizedBox(height: theme.density.spacingMedium),
              Text(
                'Generating image...',
                style: theme.typography.bodySmall.copyWith(
                  color: theme.colorScheme.onSurfaceVariant,
                ),
              ),
            ],
          ),
        ),
      );
    }

    return ClipRRect(
      borderRadius: theme.radius.mediumBorderRadius,
      child: Image.network(
        item.image.url!,
        width: 400,
        fit: BoxFit.contain,
        loadingBuilder: (context, child, loadingProgress) {
          if (loadingProgress == null) return child;
          return Container(
            width: 400,
            height: 300,
            color: theme.colorScheme.surfaceVariant,
            child: Center(
              child: ChatKitSpinner(
                value: loadingProgress.expectedTotalBytes != null
                    ? loadingProgress.cumulativeBytesLoaded /
                        loadingProgress.expectedTotalBytes!
                    : null,
                color: theme.colorScheme.primary,
              ),
            ),
          );
        },
        errorBuilder: (context, error, stackTrace) {
          return Container(
            width: 400,
            height: 200,
            decoration: BoxDecoration(
              color: theme.colorScheme.surfaceVariant,
              borderRadius: theme.radius.mediumBorderRadius,
            ),
            child: Center(
              child: Icon(
                ChatKitIcons.brokenImage,
                color: theme.colorScheme.onSurfaceVariant,
              ),
            ),
          );
        },
      ),
    );
  }
}
