/// A model choice displayed in the model picker
class ModelItem {
  const ModelItem({
    required this.id,
    required this.label,
    this.description,
  });

  final String id;
  final String label;
  final String? description;
}

/// Configuration for model selection
class ModelOption {
  const ModelOption({
    this.models = const [],
    this.defaultModelId,
  });

  final List<ModelItem> models;
  final String? defaultModelId;
}
