import 'package:equatable/equatable.dart';

class MilestoneEntity extends Equatable {
  const MilestoneEntity(this.id, this.title, this.isCompleted, this.startDate,
      this.endDate, this.description);

  @override
  List<Object?> get props =>
      [id, title, isCompleted, startDate, endDate, description];

  final String id;
  final String title;
  final bool isCompleted;
  final String description;
  final DateTime startDate;
  final DateTime endDate;

  //Factory Method
  MilestoneEntity.fromJson(Map<String, dynamic> json)
      : id = json['id'],
        title = json['title'],
        isCompleted = json['is_completed'],
        description = json['description'] ?? "",
        startDate = DateTime.parse(json['start_date']),
        endDate = DateTime.parse(json['end_date']);
}
