/// Configuration for the chat header bar
class HeaderOption {
  const HeaderOption({
    this.title,
    this.show = true,
    this.showTitle = true,
    this.showModelPicker = false,
    this.showHistoryButton = true,
  });

  /// Whether to show the header bar at all.
  /// When false, the entire header (including the new chat button) is hidden.
  final bool show;
  final String? title;
  final bool showTitle;
  final bool showModelPicker;
  final bool showHistoryButton;
}
