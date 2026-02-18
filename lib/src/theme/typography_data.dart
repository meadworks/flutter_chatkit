import 'package:flutter/painting.dart';

/// Typography configuration for ChatKit
class ChatKitTypography {
  const ChatKitTypography({
    this.fontFamily,
    this.headingLarge = const TextStyle(fontSize: 24, fontWeight: FontWeight.w700, height: 1.3),
    this.headingMedium = const TextStyle(fontSize: 20, fontWeight: FontWeight.w600, height: 1.3),
    this.headingSmall = const TextStyle(fontSize: 16, fontWeight: FontWeight.w600, height: 1.4),
    this.bodyLarge = const TextStyle(fontSize: 16, fontWeight: FontWeight.w400, height: 1.5),
    this.bodyMedium = const TextStyle(fontSize: 14, fontWeight: FontWeight.w400, height: 1.5),
    this.bodySmall = const TextStyle(fontSize: 12, fontWeight: FontWeight.w400, height: 1.4),
    this.labelLarge = const TextStyle(fontSize: 14, fontWeight: FontWeight.w500, height: 1.4),
    this.labelMedium = const TextStyle(fontSize: 12, fontWeight: FontWeight.w500, height: 1.3),
    this.labelSmall = const TextStyle(fontSize: 10, fontWeight: FontWeight.w500, height: 1.3),
    this.code = const TextStyle(fontSize: 13, fontFamily: 'monospace', height: 1.5),
  });

  final String? fontFamily;
  final TextStyle headingLarge;
  final TextStyle headingMedium;
  final TextStyle headingSmall;
  final TextStyle bodyLarge;
  final TextStyle bodyMedium;
  final TextStyle bodySmall;
  final TextStyle labelLarge;
  final TextStyle labelMedium;
  final TextStyle labelSmall;
  final TextStyle code;

  /// Apply the font family to all text styles
  ChatKitTypography withFontFamily(String family) {
    return ChatKitTypography(
      fontFamily: family,
      headingLarge: headingLarge.copyWith(fontFamily: family),
      headingMedium: headingMedium.copyWith(fontFamily: family),
      headingSmall: headingSmall.copyWith(fontFamily: family),
      bodyLarge: bodyLarge.copyWith(fontFamily: family),
      bodyMedium: bodyMedium.copyWith(fontFamily: family),
      bodySmall: bodySmall.copyWith(fontFamily: family),
      labelLarge: labelLarge.copyWith(fontFamily: family),
      labelMedium: labelMedium.copyWith(fontFamily: family),
      labelSmall: labelSmall.copyWith(fontFamily: family),
      code: code,
    );
  }
}
