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

  AccomplishmentEntity copyWith({
    String? id,
    String? title,
    String? issuer,
    bool? isActive,
    DateTime? startDate,
    DateTime? endDate,
    String? description,
    DateTime? createdAt,
    DateTime? updatedAt,
    String? userId,
  }) {
    return AccomplishmentEntity(
      id: id ?? this.id,
      title: title ?? this.title,
      issuer: issuer ?? this.issuer,
      isActive: isActive ?? this.isActive,
      startDate: startDate ?? this.startDate,
      endDate: endDate,
      description: description ?? this.description,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      userId: userId ?? this.userId,
    );
  }

  AccomplishmentEntity.fromJson(Map<String, dynamic> json)
      : id = json['id'],
        title = json['title'],
        issuer = json["issuer"],
        isActive = json["is_active"],
        startDate = DateTime.parse(json["start_date"]),
        endDate = DateTime.tryParse(json["end_date"].toString()),
        description = json["description"],
        createdAt = DateTime.tryParse(json["created_at"].toString()),
        updatedAt = DateTime.tryParse(json["updated_at"].toString()),
        userId = json["user_id"];

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {
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

    if (id != null) {
      json['id'] = id;
    }

    return json;
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
