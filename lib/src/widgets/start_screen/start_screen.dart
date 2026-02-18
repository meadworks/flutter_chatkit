import 'package:flutter/widgets.dart';
import '../../theme/chat_kit_theme.dart';
import '../chat_kit_inherited.dart';
import 'prompt_chip.dart';

/// The start screen with greeting and suggested prompts
class StartScreen extends StatelessWidget {
  const StartScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = ChatKitInherited.of(context);
    final theme = ChatKitTheme.of(context);
    final options = controller.options.startScreen;

    return Center(
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 600),
        child: Padding(
          padding: EdgeInsets.all(theme.density.paddingExtraLarge),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (options.greeting != null) ...[
                Text(
                  options.greeting!,
                  style: theme.typography.headingLarge.copyWith(
                    color: theme.colorScheme.onSurface,
                  ),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: theme.density.spacingExtraLarge * 2),
              ],
              if (options.suggestedPrompts.isNotEmpty)
                Wrap(
                  spacing: theme.density.spacingMedium,
                  runSpacing: theme.density.spacingMedium,
                  alignment: WrapAlignment.center,
                  children: options.suggestedPrompts.map((prompt) {
                    return PromptChip(
                      label: prompt.label,
                      onTap: () {
                        controller.setComposerText(prompt.prompt);
                        controller.send();
                      },
                    );
                  }).toList(),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
