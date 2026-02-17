/// Configuration for actions on thread items (feedback, copy, retry)
class ThreadItemActionsOption {
  const ThreadItemActionsOption({
    this.showFeedback = true,
    this.showCopy = true,
    this.showRetry = true,
  });

  final bool showFeedback;
  final bool showCopy;
  final bool showRetry;
}
