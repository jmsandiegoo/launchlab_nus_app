import 'package:equatable/equatable.dart';
import 'package:launchlab/src/domain/user/models/user_entity.dart';

class ExperienceEntity extends Equatable {
  const ExperienceEntity({
    this.id,
    required this.title,
    required this.companyName,
    required this.isCurrent,
    required this.startDate,
    this.endDate,
    required this.description,
    this.createdAt,
    this.updatedAt,
    this.user,
  });

  final String? id;
  final String title;
  final String companyName;
  final bool isCurrent;
  final DateTime startDate;
  final DateTime? endDate;
  final String description;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final UserEntity? user;

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
