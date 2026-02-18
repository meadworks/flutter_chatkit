import 'dart:math' as math;

import 'package:flutter/widgets.dart';
import '../../theme/chat_kit_theme.dart';
import '../../theme/chat_kit_theme_data.dart';

// ---------------------------------------------------------------------------
// ChatKitIconButton
// ---------------------------------------------------------------------------

/// A simple icon button that does not depend on Material.
class ChatKitIconButton extends StatelessWidget {
  const ChatKitIconButton({
    super.key,
    required this.icon,
    this.onPressed,
    this.tooltip,
    this.size = 40,
    this.iconSize,
    this.color,
    this.padding = EdgeInsets.zero,
  });

  final Widget icon;
  final VoidCallback? onPressed;
  final String? tooltip;
  final double size;
  final double? iconSize;
  final Color? color;
  final EdgeInsetsGeometry padding;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      button: true,
      label: tooltip,
      child: GestureDetector(
        onTap: onPressed,
        behavior: HitTestBehavior.opaque,
        child: Padding(
          padding: padding,
          child: SizedBox(
            width: size,
            height: size,
            child: Center(child: icon),
          ),
        ),
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// ChatKitDivider
// ---------------------------------------------------------------------------

/// A thin horizontal line, replacing Material [Divider].
class ChatKitDivider extends StatelessWidget {
  const ChatKitDivider({
    super.key,
    this.height = 1,
    this.thickness = 1,
    this.color,
  });

  final double height;
  final double thickness;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    final theme = ChatKitTheme.of(context);
    return SizedBox(
      height: height,
      child: Center(
        child: Container(
          height: thickness,
          color: color ?? theme.colorScheme.outline,
        ),
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// ChatKitTappable
// ---------------------------------------------------------------------------

/// A tappable area with optional highlight, replacing Material
/// [InkWell] / [Material]+[InkWell].
class ChatKitTappable extends StatefulWidget {
  const ChatKitTappable({
    super.key,
    required this.child,
    this.onTap,
    this.borderRadius,
    this.color,
    this.highlightColor,
  });

  final Widget child;
  final VoidCallback? onTap;
  final BorderRadius? borderRadius;
  final Color? color;
  final Color? highlightColor;

  @override
  State<ChatKitTappable> createState() => _ChatKitTappableState();
}

class _ChatKitTappableState extends State<ChatKitTappable> {
  bool _pressed = false;

  @override
  Widget build(BuildContext context) {
    final theme = ChatKitTheme.of(context);
    final highlight =
        widget.highlightColor ?? theme.colorScheme.onSurface.withValues(alpha: 0.08);

    return GestureDetector(
      onTapDown: widget.onTap != null ? (_) => setState(() => _pressed = true) : null,
      onTapUp: widget.onTap != null ? (_) => setState(() => _pressed = false) : null,
      onTapCancel: widget.onTap != null ? () => setState(() => _pressed = false) : null,
      onTap: widget.onTap,
      child: DecoratedBox(
        decoration: BoxDecoration(
          color: _pressed ? highlight : (widget.color ?? const Color(0x00000000)),
          borderRadius: widget.borderRadius,
        ),
        child: widget.child,
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// ChatKitSpinner
// ---------------------------------------------------------------------------

/// An indeterminate / determinate spinner, replacing Material
/// [CircularProgressIndicator].
class ChatKitSpinner extends StatefulWidget {
  const ChatKitSpinner({
    super.key,
    this.size = 24,
    this.strokeWidth = 3,
    this.color,
    this.value,
  });

  final double size;
  final double strokeWidth;
  final Color? color;

  /// If non-null the spinner shows a determinate arc (0.0 – 1.0).
  final double? value;

  @override
  State<ChatKitSpinner> createState() => _ChatKitSpinnerState();
}

class _ChatKitSpinnerState extends State<ChatKitSpinner>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    );
    if (widget.value == null) _controller.repeat();
  }

  @override
  void didUpdateWidget(ChatKitSpinner oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.value != null && _controller.isAnimating) {
      _controller.stop();
    } else if (widget.value == null && !_controller.isAnimating) {
      _controller.repeat();
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = ChatKitTheme.of(context);
    final effectiveColor = widget.color ?? theme.colorScheme.primary;

    if (widget.value != null) {
      return SizedBox(
        width: widget.size,
        height: widget.size,
        child: CustomPaint(
          painter: _SpinnerPainter(
            color: effectiveColor,
            strokeWidth: widget.strokeWidth,
            startAngle: -math.pi / 2,
            sweepAngle: 2 * math.pi * widget.value!.clamp(0.0, 1.0),
          ),
        ),
      );
    }

    return AnimatedBuilder(
      animation: _controller,
      builder: (context, _) {
        final t = _controller.value;
        return SizedBox(
          width: widget.size,
          height: widget.size,
          child: CustomPaint(
            painter: _SpinnerPainter(
              color: effectiveColor,
              strokeWidth: widget.strokeWidth,
              startAngle: t * 2 * math.pi * 2,
              sweepAngle: math.pi * (0.5 + 0.5 * (0.5 - (0.5 - t).abs()) * 2),
            ),
          ),
        );
      },
    );
  }
}

class _SpinnerPainter extends CustomPainter {
  _SpinnerPainter({
    required this.color,
    required this.strokeWidth,
    required this.startAngle,
    required this.sweepAngle,
  });

  final Color color;
  final double strokeWidth;
  final double startAngle;
  final double sweepAngle;

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..strokeWidth = strokeWidth
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    final rect = Offset.zero & size;
    canvas.drawArc(rect.deflate(strokeWidth / 2), startAngle, sweepAngle, false, paint);
  }

  @override
  bool shouldRepaint(_SpinnerPainter old) =>
      color != old.color ||
      strokeWidth != old.strokeWidth ||
      startAngle != old.startAngle ||
      sweepAngle != old.sweepAngle;
}

// ---------------------------------------------------------------------------
// ChatKitTextField
// ---------------------------------------------------------------------------

/// A text field built on [EditableText], replacing Material [TextField].
class ChatKitTextField extends StatefulWidget {
  const ChatKitTextField({
    super.key,
    this.controller,
    this.focusNode,
    this.maxLines = 1,
    this.minLines,
    this.hintText,
    this.hintStyle,
    this.style,
    this.onChanged,
    this.borderRadius,
    this.fillColor,
    this.borderColor,
    this.focusBorderColor,
    this.contentPadding,
    this.borderWidth = 0.5,
    this.focusBorderWidth = 1.5,
  });

  final TextEditingController? controller;
  final FocusNode? focusNode;
  final int? maxLines;
  final int? minLines;
  final String? hintText;
  final TextStyle? hintStyle;
  final TextStyle? style;
  final ValueChanged<String>? onChanged;
  final BorderRadius? borderRadius;
  final Color? fillColor;
  final Color? borderColor;
  final Color? focusBorderColor;
  final EdgeInsetsGeometry? contentPadding;
  final double borderWidth;
  final double focusBorderWidth;

  @override
  State<ChatKitTextField> createState() => _ChatKitTextFieldState();
}

class _ChatKitTextFieldState extends State<ChatKitTextField> {
  late TextEditingController _controller;
  late FocusNode _focusNode;
  bool _ownsController = false;
  bool _ownsFocusNode = false;
  bool _focused = false;

  @override
  void initState() {
    super.initState();
    if (widget.controller != null) {
      _controller = widget.controller!;
    } else {
      _controller = TextEditingController();
      _ownsController = true;
    }
    if (widget.focusNode != null) {
      _focusNode = widget.focusNode!;
    } else {
      _focusNode = FocusNode();
      _ownsFocusNode = true;
    }
    _focusNode.addListener(_onFocusChange);
  }

  @override
  void didUpdateWidget(ChatKitTextField oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.controller != oldWidget.controller) {
      if (_ownsController) {
        _controller.dispose();
        _ownsController = false;
      }
      if (widget.controller != null) {
        _controller = widget.controller!;
      } else {
        _controller = TextEditingController();
        _ownsController = true;
      }
    }
    if (widget.focusNode != oldWidget.focusNode) {
      _focusNode.removeListener(_onFocusChange);
      if (_ownsFocusNode) {
        _focusNode.dispose();
        _ownsFocusNode = false;
      }
      if (widget.focusNode != null) {
        _focusNode = widget.focusNode!;
      } else {
        _focusNode = FocusNode();
        _ownsFocusNode = true;
      }
      _focusNode.addListener(_onFocusChange);
    }
  }

  void _onFocusChange() {
    setState(() => _focused = _focusNode.hasFocus);
  }

  @override
  void dispose() {
    _focusNode.removeListener(_onFocusChange);
    if (_ownsController) _controller.dispose();
    if (_ownsFocusNode) _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = ChatKitTheme.of(context);
    final effectiveStyle = widget.style ??
        theme.typography.bodyLarge.copyWith(color: theme.colorScheme.onSurface);
    final effectiveHintStyle = widget.hintStyle ??
        theme.typography.bodyLarge.copyWith(color: theme.colorScheme.onSurfaceVariant);
    final effectiveFill = widget.fillColor ?? theme.colorScheme.surfaceVariant;
    final effectiveBorder = widget.borderColor ?? theme.colorScheme.composerBorder;
    final effectiveFocusBorder = widget.focusBorderColor ?? theme.colorScheme.primary;
    final effectiveRadius = widget.borderRadius ?? BorderRadius.all(theme.radius.medium);
    final effectivePadding = widget.contentPadding ??
        EdgeInsets.symmetric(
          horizontal: theme.density.paddingExtraLarge,
          vertical: theme.density.paddingLarge,
        );

    final bw = _focused ? widget.focusBorderWidth : widget.borderWidth;
    final bc = _focused ? effectiveFocusBorder : effectiveBorder;

    return Container(
      decoration: BoxDecoration(
        color: effectiveFill,
        borderRadius: effectiveRadius,
        border: Border.all(color: bc, width: bw),
      ),
      padding: effectivePadding,
      child: Stack(
        children: [
          if (_controller.text.isEmpty && widget.hintText != null)
            IgnorePointer(
              child: Text(widget.hintText!, style: effectiveHintStyle, maxLines: 1),
            ),
          EditableText(
            controller: _controller,
            focusNode: _focusNode,
            style: effectiveStyle,
            cursorColor: theme.colorScheme.primary,
            backgroundCursorColor: theme.colorScheme.onSurfaceVariant,
            maxLines: widget.maxLines,
            minLines: widget.minLines,
            onChanged: (text) {
              setState(() {}); // refresh hint visibility
              widget.onChanged?.call(text);
            },
          ),
        ],
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// ChatKitCheckbox
// ---------------------------------------------------------------------------

/// A simple checkbox, replacing Material [Checkbox].
class ChatKitCheckbox extends StatelessWidget {
  const ChatKitCheckbox({
    super.key,
    required this.value,
    this.onChanged,
    this.size = 20,
  });

  final bool value;
  final ValueChanged<bool>? onChanged;
  final double size;

  @override
  Widget build(BuildContext context) {
    final theme = ChatKitTheme.of(context);
    return GestureDetector(
      onTap: onChanged != null ? () => onChanged!(!value) : null,
      child: Container(
        width: size,
        height: size,
        decoration: BoxDecoration(
          color: value ? theme.colorScheme.primary : const Color(0x00000000),
          borderRadius: BorderRadius.circular(4),
          border: Border.all(
            color: value ? theme.colorScheme.primary : theme.colorScheme.outline,
            width: 1.5,
          ),
        ),
        child: value
            ? Icon(
                const IconData(0xe156, fontFamily: 'MaterialIcons'),
                size: size - 4,
                color: theme.colorScheme.onPrimary,
              )
            : null,
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// ChatKitDropdown<T>
// ---------------------------------------------------------------------------

/// A dropdown selector using an overlay, replacing Material
/// [DropdownButtonFormField].
class ChatKitDropdown<T> extends StatefulWidget {
  const ChatKitDropdown({
    super.key,
    required this.items,
    this.value,
    this.onChanged,
    this.borderRadius,
    this.contentPadding,
  });

  final List<ChatKitDropdownItem<T>> items;
  final T? value;
  final ValueChanged<T>? onChanged;
  final BorderRadius? borderRadius;
  final EdgeInsetsGeometry? contentPadding;

  @override
  State<ChatKitDropdown<T>> createState() => _ChatKitDropdownState<T>();
}

class ChatKitDropdownItem<T> {
  const ChatKitDropdownItem({required this.value, required this.label});
  final T value;
  final String label;
}

class _ChatKitDropdownState<T> extends State<ChatKitDropdown<T>> {
  final LayerLink _layerLink = LayerLink();
  OverlayEntry? _overlayEntry;
  bool _open = false;

  String get _selectedLabel {
    for (final item in widget.items) {
      if (item.value == widget.value) return item.label;
    }
    return '';
  }

  void _toggle() {
    if (_open) {
      _close();
    } else {
      _openOverlay();
    }
  }

  void _openOverlay() {
    final theme = ChatKitTheme.of(context);
    final renderBox = context.findRenderObject()! as RenderBox;
    final size = renderBox.size;

    _overlayEntry = OverlayEntry(
      builder: (context) => GestureDetector(
        behavior: HitTestBehavior.translucent,
        onTap: _close,
        child: Stack(
          children: [
            CompositedTransformFollower(
              link: _layerLink,
              offset: Offset(0, size.height + 4),
              child: _DropdownMenu<T>(
                items: widget.items,
                theme: theme,
                width: size.width,
                onSelected: (value) {
                  widget.onChanged?.call(value);
                  _close();
                },
              ),
            ),
          ],
        ),
      ),
    );
    Overlay.of(context).insert(_overlayEntry!);
    setState(() => _open = true);
  }

  void _close() {
    _overlayEntry?.remove();
    _overlayEntry = null;
    if (mounted) setState(() => _open = false);
  }

  @override
  void dispose() {
    _overlayEntry?.remove();
    _overlayEntry = null;
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = ChatKitTheme.of(context);
    final radius = widget.borderRadius ?? theme.radius.mediumBorderRadius;
    final padding = widget.contentPadding ??
        EdgeInsets.symmetric(
          horizontal: theme.density.paddingLarge,
          vertical: theme.density.paddingMedium,
        );

    return CompositedTransformTarget(
      link: _layerLink,
      child: GestureDetector(
        onTap: _toggle,
        child: Container(
          decoration: BoxDecoration(
            borderRadius: radius,
            border: Border.all(color: theme.colorScheme.outline),
          ),
          padding: padding,
          child: Row(
            children: [
              Expanded(
                child: Text(_selectedLabel, style: theme.typography.bodyMedium),
              ),
              Icon(
                const IconData(0xe313, fontFamily: 'MaterialIcons'), // arrow_drop_down
                size: 20,
                color: theme.colorScheme.onSurfaceVariant,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _DropdownMenu<T> extends StatelessWidget {
  const _DropdownMenu({
    required this.items,
    required this.theme,
    required this.width,
    required this.onSelected,
  });

  final List<ChatKitDropdownItem<T>> items;
  final ChatKitThemeData theme;
  final double width;
  final ValueChanged<T> onSelected;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: theme.radius.mediumBorderRadius,
        border: Border.all(color: theme.colorScheme.outline),
        boxShadow: [
          BoxShadow(
            color: theme.colorScheme.shadow,
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: items.map((item) {
          return GestureDetector(
            onTap: () => onSelected(item.value),
            behavior: HitTestBehavior.opaque,
            child: Padding(
              padding: EdgeInsets.symmetric(
                horizontal: theme.density.paddingLarge,
                vertical: theme.density.paddingMedium,
              ),
              child: Text(item.label, style: theme.typography.bodyMedium),
            ),
          );
        }).toList(),
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// ChatKitPopupMenu<T>
// ---------------------------------------------------------------------------

/// A popup menu triggered by an icon tap, replacing Material [PopupMenuButton].
class ChatKitPopupMenu<T> extends StatefulWidget {
  const ChatKitPopupMenu({
    super.key,
    required this.icon,
    required this.items,
    this.onSelected,
    this.tooltip,
  });

  final Widget icon;
  final List<ChatKitPopupMenuItem<T>> items;
  final ValueChanged<T>? onSelected;
  final String? tooltip;

  @override
  State<ChatKitPopupMenu<T>> createState() => _ChatKitPopupMenuState<T>();
}

class ChatKitPopupMenuItem<T> {
  const ChatKitPopupMenuItem({required this.value, required this.child});
  final T value;
  final Widget child;
}

class _ChatKitPopupMenuState<T> extends State<ChatKitPopupMenu<T>> {
  final LayerLink _layerLink = LayerLink();
  OverlayEntry? _overlayEntry;

  void _show() {
    final theme = ChatKitTheme.of(context);
    final renderBox = context.findRenderObject()! as RenderBox;
    final size = renderBox.size;

    _overlayEntry = OverlayEntry(
      builder: (context) => GestureDetector(
        behavior: HitTestBehavior.translucent,
        onTap: _hide,
        child: Stack(
          children: [
            CompositedTransformFollower(
              link: _layerLink,
              offset: Offset(0, size.height + 4),
              child: _PopupMenuOverlay<T>(
                items: widget.items,
                theme: theme,
                onSelected: (value) {
                  _hide();
                  widget.onSelected?.call(value);
                },
              ),
            ),
          ],
        ),
      ),
    );
    Overlay.of(context).insert(_overlayEntry!);
  }

  void _hide() {
    _overlayEntry?.remove();
    _overlayEntry = null;
  }

  @override
  void dispose() {
    _overlayEntry?.remove();
    _overlayEntry = null;
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return CompositedTransformTarget(
      link: _layerLink,
      child: ChatKitIconButton(
        icon: widget.icon,
        onPressed: _show,
        tooltip: widget.tooltip,
      ),
    );
  }
}

class _PopupMenuOverlay<T> extends StatelessWidget {
  const _PopupMenuOverlay({
    required this.items,
    required this.theme,
    required this.onSelected,
  });

  final List<ChatKitPopupMenuItem<T>> items;
  final ChatKitThemeData theme;
  final ValueChanged<T> onSelected;

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: const BoxConstraints(minWidth: 200),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: theme.radius.mediumBorderRadius,
        border: Border.all(color: theme.colorScheme.outline),
        boxShadow: [
          BoxShadow(
            color: theme.colorScheme.shadow,
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: items.map((item) {
          return GestureDetector(
            onTap: () => onSelected(item.value),
            behavior: HitTestBehavior.opaque,
            child: Padding(
              padding: EdgeInsets.symmetric(
                horizontal: theme.density.paddingLarge,
                vertical: theme.density.paddingMedium,
              ),
              child: item.child,
            ),
          );
        }).toList(),
      ),
    );
  }
}
