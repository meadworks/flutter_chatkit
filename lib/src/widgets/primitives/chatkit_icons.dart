import 'package:flutter/material.dart' show Icons;
import 'package:flutter/widgets.dart' show IconData;

/// Centralized icon constants for ChatKit.
///
/// This is the only file (besides assistant_message_widget.dart and
/// chat_kit_theme_data.dart) that imports material.dart, scoped to
/// the [Icons] class so the rest of the package stays Material-free.
class ChatKitIcons {
  ChatKitIcons._();

  static const IconData close = Icons.close;
  static const IconData menu = Icons.menu;
  static const IconData menuOpen = Icons.menu_open;
  static const IconData add = Icons.add;
  static const IconData arrowUpward = Icons.arrow_upward;
  static const IconData stop = Icons.stop;
  static const IconData keyboardArrowDown = Icons.keyboard_arrow_down;
  static const IconData expandLess = Icons.expand_less;
  static const IconData expandMore = Icons.expand_more;
  static const IconData link = Icons.link;
  static const IconData errorOutline = Icons.error_outline;
  static const IconData thumbUpOutlined = Icons.thumb_up_outlined;
  static const IconData thumbDownOutlined = Icons.thumb_down_outlined;
  static const IconData copy = Icons.copy;
  static const IconData refresh = Icons.refresh;
  static const IconData check = Icons.check;
  static const IconData circle = Icons.circle;
  static const IconData brokenImage = Icons.broken_image;
  static const IconData smartToyOutlined = Icons.smart_toy_outlined;
  static const IconData buildOutlined = Icons.build_outlined;
  static const IconData hourglassEmpty = Icons.hourglass_empty;
  static const IconData checkCircle = Icons.check_circle;
  static const IconData error = Icons.error;
  static const IconData taskAlt = Icons.task_alt;
  static const IconData search = Icons.search;
  static const IconData psychology = Icons.psychology;
  static const IconData description = Icons.description;
  static const IconData image = Icons.image;
}
