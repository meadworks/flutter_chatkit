import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import '../../theme/chat_kit_theme.dart';
import '../chat_kit_inherited.dart';
import '../primitives/chatkit_primitives.dart';

/// The text input field in the composer
class ComposerTextField extends StatefulWidget {
  const ComposerTextField({super.key});

  @override
  State<ComposerTextField> createState() => _ComposerTextFieldState();
}

class _ComposerTextFieldState extends State<ComposerTextField> {
  late TextEditingController _textController;
  final FocusNode _focusNode = FocusNode();
  final FocusNode _keyboardListenerFocusNode = FocusNode();

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
    _keyboardListenerFocusNode.dispose();
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
      focusNode: _keyboardListenerFocusNode,
      onKeyEvent: (event) {
        // Submit on Enter (without Shift)
        if (event is KeyDownEvent &&
            event.logicalKey == LogicalKeyboardKey.enter &&
            !HardwareKeyboard.instance.isShiftPressed) {
          _onSubmit();
        }
      },
      child: ChatKitTextField(
        controller: _textController,
        focusNode: _focusNode,
        maxLines: 5,
        minLines: 1,
        onChanged: (text) => controller.setComposerText(text),
        style: theme.typography.bodyLarge.copyWith(
          color: theme.colorScheme.onSurface,
        ),
        hintText: options.placeholder ?? 'Type a message...',
        hintStyle: theme.typography.bodyLarge.copyWith(
          color: theme.colorScheme.onSurfaceVariant,
        ),
        fillColor: theme.colorScheme.surfaceVariant,
        borderRadius: BorderRadius.all(theme.radius.composer),
        borderColor: theme.colorScheme.composerBorder,
        focusBorderColor: theme.colorScheme.primary,
        borderWidth: 0.5,
        focusBorderWidth: 1.5,
        contentPadding: EdgeInsets.symmetric(
          horizontal: theme.density.paddingExtraLarge,
          vertical: theme.density.paddingLarge,
        ),
      ),
    );
  }
}
