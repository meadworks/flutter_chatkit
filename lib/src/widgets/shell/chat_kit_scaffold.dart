import 'package:flutter/material.dart';
import '../../theme/chat_kit_theme.dart';
import '../chat_kit_inherited.dart';
import 'header_bar.dart';
import 'history_panel.dart';
import '../start_screen/start_screen.dart';
import '../messages/message_list.dart';
import '../composer/composer.dart';

/// The main scaffold layout: header + body + composer
class ChatKitScaffold extends StatefulWidget {
  const ChatKitScaffold({super.key});

  @override
  State<ChatKitScaffold> createState() => _ChatKitScaffoldState();
}

class _ChatKitScaffoldState extends State<ChatKitScaffold> {
  bool _historyOpen = false;

  void _toggleHistory() {
    setState(() {
      _historyOpen = !_historyOpen;
    });
  }

  @override
  Widget build(BuildContext context) {
    final controller = ChatKitInherited.of(context);
    final theme = ChatKitTheme.of(context);
    final hasActiveThread = controller.activeThreadId != null;

    return Container(
      color: theme.colorScheme.background,
      child: Row(
        children: [
          if (_historyOpen && controller.options.history.enabled)
            SizedBox(
              width: theme.density.historyPanelWidth,
              child: HistoryPanel(
                onClose: _toggleHistory,
              ),
            ),
          Expanded(
            child: Column(
              children: [
                ChatKitHeaderBar(
                  onHistoryToggle: controller.options.history.enabled
                      ? _toggleHistory
                      : null,
                  isHistoryOpen: _historyOpen,
                ),
                Expanded(
                  child: hasActiveThread || controller.items.isNotEmpty
                      ? const MessageList()
                      : const StartScreen(),
                ),
                const Composer(),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
