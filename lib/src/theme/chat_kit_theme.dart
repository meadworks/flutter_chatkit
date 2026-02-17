import 'package:flutter/material.dart';
import 'chat_kit_theme_data.dart';

/// Provides ChatKit theme data to descendant widgets
class ChatKitTheme extends InheritedWidget {
  const ChatKitTheme({
    super.key,
    required this.data,
    required super.child,
  });

  final ChatKitThemeData data;

  /// Get the nearest ChatKitThemeData, or create one from the current Flutter theme
  static ChatKitThemeData of(BuildContext context) {
    final widget = context.dependOnInheritedWidgetOfExactType<ChatKitTheme>();
    if (widget != null) {
      return widget.data;
    }
    // Fallback: derive from Flutter theme
    return ChatKitThemeData.fromTheme(Theme.of(context));
  }

  /// Get the nearest ChatKitThemeData, or null
  static ChatKitThemeData? maybeOf(BuildContext context) {
    return context.dependOnInheritedWidgetOfExactType<ChatKitTheme>()?.data;
  }

  @override
  bool updateShouldNotify(ChatKitTheme oldWidget) => data != oldWidget.data;
}
