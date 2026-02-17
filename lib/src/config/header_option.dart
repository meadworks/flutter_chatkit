/// Configuration for the chat header bar
class HeaderOption {
  const HeaderOption({
    this.title,
    this.showTitle = true,
    this.showModelPicker = false,
    this.showHistoryButton = true,
  });

  final String? title;
  final bool showTitle;
  final bool showModelPicker;
  final bool showHistoryButton;
}
