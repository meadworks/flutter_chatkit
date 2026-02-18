import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import '../../models/thread_item.dart';
import '../../theme/chat_kit_theme.dart';
import 'annotation_widget.dart';

/// Displays an assistant message with markdown rendering
class AssistantMessageWidget extends StatelessWidget {
  const AssistantMessageWidget({super.key, required this.item});

  final AssistantMessageItem item;

  @override
  Widget build(BuildContext context) {
    final theme = ChatKitTheme.of(context);
    final annotations = item.allAnnotations;

    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: theme.density.spacingSmall,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          MarkdownBody(
            data: item.fullText,
            selectable: true,
            styleSheet: MarkdownStyleSheet(
              p: theme.typography.bodyLarge.copyWith(
                color: theme.colorScheme.onAssistantBubble,
              ),
              code: theme.typography.code.copyWith(
                color: theme.colorScheme.onAssistantBubble,
                backgroundColor: theme.colorScheme.surfaceVariant,
              ),
              codeblockDecoration: BoxDecoration(
                color: theme.colorScheme.surfaceVariant,
                borderRadius: theme.radius.mediumBorderRadius,
              ),
              h1: theme.typography.headingLarge.copyWith(
                color: theme.colorScheme.onAssistantBubble,
              ),
              h2: theme.typography.headingMedium.copyWith(
                color: theme.colorScheme.onAssistantBubble,
              ),
              h3: theme.typography.headingSmall.copyWith(
                color: theme.colorScheme.onAssistantBubble,
              ),
              listBullet: theme.typography.bodyLarge.copyWith(
                color: theme.colorScheme.onAssistantBubble,
              ),
              tableColumnWidth: const IntrinsicColumnWidth(),
            ),
          ),
          if (annotations.isNotEmpty) ...[
            SizedBox(height: theme.density.spacingMedium),
            Wrap(
              spacing: theme.density.spacingSmall,
              runSpacing: theme.density.spacingSmall,
              children: annotations.map((a) => AnnotationWidget(annotation: a)).toList(),
            ),
          ],
        ],
      ),
    );
  }
}
