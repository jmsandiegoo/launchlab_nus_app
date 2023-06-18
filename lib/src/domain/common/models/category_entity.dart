import 'package:equatable/equatable.dart';

class CategoryEntity implements Equatable {
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
        createdAt = DateTime.tryParse(json['created_at']),
        updatedAt = DateTime.tryParse(json['updated_at']);

  @override
  String toString() {
    return name;
  }

  @override
  List<Object?> get props => [id, name];

  @override
  bool? get stringify => true;
}
