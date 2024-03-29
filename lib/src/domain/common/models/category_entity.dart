import 'package:equatable/equatable.dart';

class CategoryEntity extends Equatable {
  const CategoryEntity({
    required this.id,
    required this.name,
    this.createdAt,
    this.updatedAt,
  });

  final String id;
  final String name;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  CategoryEntity.fromJson(Map<String, dynamic> json)
      : id = json['id'],
        name = json['name'],
        createdAt = DateTime.tryParse(json['created_at'].toString()),
        updatedAt = DateTime.tryParse(json['updated_at'].toString());

  Map<String, dynamic> toJson() {
    return {
      'id': id,
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
  List<Object?> get props => [
        id,
        name,
        createdAt,
        updatedAt,
      ];

  @override
  bool? get stringify => true;
}
