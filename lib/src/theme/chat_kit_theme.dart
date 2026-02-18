import 'package:flutter/widgets.dart';
import 'chat_kit_theme_data.dart';

/// Provides ChatKit theme data to descendant widgets
class ChatKitTheme extends InheritedWidget {
  const ChatKitTheme({
    super.key,
    required this.data,
    required super.child,
  });

  final ChatKitThemeData data;

  /// Get the nearest ChatKitThemeData, or fall back to default light theme
  static ChatKitThemeData of(BuildContext context) {
    final widget = context.dependOnInheritedWidgetOfExactType<ChatKitTheme>();
    if (widget != null) {
      return widget.data;
    }
    // Fallback: default light theme (no Material dependency)
    return const ChatKitThemeData();
  }

  /// Get the nearest ChatKitThemeData, or null
  static ChatKitThemeData? maybeOf(BuildContext context) {
    return context.dependOnInheritedWidgetOfExactType<ChatKitTheme>()?.data;
  }

  @override
  bool updateShouldNotify(ChatKitTheme oldWidget) => data != oldWidget.data;
}
