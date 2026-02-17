import 'widget_node.dart';

/// Root container for interactive widgets
sealed class WidgetRoot {
  const WidgetRoot();

  factory WidgetRoot.fromJson(Map<String, dynamic> json) {
    final type = json['type'] as String?;
    return switch (type) {
      'card' => CardRoot.fromJson(json),
      'list' => ListViewRoot.fromJson(json),
      _ => BasicRoot.fromJson(json),
    };
  }
}

class CardRoot extends WidgetRoot {
  const CardRoot({this.title, this.children = const [], this.footer});
  final String? title;
  final List<WidgetNode> children;
  final List<WidgetNode>? footer;

  factory CardRoot.fromJson(Map<String, dynamic> json) => CardRoot(
    title: json['title'] as String?,
    children: (json['children'] as List?)
        ?.map((c) => WidgetNode.fromJson(c as Map<String, dynamic>))
        .toList() ?? const [],
    footer: (json['footer'] as List?)
        ?.map((c) => WidgetNode.fromJson(c as Map<String, dynamic>))
        .toList(),
  );
}

class ListViewRoot extends WidgetRoot {
  const ListViewRoot({this.children = const []});
  final List<WidgetNode> children;

  factory ListViewRoot.fromJson(Map<String, dynamic> json) => ListViewRoot(
    children: (json['children'] as List?)
        ?.map((c) => WidgetNode.fromJson(c as Map<String, dynamic>))
        .toList() ?? const [],
  );
}

class BasicRoot extends WidgetRoot {
  const BasicRoot({this.children = const []});
  final List<WidgetNode> children;

  factory BasicRoot.fromJson(Map<String, dynamic> json) => BasicRoot(
    children: (json['children'] as List?)
        ?.map((c) => WidgetNode.fromJson(c as Map<String, dynamic>))
        .toList() ?? const [],
  );
}
