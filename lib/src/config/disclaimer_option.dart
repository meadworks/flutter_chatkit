/// Configuration for the disclaimer text
class DisclaimerOption {
  const DisclaimerOption({
    this.text,
    this.enabled = false,
  });

  final String? text;
  final bool enabled;
}
