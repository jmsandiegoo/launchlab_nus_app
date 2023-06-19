import 'package:equatable/equatable.dart';

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
    this.userId,
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

  final String? userId;

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'issuer': issuer,
      'is_active': isActive,
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
        issuer,
        isActive,
        startDate,
        endDate,
        description,
        createdAt,
        updatedAt,
        userId,
      ];
}
