import 'package:flutter/widgets.dart';
import '../../config/tool_option.dart';
import '../../models/inference_options.dart';
import '../../theme/chat_kit_theme.dart';
import '../chat_kit_inherited.dart';
import '../primitives/chatkit_icons.dart';
import '../primitives/chatkit_primitives.dart';

/// A dropdown to select a tool for the next message
class ToolPicker extends StatelessWidget {
  const ToolPicker({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = ChatKitInherited.of(context);
    final theme = ChatKitTheme.of(context);
    final tools = controller.options.tools.tools;

    if (tools.isEmpty) return const SizedBox.shrink();

    return ChatKitPopupMenu<ToolItem>(
      icon: Icon(ChatKitIcons.buildOutlined, color: theme.colorScheme.onSurfaceVariant, size: 20),
      tooltip: 'Select tool',
      onSelected: (tool) {
        controller.messageController.setInferenceOptions(
          InferenceOptions(toolChoice: ToolChoice(id: tool.id)),
        );
      },
      items: tools.map((tool) {
        return ChatKitPopupMenuItem<ToolItem>(
          value: tool,
          child: Padding(
            padding: EdgeInsets.symmetric(vertical: theme.density.paddingSmall),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(tool.label, style: theme.typography.bodyMedium),
                if (tool.description != null)
                  Text(tool.description!, style: theme.typography.bodySmall),
              ],
            ),
          ),
        );
      }).toList(),
    );
  }
}
