import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../theme/chat_kit_theme.dart';
import '../chat_kit_inherited.dart';

/// The text input field in the composer
class ComposerTextField extends StatefulWidget {
  const ComposerTextField({super.key});

  @override
  State<ComposerTextField> createState() => _ComposerTextFieldState();
}

class _ComposerTextFieldState extends State<ComposerTextField> {
  late TextEditingController _textController;
  final FocusNode _focusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    _textController = TextEditingController();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final controller = ChatKitInherited.of(context);
    if (_textController.text != controller.composerText) {
      _textController.text = controller.composerText;
    }
  }

  @override
  void dispose() {
    _textController.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  void _onSubmit() {
    final controller = ChatKitInherited.of(context);
    if (controller.canSend) {
      controller.send();
      _textController.clear();
      _focusNode.requestFocus();
    }
  }

  @override
  Widget build(BuildContext context) {
    final controller = ChatKitInherited.of(context);
    final theme = ChatKitTheme.of(context);
    final options = controller.options.composer;

    return KeyboardListener(
      focusNode: FocusNode(),
      onKeyEvent: (event) {
        // Submit on Enter (without Shift)
        if (event is KeyDownEvent &&
            event.logicalKey == LogicalKeyboardKey.enter &&
            !HardwareKeyboard.instance.isShiftPressed) {
          _onSubmit();
        }
      },
      child: TextField(
        controller: _textController,
        focusNode: _focusNode,
        maxLines: 5,
        minLines: 1,
        textInputAction: TextInputAction.newline,
        onChanged: (text) => controller.setComposerText(text),
        style: theme.typography.bodyLarge.copyWith(
          color: theme.colorScheme.onSurface,
        ),
        decoration: InputDecoration(
          hintText: options.placeholder ?? 'Type a message...',
          hintStyle: theme.typography.bodyLarge.copyWith(
            color: theme.colorScheme.onSurfaceVariant,
          ),
          filled: true,
          fillColor: theme.colorScheme.surfaceVariant,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.all(theme.radius.composer),
            borderSide: BorderSide.none,
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.all(theme.radius.composer),
            borderSide: BorderSide(color: theme.colorScheme.composerBorder, width: 0.5),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.all(theme.radius.composer),
            borderSide: BorderSide(color: theme.colorScheme.primary, width: 1.5),
          ),
          contentPadding: EdgeInsets.symmetric(
            horizontal: theme.density.paddingExtraLarge,
            vertical: theme.density.paddingLarge,
          ),
        ),
      ),
    );
  }
}
