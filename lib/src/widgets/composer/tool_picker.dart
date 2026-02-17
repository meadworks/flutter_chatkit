import 'package:flutter/material.dart';
import '../../config/tool_option.dart';
import '../../models/inference_options.dart';
import '../../theme/chat_kit_theme.dart';
import '../chat_kit_inherited.dart';

/// A dropdown to select a tool for the next message
class ToolPicker extends StatelessWidget {
  const ToolPicker({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = ChatKitInherited.of(context);
    final theme = ChatKitTheme.of(context);
    final tools = controller.options.tools.tools;

    if (tools.isEmpty) return const SizedBox.shrink();

    return PopupMenuButton<ToolItem>(
      icon: Icon(Icons.build_outlined, color: theme.colorScheme.onSurfaceVariant, size: 20),
      tooltip: 'Select tool',
      onSelected: (tool) {
        controller.messageController.setInferenceOptions(
          InferenceOptions(toolChoice: ToolChoice(id: tool.id)),
        );
      },
      itemBuilder: (context) => tools.map((tool) {
        return PopupMenuItem<ToolItem>(
          value: tool,
          child: ListTile(
            dense: true,
            title: Text(tool.label, style: theme.typography.bodyMedium),
            subtitle: tool.description != null
                ? Text(tool.description!, style: theme.typography.bodySmall)
                : null,
          ),
        );
      }).toList(),
    );
  }
}
