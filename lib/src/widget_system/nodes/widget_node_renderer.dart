import 'package:flutter/widgets.dart';
import '../../theme/chat_kit_theme.dart';
import '../../theme/chat_kit_theme_data.dart';
import '../../widgets/primitives/chatkit_icons.dart';
import '../../widgets/primitives/chatkit_primitives.dart';
import '../widget_models/widget_node.dart';
import '../widget_models/widget_action.dart';
import '../widget_renderer.dart';

/// Renders a single WidgetNode by dispatching to the appropriate widget
class WidgetNodeRenderer extends StatelessWidget {
  const WidgetNodeRenderer({
    super.key,
    required this.node,
    this.onAction,
  });

  final WidgetNode node;
  final OnWidgetAction? onAction;

  @override
  Widget build(BuildContext context) {
    final theme = ChatKitTheme.of(context);

    return switch (node) {
      TextNode(:final text, :final weight, :final size) => Text(
          text,
          style: _textStyle(theme, weight: weight, size: size),
        ),

      ButtonNode(:final label, :final action, :final variant, :final disabled) =>
        _buildButton(context, theme, label, action, variant, disabled),

      InputNode(:final name, :final label, :final placeholder, :final value) =>
        _buildInput(theme, name, label, placeholder, value),

      TextAreaNode(:final name, :final label, :final placeholder, :final value, :final rows) =>
        _buildTextArea(theme, name, label, placeholder, value, rows),

      SelectNode(:final name, :final label, :final options, :final value) =>
        _buildSelect(theme, name, label, options, value),

      CheckboxNode(:final name, :final label, :final checked) =>
        _buildCheckbox(theme, name, label, checked),

      ImageNode(:final url, :final alt, :final width, :final height) =>
        ClipRRect(
          borderRadius: theme.radius.mediumBorderRadius,
          child: Image.network(
            url,
            width: width,
            height: height,
            fit: BoxFit.contain,
            semanticLabel: alt,
          ),
        ),

      IconNode(:final size) => Icon(
          ChatKitIcons.circle,
          size: size ?? 24,
          color: theme.colorScheme.onSurface,
        ),

      BadgeNode(:final text) => Container(
          padding: EdgeInsets.symmetric(
            horizontal: theme.density.paddingMedium,
            vertical: theme.density.paddingSmall,
          ),
          decoration: BoxDecoration(
            color: theme.colorScheme.secondary,
            borderRadius: theme.radius.fullBorderRadius,
          ),
          child: Text(
            text,
            style: theme.typography.labelSmall.copyWith(
              color: theme.colorScheme.onSecondary,
            ),
          ),
        ),

      DividerNode() => ChatKitDivider(color: theme.colorScheme.outline),

      SpacerNode(:final size) => SizedBox(height: size),

      RowNode(:final children, :final gap) => Row(
          mainAxisSize: MainAxisSize.min,
          children: _buildChildrenWithGap(children, gap ?? 8, Axis.horizontal),
        ),

      ColNode(:final children, :final gap) => Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: _buildChildrenWithGap(children, gap ?? 8, Axis.vertical),
        ),

      FormNode(:final children) => Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: children.map((c) => Padding(
            padding: EdgeInsets.only(bottom: theme.density.spacingMedium),
            child: WidgetNodeRenderer(node: c, onAction: onAction),
          ),).toList(),
        ),

      LinkNode(:final text) => ChatKitTappable(
          onTap: () {},
          child: Text(
            text,
            style: theme.typography.bodyMedium.copyWith(
              color: theme.colorScheme.primary,
              decoration: TextDecoration.underline,
            ),
          ),
        ),

      TableNode(:final columns, :final rows) => _buildTable(theme, columns, rows),

      LabelNode(:final text) => Text(
          text,
          style: theme.typography.labelMedium.copyWith(
            color: theme.colorScheme.onSurface,
          ),
        ),
    };
  }

  TextStyle _textStyle(ChatKitThemeData theme, {String? weight, String? size}) {
    TextStyle base = theme.typography.bodyMedium;
    if (size == 'lg') base = theme.typography.bodyLarge;
    if (size == 'sm') base = theme.typography.bodySmall;
    if (weight == 'bold') base = base.copyWith(fontWeight: FontWeight.bold);
    if (weight == 'semibold') base = base.copyWith(fontWeight: FontWeight.w600);
    return base.copyWith(color: theme.colorScheme.onSurface);
  }

  Widget _buildButton(BuildContext context, ChatKitThemeData theme,
      String label, Map<String, dynamic>? action, String? variant, bool disabled,) {
    final isPrimary = variant == 'primary' || variant == null;
    return ChatKitTappable(
      onTap: disabled ? null : () {
        if (action != null && onAction != null) {
          onAction!(WidgetAction.fromJson(action));
        }
      },
      borderRadius: theme.radius.mediumBorderRadius,
      color: isPrimary ? theme.colorScheme.primary : theme.colorScheme.surface,
      child: Padding(
        padding: EdgeInsets.symmetric(
          horizontal: theme.density.paddingExtraLarge,
          vertical: theme.density.paddingMedium,
        ),
        child: Text(
          label,
          style: theme.typography.labelLarge.copyWith(
            color: isPrimary ? theme.colorScheme.onPrimary : theme.colorScheme.onSurface,
          ),
        ),
      ),
    );
  }

  Widget _buildInput(ChatKitThemeData theme, String? name, String? label,
      String? placeholder, String? value,) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        if (label != null)
          Padding(
            padding: EdgeInsets.only(bottom: theme.density.spacingSmall),
            child: Text(label, style: theme.typography.labelMedium.copyWith(
              color: theme.colorScheme.onSurface,
            ),),
          ),
        ChatKitTextField(
          controller: TextEditingController(text: value),
          hintText: placeholder,
          borderRadius: theme.radius.mediumBorderRadius,
          contentPadding: EdgeInsets.symmetric(
            horizontal: theme.density.paddingLarge,
            vertical: theme.density.paddingMedium,
          ),
          style: theme.typography.bodyMedium,
        ),
      ],
    );
  }

  Widget _buildTextArea(ChatKitThemeData theme, String? name, String? label,
      String? placeholder, String? value, int? rows,) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        if (label != null)
          Padding(
            padding: EdgeInsets.only(bottom: theme.density.spacingSmall),
            child: Text(label, style: theme.typography.labelMedium.copyWith(
              color: theme.colorScheme.onSurface,
            ),),
          ),
        ChatKitTextField(
          controller: TextEditingController(text: value),
          maxLines: rows ?? 4,
          hintText: placeholder,
          borderRadius: theme.radius.mediumBorderRadius,
          contentPadding: EdgeInsets.all(theme.density.paddingLarge),
          style: theme.typography.bodyMedium,
        ),
      ],
    );
  }

  Widget _buildSelect(ChatKitThemeData theme, String? name, String? label,
      List<SelectOption> options, String? value,) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        if (label != null)
          Padding(
            padding: EdgeInsets.only(bottom: theme.density.spacingSmall),
            child: Text(label, style: theme.typography.labelMedium.copyWith(
              color: theme.colorScheme.onSurface,
            ),),
          ),
        ChatKitDropdown<String>(
          value: value,
          items: options.map((o) => ChatKitDropdownItem(
            value: o.value,
            label: o.label,
          ),).toList(),
          onChanged: (_) {},
          borderRadius: theme.radius.mediumBorderRadius,
          contentPadding: EdgeInsets.symmetric(
            horizontal: theme.density.paddingLarge,
            vertical: theme.density.paddingMedium,
          ),
        ),
      ],
    );
  }

  Widget _buildCheckbox(ChatKitThemeData theme, String? name, String? label, bool checked) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        ChatKitCheckbox(value: checked, onChanged: (_) {}),
        if (label != null) ...[
          SizedBox(width: theme.density.spacingSmall),
          Text(label, style: theme.typography.bodyMedium.copyWith(
            color: theme.colorScheme.onSurface,
          ),),
        ],
      ],
    );
  }

  Widget _buildTable(ChatKitThemeData theme, List<TableColumn> columns,
      List<Map<String, dynamic>> rows,) {
    return Table(
      border: TableBorder.all(color: theme.colorScheme.outline, width: 0.5),
      children: [
        // Header row
        TableRow(
          decoration: BoxDecoration(color: theme.colorScheme.surfaceVariant),
          children: columns.map((col) => Padding(
            padding: EdgeInsets.all(theme.density.paddingMedium),
            child: Text(
              col.label ?? col.key,
              style: theme.typography.labelMedium.copyWith(
                color: theme.colorScheme.onSurface,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),).toList(),
        ),
        // Data rows
        ...rows.map((row) => TableRow(
          children: columns.map((col) => Padding(
            padding: EdgeInsets.all(theme.density.paddingMedium),
            child: Text(
              '${row[col.key] ?? ''}',
              style: theme.typography.bodySmall.copyWith(
                color: theme.colorScheme.onSurface,
              ),
            ),
          ),).toList(),
        ),),
      ],
    );
  }

  List<Widget> _buildChildrenWithGap(List<WidgetNode> children, double gap, Axis axis) {
    final widgets = <Widget>[];
    for (var i = 0; i < children.length; i++) {
      widgets.add(WidgetNodeRenderer(node: children[i], onAction: onAction));
      if (i < children.length - 1) {
        widgets.add(axis == Axis.horizontal
            ? SizedBox(width: gap)
            : SizedBox(height: gap),);
      }
    }
    return widgets;
  }
}
