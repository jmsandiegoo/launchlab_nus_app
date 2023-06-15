import 'package:equatable/equatable.dart';
import 'package:launchlab/src/domain/user/models/degree_programme_entity.dart';

class UserEntity extends Equatable {
  const UserEntity(
    this.id,
    this.isOnboarded,
    this.firstName,
    this.lastName,
    this.title,
    this.avatar,
    this.resume,
    this.degreeProgramme,
  );

  final String? id;
  final bool isOnboarded;
  final String firstName;
  final String lastName;
  final String title;
  final String avatar;
  final String resume;

  final DegreeProgrammeEntity? degreeProgramme;

  @override
  List<Object?> get props => [
        id,
        isOnboarded,
        firstName,
        lastName,
        title,
        avatar,
        resume,
      ];
}
