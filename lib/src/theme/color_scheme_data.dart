import 'package:flutter/painting.dart';

/// Color scheme for ChatKit, supporting light and dark modes
class ChatKitColorScheme {
  const ChatKitColorScheme({
    required this.background,
    required this.surface,
    required this.surfaceVariant,
    required this.onSurface,
    required this.onSurfaceVariant,
    required this.primary,
    required this.onPrimary,
    required this.secondary,
    required this.onSecondary,
    required this.error,
    required this.onError,
    required this.outline,
    required this.outlineVariant,
    required this.shadow,
    required this.userBubble,
    required this.onUserBubble,
    required this.assistantBubble,
    required this.onAssistantBubble,
    required this.composerBackground,
    required this.composerBorder,
  });

  final Color background;
  final Color surface;
  final Color surfaceVariant;
  final Color onSurface;
  final Color onSurfaceVariant;
  final Color primary;
  final Color onPrimary;
  final Color secondary;
  final Color onSecondary;
  final Color error;
  final Color onError;
  final Color outline;
  final Color outlineVariant;
  final Color shadow;
  final Color userBubble;
  final Color onUserBubble;
  final Color assistantBubble;
  final Color onAssistantBubble;
  final Color composerBackground;
  final Color composerBorder;

  static const light = ChatKitColorScheme(
    background: Color(0xFFFFFFFF),
    surface: Color(0xFFFFFFFF),
    surfaceVariant: Color(0xFFF5F5F5),
    onSurface: Color(0xFF1A1A1A),
    onSurfaceVariant: Color(0xFF6E6E6E),
    primary: Color(0xFF0066FF),
    onPrimary: Color(0xFFFFFFFF),
    secondary: Color(0xFFE8F0FE),
    onSecondary: Color(0xFF1A73E8),
    error: Color(0xFFDC3545),
    onError: Color(0xFFFFFFFF),
    outline: Color(0xFFE0E0E0),
    outlineVariant: Color(0xFFF0F0F0),
    shadow: Color(0x1A000000),
    userBubble: Color(0xFF0066FF),
    onUserBubble: Color(0xFFFFFFFF),
    assistantBubble: Color(0xFFF5F5F5),
    onAssistantBubble: Color(0xFF1A1A1A),
    composerBackground: Color(0xFFFFFFFF),
    composerBorder: Color(0xFFE0E0E0),
  );

  static const dark = ChatKitColorScheme(
    background: Color(0xFF1A1A1A),
    surface: Color(0xFF2D2D2D),
    surfaceVariant: Color(0xFF3D3D3D),
    onSurface: Color(0xFFE8E8E8),
    onSurfaceVariant: Color(0xFF9E9E9E),
    primary: Color(0xFF4D9AFF),
    onPrimary: Color(0xFFFFFFFF),
    secondary: Color(0xFF1E3A5F),
    onSecondary: Color(0xFF8AB4F8),
    error: Color(0xFFFF6B6B),
    onError: Color(0xFFFFFFFF),
    outline: Color(0xFF404040),
    outlineVariant: Color(0xFF333333),
    shadow: Color(0x40000000),
    userBubble: Color(0xFF4D9AFF),
    onUserBubble: Color(0xFFFFFFFF),
    assistantBubble: Color(0xFF2D2D2D),
    onAssistantBubble: Color(0xFFE8E8E8),
    composerBackground: Color(0xFF2D2D2D),
    composerBorder: Color(0xFF404040),
  );
}
