import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_chatkit/flutter_chatkit.dart';

void main() {
  group('ChatKitThemeData', () {
    test('light factory has correct brightness', () {
      final theme = ChatKitThemeData.light();
      expect(theme.brightness, Brightness.light);
      expect(theme.colorScheme, same(ChatKitColorScheme.light));
    });

    test('dark factory has correct brightness', () {
      final theme = ChatKitThemeData.dark();
      expect(theme.brightness, Brightness.dark);
      expect(theme.colorScheme, same(ChatKitColorScheme.dark));
    });

    test('default constructor uses light values', () {
      const theme = ChatKitThemeData();
      expect(theme.brightness, Brightness.light);
      expect(theme.colorScheme, same(ChatKitColorScheme.light));
    });

    test('fromTheme creates from light Flutter theme', () {
      final flutterTheme = ThemeData.light();
      final theme = ChatKitThemeData.fromTheme(flutterTheme);
      expect(theme.brightness, Brightness.light);
      expect(theme.colorScheme, same(ChatKitColorScheme.light));
    });

    test('fromTheme creates from dark Flutter theme', () {
      final flutterTheme = ThemeData.dark();
      final theme = ChatKitThemeData.fromTheme(flutterTheme);
      expect(theme.brightness, Brightness.dark);
      expect(theme.colorScheme, same(ChatKitColorScheme.dark));
    });

    test('fromTheme picks up font family from Flutter theme', () {
      final flutterTheme = ThemeData(
        textTheme: const TextTheme(
          bodyMedium: TextStyle(fontFamily: 'Roboto'),
        ),
      );
      final theme = ChatKitThemeData.fromTheme(flutterTheme);
      expect(theme.typography.fontFamily, 'Roboto');
    });

    test('copyWith preserves unchanged values', () {
      final original = ChatKitThemeData.light();
      final modified = original.copyWith(brightness: Brightness.dark);
      expect(modified.brightness, Brightness.dark);
      expect(modified.colorScheme, same(original.colorScheme));
      expect(modified.typography.fontFamily, original.typography.fontFamily);
      expect(modified.radius.small, original.radius.small);
      expect(modified.density.paddingSmall, original.density.paddingSmall);
    });

    test('copyWith can override all fields', () {
      const theme = ChatKitThemeData();
      final modified = theme.copyWith(
        brightness: Brightness.dark,
        colorScheme: ChatKitColorScheme.dark,
        typography: const ChatKitTypography(fontFamily: 'Courier'),
        radius: const ChatKitRadius(
          small: Radius.circular(2),
        ),
        density: const ChatKitDensity(paddingSmall: 2),
      );

      expect(modified.brightness, Brightness.dark);
      expect(modified.colorScheme, same(ChatKitColorScheme.dark));
      expect(modified.typography.fontFamily, 'Courier');
      expect(modified.radius.small, const Radius.circular(2));
      expect(modified.density.paddingSmall, 2);
    });
  });

  group('ChatKitColorScheme', () {
    test('light scheme has white background', () {
      expect(
        ChatKitColorScheme.light.background,
        const Color(0xFFFFFFFF),
      );
    });

    test('dark scheme has dark background', () {
      expect(
        ChatKitColorScheme.dark.background,
        const Color(0xFF1A1A1A),
      );
    });

    test('light and dark differ in key colors', () {
      expect(
        ChatKitColorScheme.light.background,
        isNot(ChatKitColorScheme.dark.background),
      );
      expect(
        ChatKitColorScheme.light.onSurface,
        isNot(ChatKitColorScheme.dark.onSurface),
      );
      expect(
        ChatKitColorScheme.light.primary,
        isNot(ChatKitColorScheme.dark.primary),
      );
    });

    test('all color fields are non-null', () {
      const scheme = ChatKitColorScheme.light;
      expect(scheme.background, isNotNull);
      expect(scheme.surface, isNotNull);
      expect(scheme.surfaceVariant, isNotNull);
      expect(scheme.onSurface, isNotNull);
      expect(scheme.onSurfaceVariant, isNotNull);
      expect(scheme.primary, isNotNull);
      expect(scheme.onPrimary, isNotNull);
      expect(scheme.secondary, isNotNull);
      expect(scheme.onSecondary, isNotNull);
      expect(scheme.error, isNotNull);
      expect(scheme.onError, isNotNull);
      expect(scheme.outline, isNotNull);
      expect(scheme.outlineVariant, isNotNull);
      expect(scheme.shadow, isNotNull);
      expect(scheme.userBubble, isNotNull);
      expect(scheme.onUserBubble, isNotNull);
      expect(scheme.assistantBubble, isNotNull);
      expect(scheme.onAssistantBubble, isNotNull);
      expect(scheme.composerBackground, isNotNull);
      expect(scheme.composerBorder, isNotNull);
    });
  });

  group('ChatKitTypography', () {
    test('default values', () {
      const typography = ChatKitTypography();
      expect(typography.fontFamily, isNull);
      expect(typography.bodyMedium.fontSize, 14);
      expect(typography.headingLarge.fontSize, 24);
      expect(typography.code.fontFamily, 'monospace');
    });

    test('withFontFamily applies to all styles except code', () {
      const typography = ChatKitTypography();
      final custom = typography.withFontFamily('Inter');

      expect(custom.fontFamily, 'Inter');
      expect(custom.bodyMedium.fontFamily, 'Inter');
      expect(custom.headingLarge.fontFamily, 'Inter');
      expect(custom.labelSmall.fontFamily, 'Inter');
      // Code should keep its monospace font
      expect(custom.code.fontFamily, 'monospace');
    });
  });

  group('ChatKitRadius', () {
    test('default values', () {
      const radius = ChatKitRadius();
      expect(radius.small, const Radius.circular(4));
      expect(radius.medium, const Radius.circular(8));
      expect(radius.large, const Radius.circular(12));
      expect(radius.extraLarge, const Radius.circular(16));
      expect(radius.full, const Radius.circular(999));
      expect(radius.messageBubble, const Radius.circular(16));
      expect(radius.composer, const Radius.circular(24));
    });

    test('border radius getters', () {
      const radius = ChatKitRadius();
      expect(
        radius.smallBorderRadius,
        BorderRadius.all(const Radius.circular(4)),
      );
      expect(
        radius.mediumBorderRadius,
        BorderRadius.all(const Radius.circular(8)),
      );
      expect(
        radius.largeBorderRadius,
        BorderRadius.all(const Radius.circular(12)),
      );
      expect(
        radius.extraLargeBorderRadius,
        BorderRadius.all(const Radius.circular(16)),
      );
      expect(
        radius.fullBorderRadius,
        BorderRadius.all(const Radius.circular(999)),
      );
    });
  });

  group('ChatKitDensity', () {
    test('default values', () {
      const density = ChatKitDensity();
      expect(density.paddingSmall, 4.0);
      expect(density.paddingMedium, 8.0);
      expect(density.paddingLarge, 12.0);
      expect(density.paddingExtraLarge, 16.0);
      expect(density.spacingSmall, 4.0);
      expect(density.spacingMedium, 8.0);
      expect(density.spacingLarge, 12.0);
      expect(density.spacingExtraLarge, 16.0);
      expect(density.messageSpacing, 8.0);
      expect(density.messagePaddingHorizontal, 16.0);
      expect(density.messagePaddingVertical, 10.0);
      expect(density.composerPadding, 12.0);
      expect(density.headerHeight, 56.0);
      expect(density.historyPanelWidth, 280.0);
    });

    test('custom values', () {
      const density = ChatKitDensity(
        paddingSmall: 2,
        headerHeight: 48,
        historyPanelWidth: 300,
      );
      expect(density.paddingSmall, 2.0);
      expect(density.headerHeight, 48.0);
      expect(density.historyPanelWidth, 300.0);
    });
  });

  group('ChatKitTheme InheritedWidget', () {
    testWidgets('provides theme data to descendants', (tester) async {
      final themeData = ChatKitThemeData.dark();

      late ChatKitThemeData retrieved;
      await tester.pumpWidget(
        MaterialApp(
          home: ChatKitTheme(
            data: themeData,
            child: Builder(
              builder: (context) {
                retrieved = ChatKitTheme.of(context);
                return const SizedBox();
              },
            ),
          ),
        ),
      );

      expect(retrieved.brightness, Brightness.dark);
      expect(retrieved.colorScheme, same(ChatKitColorScheme.dark));
    });

    testWidgets('falls back to Flutter theme when no ChatKitTheme ancestor',
        (tester) async {
      late ChatKitThemeData retrieved;
      await tester.pumpWidget(
        MaterialApp(
          theme: ThemeData.dark(),
          home: Builder(
            builder: (context) {
              retrieved = ChatKitTheme.of(context);
              return const SizedBox();
            },
          ),
        ),
      );

      expect(retrieved.brightness, Brightness.dark);
    });

    testWidgets('falls back to light theme from Flutter theme',
        (tester) async {
      late ChatKitThemeData retrieved;
      await tester.pumpWidget(
        MaterialApp(
          theme: ThemeData.light(),
          home: Builder(
            builder: (context) {
              retrieved = ChatKitTheme.of(context);
              return const SizedBox();
            },
          ),
        ),
      );

      expect(retrieved.brightness, Brightness.light);
    });

    testWidgets('maybeOf returns null when no ChatKitTheme ancestor',
        (tester) async {
      ChatKitThemeData? retrieved;
      await tester.pumpWidget(
        MaterialApp(
          home: Builder(
            builder: (context) {
              retrieved = ChatKitTheme.maybeOf(context);
              return const SizedBox();
            },
          ),
        ),
      );

      expect(retrieved, isNull);
    });

    testWidgets('maybeOf returns theme when ChatKitTheme ancestor exists',
        (tester) async {
      final themeData = ChatKitThemeData.light();
      ChatKitThemeData? retrieved;

      await tester.pumpWidget(
        MaterialApp(
          home: ChatKitTheme(
            data: themeData,
            child: Builder(
              builder: (context) {
                retrieved = ChatKitTheme.maybeOf(context);
                return const SizedBox();
              },
            ),
          ),
        ),
      );

      expect(retrieved, isNotNull);
      expect(retrieved!.brightness, Brightness.light);
    });

    testWidgets('nearest ChatKitTheme wins over ancestor', (tester) async {
      late ChatKitThemeData retrieved;
      await tester.pumpWidget(
        MaterialApp(
          home: ChatKitTheme(
            data: ChatKitThemeData.light(),
            child: ChatKitTheme(
              data: ChatKitThemeData.dark(),
              child: Builder(
                builder: (context) {
                  retrieved = ChatKitTheme.of(context);
                  return const SizedBox();
                },
              ),
            ),
          ),
        ),
      );

      expect(retrieved.brightness, Brightness.dark);
    });

    testWidgets('updateShouldNotify returns true when data changes',
        (tester) async {
      var buildCount = 0;
      final lightTheme = ChatKitThemeData.light();
      final darkTheme = ChatKitThemeData.dark();

      late StateSetter setState;
      var currentTheme = lightTheme;

      await tester.pumpWidget(
        MaterialApp(
          home: StatefulBuilder(
            builder: (context, setter) {
              setState = setter;
              return ChatKitTheme(
                data: currentTheme,
                child: Builder(
                  builder: (context) {
                    ChatKitTheme.of(context);
                    buildCount++;
                    return const SizedBox();
                  },
                ),
              );
            },
          ),
        ),
      );

      expect(buildCount, 1);

      setState(() {
        currentTheme = darkTheme;
      });
      await tester.pump();

      expect(buildCount, 2);
    });
  });
}
