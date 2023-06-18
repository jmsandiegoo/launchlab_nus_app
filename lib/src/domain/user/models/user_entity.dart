import 'package:equatable/equatable.dart';

class UserEntity extends Equatable {
  const UserEntity({
    this.id,
    required this.isOnboarded,
    this.firstName,
    this.lastName,
    this.title,
    this.avatar,
    this.resume,
    this.degreeProgramme,
    this.createdAt,
    this.updatedAt,
  });

  final String? id;
  final bool isOnboarded;
  final String? firstName;
  final String? lastName;
  final String? title;
  final String? avatar;
  final String? resume;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  final String? degreeProgramme;

  UserEntity.fromJson(Map<String, dynamic> json)
      : id = json['id'],
        isOnboarded = json['is_onboarded'],
        firstName = json['first_name'],
        lastName = json['last_name'],
        title = json['last_name'],
        avatar = json['avatar'],
        resume = json['resume'],
        degreeProgramme = json['degree_programme'],
        createdAt = DateTime.tryParse(json['created_at']),
        updatedAt = DateTime.tryParse(json['updated_at']);

  @override
  List<Object?> get props => [
        id,
        isOnboarded,
        firstName,
        lastName,
        title,
        avatar,
        resume,
        degreeProgramme,
        createdAt,
        updatedAt,
      ];
}
