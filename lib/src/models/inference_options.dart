class ToolChoice {
  const ToolChoice({required this.id});
  final String id;

  factory ToolChoice.fromJson(Map<String, dynamic> json) {
    return ToolChoice(id: json['id'] as String);
  }

  Map<String, dynamic> toJson() => {'id': id};
}

class InferenceOptions {
  const InferenceOptions({this.toolChoice, this.model});
  final ToolChoice? toolChoice;
  final String? model;

  factory InferenceOptions.fromJson(Map<String, dynamic> json) {
    return InferenceOptions(
      toolChoice: json['tool_choice'] != null
          ? ToolChoice.fromJson(
              json['tool_choice'] as Map<String, dynamic>,)
          : null,
      model: json['model'] as String?,
    );
  }

  Map<String, dynamic> toJson() => {
    if (toolChoice != null) 'tool_choice': toolChoice!.toJson(),
    if (model != null) 'model': model,
  };
}
