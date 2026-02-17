/// A suggested prompt displayed on the start screen
class SuggestedPrompt {
  const SuggestedPrompt({
    required this.label,
    required this.prompt,
    this.icon,
  });

  final String label;
  final String prompt;
  final String? icon;
}

/// Configuration for the start screen
class StartScreenOption {
  const StartScreenOption({
    this.greeting,
    this.suggestedPrompts = const [],
  });

  final String? greeting;
  final List<SuggestedPrompt> suggestedPrompts;
}
