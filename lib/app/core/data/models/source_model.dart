import '../../domain/entities/source_entity.dart';

class SourceModel extends SourceEntity {
  SourceModel({
    super.id,
    required super.name,
  });

  factory SourceModel.fromJson(Map<dynamic, dynamic> json) {
    return SourceModel(
      id: json['id'] as String?,
      name: json['name'] as String? ?? 'Unknown',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
    };
  }
}
