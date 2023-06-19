import 'package:equatable/equatable.dart';

class SkillEntity implements Equatable {
  const SkillEntity({
    this.id,
    required this.emsiId,
    required this.name,
    this.createdAt,
    this.updatedAt,
  });

  final String? id;
  final String emsiId;
  final String name;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  SkillEntity.fromJsonEmsi(Map<String, dynamic> json)
      : id = null,
        emsiId = json['id'],
        name = json['name'],
        createdAt = null,
        updatedAt = null;

  SkillEntity.fromJson(Map<String, dynamic> json)
      : id = json['id'],
        emsiId = json['emsi_id'],
        name = json['name'],
        createdAt = DateTime.tryParse(json['created_at']),
        updatedAt = DateTime.tryParse(json['updated_at']);

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'emsi_id': emsiId,
      'name': name,
      'created_at': createdAt?.toIso8601String(),
      'updated_at': updatedAt?.toIso8601String(),
    };
  }

  @override
  String toString() {
    return name;
  }

  @override
  List<Object?> get props => [id, name];

  @override
  bool? get stringify => true;
}
