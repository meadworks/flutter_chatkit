class Entity {
  const Entity({
    required this.id,
    required this.label,
    this.icon,
    this.inlineLabel,
    this.interactive = false,
    this.data,
    this.group,
  });
  final String id;
  final String label;
  final String? icon;
  final String? inlineLabel;
  final bool interactive;
  final Map<String, dynamic>? data;
  final String? group;

  factory Entity.fromJson(Map<String, dynamic> json) {
    return Entity(
      id: json['id'] as String,
      label: json['label'] as String,
      icon: json['icon'] as String?,
      inlineLabel: json['inline_label'] as String?,
      interactive: json['interactive'] as bool? ?? false,
      data: json['data'] as Map<String, dynamic>?,
      group: json['group'] as String?,
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'label': label,
    if (icon != null) 'icon': icon,
    if (inlineLabel != null) 'inline_label': inlineLabel,
    'interactive': interactive,
    if (data != null) 'data': data,
    if (group != null) 'group': group,
  };
}
