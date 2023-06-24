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

  ExperienceEntity copyWith({
    String? id,
    String? title,
    String? companyName,
    bool? isCurrent,
    DateTime? startDate,
    DateTime? endDate,
    String? description,
    DateTime? createdAt,
    DateTime? updatedAt,
    final String? userId,
  }) {
    return ExperienceEntity(
      title: title ?? this.title,
      companyName: companyName ?? this.companyName,
      isCurrent: isCurrent ?? this.isCurrent,
      startDate: startDate ?? this.startDate,
      endDate: endDate ?? this.endDate,
      description: description ?? this.description,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      userId: userId ?? this.userId,
    );
  }

  ExperienceEntity.fromJson(Map<String, dynamic> json)
      : id = json['id'],
        title = json['title'],
        companyName = json['company_name'],
        isCurrent = json['is_current'],
        startDate = DateTime.parse(json['start_date']),
        endDate = DateTime.tryParse(json['end_date'].toString()),
        description = json['description'],
        createdAt = DateTime.tryParse(json['created_at'].toString()),
        updatedAt = DateTime.tryParse(json['updated_at'].toString()),
        userId = json['user_id'];

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
