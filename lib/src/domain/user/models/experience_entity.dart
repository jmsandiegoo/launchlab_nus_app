import 'package:equatable/equatable.dart';
import 'package:launchlab/src/domain/user/models/user_entity.dart';

class ExperienceEntity extends Equatable {
  const ExperienceEntity(
      this.id,
      this.title,
      this.companyName,
      this.isCurrent,
      this.startDate,
      this.endDate,
      this.description,
      this.user,
      this.createdAt,
      this.updatedAt);

  final String id;
  final String title;
  final String companyName;
  final bool isCurrent;
  final DateTime startDate;
  final DateTime? endDate;
  final String description;
  final DateTime createdAt;
  final DateTime updatedAt;
  final UserEntity user;

  @override
  List<Object?> get props => [
        id,
        title,
        companyName,
        isCurrent,
        startDate,
        endDate,
        description,
        user
      ];
}
