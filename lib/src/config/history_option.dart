/// Configuration for the history panel
class HistoryOption {
  const HistoryOption({
    this.enabled = true,
    this.pageSize = 20,
  });

  final bool enabled;
  final int pageSize;
}
