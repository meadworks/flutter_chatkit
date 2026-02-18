import 'package:flutter/widgets.dart';
import '../../models/thread_item.dart';
import '../../theme/chat_kit_theme.dart';
import '../chat_kit_inherited.dart';
import '../primitives/chatkit_icons.dart';
import 'user_message_widget.dart';
import 'assistant_message_widget.dart';
import 'typing_indicator.dart';
import '../tool_calls/tool_call_widget.dart';
import '../workflows/workflow_widget.dart';
import '../images/generated_image_widget.dart';

/// The message list using a reversed ListView.builder
class MessageList extends StatefulWidget {
  const MessageList({super.key});

  @override
  State<MessageList> createState() => _MessageListState();
}

class _MessageListState extends State<MessageList> {
  final ScrollController _scrollController = ScrollController();
  bool _showScrollToBottom = false;

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _scrollController.removeListener(_onScroll);
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    final showButton = _scrollController.offset > 200;
    if (showButton != _showScrollToBottom) {
      setState(() => _showScrollToBottom = showButton);
    }
  }

  void _scrollToBottom() {
    _scrollController.animateTo(
      0,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeOut,
    );
  }

  @override
  Widget build(BuildContext context) {
    final controller = ChatKitInherited.of(context);
    final theme = ChatKitTheme.of(context);
    final items = controller.items
        .where((item) => item is! EndOfTurnItem)
        .toList();

    return Stack(
      children: [
        ListView.builder(
          controller: _scrollController,
          reverse: true,
          padding: EdgeInsets.symmetric(
            horizontal: theme.density.paddingExtraLarge,
            vertical: theme.density.paddingLarge,
          ),
          itemCount: items.length + (controller.isStreamActive ? 1 : 0),
          itemBuilder: (context, index) {
            // Typing indicator at the bottom (index 0 in reversed list)
            if (controller.isStreamActive && index == 0) {
              return Padding(
                padding: EdgeInsets.only(bottom: theme.density.messageSpacing),
                child: const TypingIndicator(),
              );
            }

            final itemIndex = controller.isStreamActive
                ? items.length - index
                : items.length - 1 - index;

            if (itemIndex < 0 || itemIndex >= items.length) {
              return const SizedBox.shrink();
            }

            final item = items[itemIndex];
            return Padding(
              padding: EdgeInsets.only(bottom: theme.density.messageSpacing),
              child: _buildItem(item),
            );
          },
        ),
        if (_showScrollToBottom)
          Positioned(
            bottom: 16,
            right: 16,
            child: GestureDetector(
              onTap: _scrollToBottom,
              child: Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: theme.colorScheme.surface,
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: theme.colorScheme.shadow,
                      blurRadius: 6,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Icon(ChatKitIcons.keyboardArrowDown, color: theme.colorScheme.onSurface),
              ),
            ),
          ),
      ],
    );
  }

  Widget _buildItem(ThreadItem item) {
    return switch (item) {
      UserMessageItem() => UserMessageWidget(item: item),
      AssistantMessageItem() => AssistantMessageWidget(item: item),
      ClientToolCallItem() => ToolCallWidget(item: item),
      WorkflowItem() => WorkflowWidget(item: item),
      GeneratedImageItem() => GeneratedImageWidget(item: item),
      WidgetItem() => const SizedBox.shrink(), // TODO: widget renderer
      EndOfTurnItem() => const SizedBox.shrink(),
    };
  }
}
