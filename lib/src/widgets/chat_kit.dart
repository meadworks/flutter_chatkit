import 'package:flutter/widgets.dart';
import '../state/chat_kit_controller.dart';
import '../theme/chat_kit_theme.dart';
import '../theme/chat_kit_theme_data.dart';
import 'chat_kit_inherited.dart';
import 'shell/chat_kit_scaffold.dart';

/// The root ChatKit widget that provides the complete chat UI.
class ChatKit extends StatefulWidget {
  const ChatKit({
    super.key,
    required this.controller,
    this.theme,
  });

  final ChatKitController controller;
  final ChatKitThemeData? theme;

  @override
  State<ChatKit> createState() => _ChatKitState();
}

class _ChatKitState extends State<ChatKit> {
  @override
  void initState() {
    super.initState();
    widget.controller.initialize();
  }

  @override
  Widget build(BuildContext context) {
    Widget child = ChatKitInherited(
      controller: widget.controller,
      child: const ChatKitScaffold(),
    );

    if (widget.theme != null) {
      child = ChatKitTheme(
        data: widget.theme!,
        child: child,
      );
    }

    return child;
  }
}
