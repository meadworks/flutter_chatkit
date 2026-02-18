import 'package:flutter/widgets.dart';
import 'package:flutter/material.dart' show ThemeData;
import 'color_scheme_data.dart';
import 'typography_data.dart';
import 'radius_data.dart';
import 'density_data.dart';

/// Complete theme data for ChatKit
class ChatKitThemeData {
  const ChatKitThemeData({
    this.brightness = Brightness.light,
    this.colorScheme = ChatKitColorScheme.light,
    this.typography = const ChatKitTypography(),
    this.radius = const ChatKitRadius(),
    this.density = const ChatKitDensity(),
  });

  final Brightness brightness;
  final ChatKitColorScheme colorScheme;
  final ChatKitTypography typography;
  final ChatKitRadius radius;
  final ChatKitDensity density;

  /// Create a light theme
  factory ChatKitThemeData.light() => const ChatKitThemeData(
    brightness: Brightness.light,
    colorScheme: ChatKitColorScheme.light,
  );

  /// Create a dark theme
  factory ChatKitThemeData.dark() => const ChatKitThemeData(
    brightness: Brightness.dark,
    colorScheme: ChatKitColorScheme.dark,
  );

  /// Create a theme from an existing Flutter theme
  factory ChatKitThemeData.fromTheme(ThemeData theme) {
    final isDark = theme.brightness == Brightness.dark;
    return ChatKitThemeData(
      brightness: theme.brightness,
      colorScheme: isDark ? ChatKitColorScheme.dark : ChatKitColorScheme.light,
      typography: ChatKitTypography(
        fontFamily: theme.textTheme.bodyMedium?.fontFamily,
      ),
    );
  }

  ChatKitThemeData copyWith({
    Brightness? brightness,
    ChatKitColorScheme? colorScheme,
    ChatKitTypography? typography,
    ChatKitRadius? radius,
    ChatKitDensity? density,
  }) {
    return ChatKitThemeData(
      brightness: brightness ?? this.brightness,
      colorScheme: colorScheme ?? this.colorScheme,
      typography: typography ?? this.typography,
      radius: radius ?? this.radius,
      density: density ?? this.density,
    );
  }
}
