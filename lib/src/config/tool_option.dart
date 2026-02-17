/// A tool item displayed in the tool picker
class ToolItem {
  const ToolItem({
    required this.id,
    required this.label,
    this.icon,
    this.description,
  });

  final String id;
  final String label;
  final String? icon;
  final String? description;
}

/// Configuration for tool selection
class ToolOption {
  const ToolOption({
    this.tools = const [],
  });

  final List<ToolItem> tools;
}
