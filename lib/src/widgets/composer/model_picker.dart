import 'package:flutter/widgets.dart';
import '../../config/model_option.dart';
import '../../models/inference_options.dart';
import '../../theme/chat_kit_theme.dart';
import '../chat_kit_inherited.dart';
import '../primitives/chatkit_icons.dart';
import '../primitives/chatkit_primitives.dart';

/// A dropdown to select a model for the next message
class ModelPicker extends StatelessWidget {
  const ModelPicker({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = ChatKitInherited.of(context);
    final theme = ChatKitTheme.of(context);
    final models = controller.options.models.models;

    if (models.isEmpty) return const SizedBox.shrink();

    return ChatKitPopupMenu<ModelItem>(
      icon: Icon(ChatKitIcons.smartToyOutlined, color: theme.colorScheme.onSurfaceVariant, size: 20),
      tooltip: 'Select model',
      onSelected: (model) {
        controller.messageController.setInferenceOptions(
          InferenceOptions(model: model.id),
        );
      },
      items: models.map((model) {
        return ChatKitPopupMenuItem<ModelItem>(
          value: model,
          child: Padding(
            padding: EdgeInsets.symmetric(vertical: theme.density.paddingSmall),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(model.label, style: theme.typography.bodyMedium),
                if (model.description != null)
                  Text(model.description!, style: theme.typography.bodySmall),
              ],
            ),
          ),
        );
      }).toList(),
    );
  }
}
