import 'package:equatable/equatable.dart';

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
    this.userId,
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

  final String? userId;

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'company_name': companyName,
      'is_current': isCurrent,
      'start_date': startDate.toIso8601String(),
      'end_date': endDate?.toIso8601String(),
      'description': description,
      'created_at': createdAt?.toIso8601String(),
      'updated_at': updatedAt?.toIso8601String(),
      'user_id': userId,
    };
  }

  @override
  List<Object?> get props => [
        id,
        title,
        companyName,
        isCurrent,
        startDate,
        endDate,
        description,
        userId,
      ];
}
