/// Represents an action dispatched from an interactive widget
class WidgetAction {
  const WidgetAction({
    required this.type,
    this.payload = const {},
  });

  final String type;
  final Map<String, dynamic> payload;

  factory WidgetAction.fromJson(Map<String, dynamic> json) {
    return WidgetAction(
      type: json['type'] as String,
      payload: Map<String, dynamic>.from(json)..remove('type'),
    );
  }

  Map<String, dynamic> toJson() => {
    'type': type,
    ...payload,
  };
}
