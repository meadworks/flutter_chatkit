import 'package:flutter/painting.dart';

/// Corner radius presets for ChatKit
class ChatKitRadius {
  const ChatKitRadius({
    this.small = const Radius.circular(4),
    this.medium = const Radius.circular(8),
    this.large = const Radius.circular(12),
    this.extraLarge = const Radius.circular(16),
    this.full = const Radius.circular(999),
    this.messageBubble = const Radius.circular(16),
    this.composer = const Radius.circular(24),
  });

  final Radius small;
  final Radius medium;
  final Radius large;
  final Radius extraLarge;
  final Radius full;
  final Radius messageBubble;
  final Radius composer;

  BorderRadius get smallBorderRadius => BorderRadius.all(small);
  BorderRadius get mediumBorderRadius => BorderRadius.all(medium);
  BorderRadius get largeBorderRadius => BorderRadius.all(large);
  BorderRadius get extraLargeBorderRadius => BorderRadius.all(extraLarge);
  BorderRadius get fullBorderRadius => BorderRadius.all(full);
}
