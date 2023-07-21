import 'package:equatable/equatable.dart';

class RoleEntity extends Equatable {
  const RoleEntity(this.id, this.title, this.description);

  @override
  List<Object?> get props => [id, title, description];

  final String id;
  final String title;
  final String description;

  RoleEntity.fromJson(Map<String, dynamic> json)
      : id = json['id'],
        title = json['title'],
        description = json['description'];
}
