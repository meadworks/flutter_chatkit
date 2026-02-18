import 'package:flutter/widgets.dart';
import '../state/chat_kit_controller.dart';

/// Provides the ChatKitController to descendant widgets
class ChatKitInherited extends InheritedNotifier<ChatKitController> {
  const ChatKitInherited({
    super.key,
    required ChatKitController controller,
    required super.child,
  }) : super(notifier: controller);

  static ChatKitController of(BuildContext context) {
    final widget = context.dependOnInheritedWidgetOfExactType<ChatKitInherited>();
    assert(widget != null, 'No ChatKitInherited found in context');
    return widget!.notifier!;
  }

  static ChatKitController? maybeOf(BuildContext context) {
    return context.dependOnInheritedWidgetOfExactType<ChatKitInherited>()?.notifier;
  }
}
