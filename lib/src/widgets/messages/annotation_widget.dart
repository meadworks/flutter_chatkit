import 'package:flutter/material.dart';
import '../../models/annotation.dart';
import '../../theme/chat_kit_theme.dart';

/// Displays a citation/source annotation
class AnnotationWidget extends StatelessWidget {
  const AnnotationWidget({super.key, required this.annotation});

  final Annotation annotation;

  String get _label {
    final source = annotation.source;
    return switch (source) {
      UrlSource(:final title, :final url) => title ?? url,
      FileSource(:final title, :final filename) => title ?? filename,
      EntitySource(:final label, :final title) => label ?? title ?? 'Source',
    };
  }

  @override
  Widget build(BuildContext context) {
    final theme = ChatKitTheme.of(context);

    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: theme.density.paddingMedium,
        vertical: theme.density.paddingSmall,
      ),
      decoration: BoxDecoration(
        color: theme.colorScheme.surfaceVariant,
        borderRadius: theme.radius.smallBorderRadius,
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.link,
            size: 14,
            color: theme.colorScheme.primary,
          ),
          SizedBox(width: theme.density.spacingSmall),
          Flexible(
            child: Text(
              _label,
              style: theme.typography.labelSmall.copyWith(
                color: theme.colorScheme.primary,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }
}
