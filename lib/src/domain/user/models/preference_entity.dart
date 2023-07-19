import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:launchlab/src/domain/common/models/category_entity.dart';
import 'package:launchlab/src/domain/common/models/skill_entity.dart';

@immutable
class PreferenceEntity extends Equatable {
  const PreferenceEntity({
    this.id,
    required this.skillsInterests,
    required this.categories,
    this.createdAt,
    this.updatedAt,
    this.userId,
  });

  final String? id;
  final List<SkillEntity> skillsInterests;
  final List<CategoryEntity> categories;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  final String? userId;

  PreferenceEntity copyWith({
    String? id,
    List<SkillEntity>? skillsInterests,
    List<CategoryEntity>? categories,
    DateTime? createdAt,
    String? userId,
    DateTime? updatedAt,
  }) {
    return PreferenceEntity(
      id: id ?? this.id,
      skillsInterests: skillsInterests ?? this.skillsInterests,
      categories: categories ?? this.categories,
      userId: userId ?? this.userId,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  factory PreferenceEntity.fromJson(Map<String, dynamic> json) {
    final List<dynamic> skillsInterestsJson = json['skills_interests'];
    final List<dynamic> categoriesJson = json['categories'];

    final List<SkillEntity> skillsInterests = skillsInterestsJson
        .map((item) => SkillEntity.fromJson(item['selected_skills']))
        .toList();

    final List<CategoryEntity> categories = categoriesJson
        .map((item) => CategoryEntity.fromJson(item['categories']))
        .toList();

    return PreferenceEntity(
      id: json['id'],
      skillsInterests: skillsInterests,
      categories: categories,
      createdAt: DateTime.tryParse(json['created_at'].toString()),
      updatedAt: DateTime.tryParse(json['updated_at'].toString()),
      userId: json['user_id'],
    );
  }

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {
      'skills_interests': skillsInterests.map((item) => item.toJson()).toList(),
      'categories': categories.map((item) => item.toJson()).toList(),
      'created_at': createdAt?.toIso8601String(),
      'updated_at': updatedAt?.toIso8601String(),
    };

    if (id != null) {
      json['id'] = id;
    }

    return json;
  }

  @override
  List<Object?> get props => [
        id,
        skillsInterests,
        categories,
        userId,
      ];

  String getSkillString() {
    String skillStr = '';
    for (SkillEntity skill in skillsInterests) {
      skillStr += '${skill.name}, ';
    }
    return skillStr.substring(0, skillStr.length - 2);
  }
}
