import 'package:flutter/material.dart';
import '../../config/model_option.dart';
import '../../models/inference_options.dart';
import '../../theme/chat_kit_theme.dart';
import '../chat_kit_inherited.dart';

/// A dropdown to select a model for the next message
class ModelPicker extends StatelessWidget {
  const ModelPicker({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = ChatKitInherited.of(context);
    final theme = ChatKitTheme.of(context);
    final models = controller.options.models.models;

    if (models.isEmpty) return const SizedBox.shrink();

    return PopupMenuButton<ModelItem>(
      icon: Icon(Icons.smart_toy_outlined, color: theme.colorScheme.onSurfaceVariant, size: 20),
      tooltip: 'Select model',
      onSelected: (model) {
        controller.messageController.setInferenceOptions(
          InferenceOptions(model: model.id),
        );
      },
      itemBuilder: (context) => models.map((model) {
        return PopupMenuItem<ModelItem>(
          value: model,
          child: ListTile(
            dense: true,
            title: Text(model.label, style: theme.typography.bodyMedium),
            subtitle: model.description != null
                ? Text(model.description!, style: theme.typography.bodySmall)
                : null,
          ),
        );
      }).toList(),
    );
  }
}
