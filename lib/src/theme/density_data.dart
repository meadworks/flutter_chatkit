/// Spacing and padding presets for ChatKit
class ChatKitDensity {
  const ChatKitDensity({
    this.paddingSmall = 4.0,
    this.paddingMedium = 8.0,
    this.paddingLarge = 12.0,
    this.paddingExtraLarge = 16.0,
    this.spacingSmall = 4.0,
    this.spacingMedium = 8.0,
    this.spacingLarge = 12.0,
    this.spacingExtraLarge = 16.0,
    this.messageSpacing = 8.0,
    this.messagePaddingHorizontal = 16.0,
    this.messagePaddingVertical = 10.0,
    this.composerPadding = 12.0,
    this.headerHeight = 56.0,
    this.historyPanelWidth = 280.0,
  });

  final double paddingSmall;
  final double paddingMedium;
  final double paddingLarge;
  final double paddingExtraLarge;
  final double spacingSmall;
  final double spacingMedium;
  final double spacingLarge;
  final double spacingExtraLarge;
  final double messageSpacing;
  final double messagePaddingHorizontal;
  final double messagePaddingVertical;
  final double composerPadding;
  final double headerHeight;
  final double historyPanelWidth;
}
