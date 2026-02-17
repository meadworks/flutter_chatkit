/// Sealed class representing all possible widget node types
sealed class WidgetNode {
  const WidgetNode();

  factory WidgetNode.fromJson(Map<String, dynamic> json) {
    return switch (json['type']) {
      'text' => TextNode.fromJson(json),
      'button' => ButtonNode.fromJson(json),
      'input' => InputNode.fromJson(json),
      'select' => SelectNode.fromJson(json),
      'checkbox' => CheckboxNode.fromJson(json),
      'image' => ImageNode.fromJson(json),
      'icon' => IconNode.fromJson(json),
      'badge' => BadgeNode.fromJson(json),
      'divider' => const DividerNode(),
      'spacer' => SpacerNode.fromJson(json),
      'row' => RowNode.fromJson(json),
      'col' => ColNode.fromJson(json),
      'form' => FormNode.fromJson(json),
      'link' => LinkNode.fromJson(json),
      'textarea' => TextAreaNode.fromJson(json),
      'table' => TableNode.fromJson(json),
      'label' => LabelNode.fromJson(json),
      _ => TextNode(text: '[Unknown: ${json['type']}]'),
    };
  }
}

class TextNode extends WidgetNode {
  const TextNode({required this.text, this.style, this.color, this.weight, this.size});
  final String text;
  final String? style;
  final String? color;
  final String? weight;
  final String? size;

  factory TextNode.fromJson(Map<String, dynamic> json) => TextNode(
    text: json['text'] as String? ?? '',
    style: json['style'] as String?,
    color: json['color'] as String?,
    weight: json['weight'] as String?,
    size: json['size'] as String?,
  );
}

class ButtonNode extends WidgetNode {
  const ButtonNode({required this.label, this.action, this.variant, this.disabled = false});
  final String label;
  final Map<String, dynamic>? action;
  final String? variant;
  final bool disabled;

  factory ButtonNode.fromJson(Map<String, dynamic> json) => ButtonNode(
    label: json['label'] as String? ?? '',
    action: json['action'] as Map<String, dynamic>?,
    variant: json['variant'] as String?,
    disabled: json['disabled'] as bool? ?? false,
  );
}

class InputNode extends WidgetNode {
  const InputNode({this.name, this.label, this.placeholder, this.value, this.inputType});
  final String? name;
  final String? label;
  final String? placeholder;
  final String? value;
  final String? inputType;

  factory InputNode.fromJson(Map<String, dynamic> json) => InputNode(
    name: json['name'] as String?,
    label: json['label'] as String?,
    placeholder: json['placeholder'] as String?,
    value: json['value'] as String?,
    inputType: json['input_type'] as String?,
  );
}

class TextAreaNode extends WidgetNode {
  const TextAreaNode({this.name, this.label, this.placeholder, this.value, this.rows});
  final String? name;
  final String? label;
  final String? placeholder;
  final String? value;
  final int? rows;

  factory TextAreaNode.fromJson(Map<String, dynamic> json) => TextAreaNode(
    name: json['name'] as String?,
    label: json['label'] as String?,
    placeholder: json['placeholder'] as String?,
    value: json['value'] as String?,
    rows: json['rows'] as int?,
  );
}

class SelectOption {
  const SelectOption({required this.label, required this.value});
  final String label;
  final String value;

  factory SelectOption.fromJson(Map<String, dynamic> json) => SelectOption(
    label: json['label'] as String,
    value: json['value'] as String,
  );
}

class SelectNode extends WidgetNode {
  const SelectNode({this.name, this.label, this.options = const [], this.value});
  final String? name;
  final String? label;
  final List<SelectOption> options;
  final String? value;

  factory SelectNode.fromJson(Map<String, dynamic> json) => SelectNode(
    name: json['name'] as String?,
    label: json['label'] as String?,
    options: (json['options'] as List?)
        ?.map((o) => SelectOption.fromJson(o as Map<String, dynamic>))
        .toList() ?? const [],
    value: json['value'] as String?,
  );
}

class CheckboxNode extends WidgetNode {
  const CheckboxNode({this.name, this.label, this.checked = false});
  final String? name;
  final String? label;
  final bool checked;

  factory CheckboxNode.fromJson(Map<String, dynamic> json) => CheckboxNode(
    name: json['name'] as String?,
    label: json['label'] as String?,
    checked: json['checked'] as bool? ?? false,
  );
}

class ImageNode extends WidgetNode {
  const ImageNode({required this.url, this.alt, this.width, this.height});
  final String url;
  final String? alt;
  final double? width;
  final double? height;

  factory ImageNode.fromJson(Map<String, dynamic> json) => ImageNode(
    url: json['url'] as String,
    alt: json['alt'] as String?,
    width: (json['width'] as num?)?.toDouble(),
    height: (json['height'] as num?)?.toDouble(),
  );
}

class IconNode extends WidgetNode {
  const IconNode({required this.name, this.color, this.size});
  final String name;
  final String? color;
  final double? size;

  factory IconNode.fromJson(Map<String, dynamic> json) => IconNode(
    name: json['name'] as String,
    color: json['color'] as String?,
    size: (json['size'] as num?)?.toDouble(),
  );
}

class BadgeNode extends WidgetNode {
  const BadgeNode({required this.text, this.color, this.variant});
  final String text;
  final String? color;
  final String? variant;

  factory BadgeNode.fromJson(Map<String, dynamic> json) => BadgeNode(
    text: json['text'] as String,
    color: json['color'] as String?,
    variant: json['variant'] as String?,
  );
}

class DividerNode extends WidgetNode {
  const DividerNode();
}

class SpacerNode extends WidgetNode {
  const SpacerNode({this.size = 8});
  final double size;

  factory SpacerNode.fromJson(Map<String, dynamic> json) => SpacerNode(
    size: (json['size'] as num?)?.toDouble() ?? 8,
  );
}

class RowNode extends WidgetNode {
  const RowNode({this.children = const [], this.gap, this.align});
  final List<WidgetNode> children;
  final double? gap;
  final String? align;

  factory RowNode.fromJson(Map<String, dynamic> json) => RowNode(
    children: (json['children'] as List?)
        ?.map((c) => WidgetNode.fromJson(c as Map<String, dynamic>))
        .toList() ?? const [],
    gap: (json['gap'] as num?)?.toDouble(),
    align: json['align'] as String?,
  );
}

class ColNode extends WidgetNode {
  const ColNode({this.children = const [], this.gap, this.align});
  final List<WidgetNode> children;
  final double? gap;
  final String? align;

  factory ColNode.fromJson(Map<String, dynamic> json) => ColNode(
    children: (json['children'] as List?)
        ?.map((c) => WidgetNode.fromJson(c as Map<String, dynamic>))
        .toList() ?? const [],
    gap: (json['gap'] as num?)?.toDouble(),
    align: json['align'] as String?,
  );
}

class FormNode extends WidgetNode {
  const FormNode({this.children = const [], this.action});
  final List<WidgetNode> children;
  final Map<String, dynamic>? action;

  factory FormNode.fromJson(Map<String, dynamic> json) => FormNode(
    children: (json['children'] as List?)
        ?.map((c) => WidgetNode.fromJson(c as Map<String, dynamic>))
        .toList() ?? const [],
    action: json['action'] as Map<String, dynamic>?,
  );
}

class LinkNode extends WidgetNode {
  const LinkNode({required this.text, required this.url});
  final String text;
  final String url;

  factory LinkNode.fromJson(Map<String, dynamic> json) => LinkNode(
    text: json['text'] as String? ?? '',
    url: json['url'] as String? ?? '',
  );
}

class TableColumn {
  const TableColumn({required this.key, this.label});
  final String key;
  final String? label;

  factory TableColumn.fromJson(Map<String, dynamic> json) => TableColumn(
    key: json['key'] as String,
    label: json['label'] as String?,
  );
}

class TableNode extends WidgetNode {
  const TableNode({this.columns = const [], this.rows = const []});
  final List<TableColumn> columns;
  final List<Map<String, dynamic>> rows;

  factory TableNode.fromJson(Map<String, dynamic> json) => TableNode(
    columns: (json['columns'] as List?)
        ?.map((c) => TableColumn.fromJson(c as Map<String, dynamic>))
        .toList() ?? const [],
    rows: (json['rows'] as List?)
        ?.map((r) => r as Map<String, dynamic>)
        .toList() ?? const [],
  );
}

class LabelNode extends WidgetNode {
  const LabelNode({required this.text, this.htmlFor});
  final String text;
  final String? htmlFor;

  factory LabelNode.fromJson(Map<String, dynamic> json) => LabelNode(
    text: json['text'] as String? ?? '',
    htmlFor: json['for'] as String?,
  );
}
