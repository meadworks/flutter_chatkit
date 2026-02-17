import '../models/entity.dart';

/// Configuration for @-mention entities
class EntitiesOption {
  const EntitiesOption({
    this.entities = const [],
    this.enabled = false,
  });

  final List<Entity> entities;
  final bool enabled;
}
