import 'package:flutter/widgets.dart';
import '../../theme/chat_kit_theme.dart';
import '../primitives/chatkit_primitives.dart';

/// A chip that displays a suggested prompt
class PromptChip extends StatelessWidget {
  const PromptChip({
    super.key,
    required this.label,
    this.onTap,
  });

  final String label;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final theme = ChatKitTheme.of(context);

    return ChatKitTappable(
      onTap: onTap,
      color: theme.colorScheme.surfaceVariant,
      borderRadius: theme.radius.fullBorderRadius,
      child: Padding(
        padding: EdgeInsets.symmetric(
          horizontal: theme.density.paddingExtraLarge,
          vertical: theme.density.paddingMedium,
        ),
        child: Text(
          label,
          style: theme.typography.bodyMedium.copyWith(
            color: theme.colorScheme.onSurface,
          ),
        ),
      ),
    );
  }
}
