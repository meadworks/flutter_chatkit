import 'package:flutter/material.dart';
import '../theme/chat_kit_theme.dart';
import 'widget_models/widget_root.dart';
import 'widget_models/widget_action.dart';
import 'nodes/widget_node_renderer.dart';

/// Callback for dispatching widget actions
typedef OnWidgetAction = void Function(WidgetAction action);

/// Renders a WidgetRoot into a Flutter Widget
class WidgetRenderer extends StatelessWidget {
  const WidgetRenderer({
    super.key,
    required this.root,
    this.onAction,
  });

  final WidgetRoot root;
  final OnWidgetAction? onAction;

  @override
  Widget build(BuildContext context) {
    final theme = ChatKitTheme.of(context);

    return switch (root) {
      CardRoot(:final title, :final children, :final footer) => Card(
          color: theme.colorScheme.surface,
          shape: RoundedRectangleBorder(
            borderRadius: theme.radius.largeBorderRadius,
            side: BorderSide(color: theme.colorScheme.outline, width: 0.5),
          ),
          child: Padding(
            padding: EdgeInsets.all(theme.density.paddingExtraLarge),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                if (title != null) ...[
                  Text(
                    title,
                    style: theme.typography.headingSmall.copyWith(
                      color: theme.colorScheme.onSurface,
                    ),
                  ),
                  SizedBox(height: theme.density.spacingLarge),
                ],
                ...children.map((node) => WidgetNodeRenderer(
                  node: node,
                  onAction: onAction,
                )),
                if (footer != null) ...[
                  SizedBox(height: theme.density.spacingLarge),
                  Divider(color: theme.colorScheme.outline),
                  SizedBox(height: theme.density.spacingMedium),
                  ...footer.map((node) => WidgetNodeRenderer(
                    node: node,
                    onAction: onAction,
                  )),
                ],
              ],
            ),
          ),
        ),

      ListViewRoot(:final children) => Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: children.map((node) => Padding(
            padding: EdgeInsets.only(bottom: theme.density.spacingSmall),
            child: WidgetNodeRenderer(node: node, onAction: onAction),
          )).toList(),
        ),

      BasicRoot(:final children) => Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: children.map((node) => WidgetNodeRenderer(
            node: node,
            onAction: onAction,
          )).toList(),
        ),
    };
  }
}
