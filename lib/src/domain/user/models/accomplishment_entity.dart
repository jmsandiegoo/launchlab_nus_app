import 'package:equatable/equatable.dart';
import 'package:launchlab/src/domain/user/models/user_entity.dart';

class AccomplishmentEntity extends Equatable {
  const AccomplishmentEntity({
    this.id,
    required this.title,
    required this.issuer,
    required this.isActive,
    required this.startDate,
    this.endDate,
    required this.description,
    this.createdAt,
    this.updatedAt,
    this.user,
  });

  final String? id;
  final String title;
  final String issuer;
  final bool isActive;
  final DateTime startDate;
  final DateTime? endDate;
  final String? description;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final UserEntity? user;

  @override
  List<Object?> get props => [
        id,
        title,
        issuer,
        isActive,
        startDate,
        endDate,
        description,
        createdAt,
        updatedAt
      ];
}