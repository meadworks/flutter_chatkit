/// Callback type for widget action dispatch
typedef WidgetActionCallback = Future<void> Function(
  String threadId,
  String itemId,
  Map<String, dynamic> action,
);

/// Configuration for the widget system
class WidgetsOption {
  const WidgetsOption({
    this.onAction,
  });

  final WidgetActionCallback? onAction;
}
