import 'package:equatable/equatable.dart';

class ExperienceTeamEntity extends Equatable {
  const ExperienceTeamEntity(this.id, this.title, this.companyName,
      this.description, this.isCurrent, this.startDate, this.endDate);

  @override
  List<Object?> get props =>
      [id, title, companyName, description, isCurrent, startDate, endDate];

  final String id;
  final String title;
  final String companyName;
  final String description;
  final bool isCurrent;
  final DateTime startDate;
  final DateTime? endDate;

  //Factory Method
  ExperienceTeamEntity.fromJson(Map<String, dynamic> json)
      : id = json['id'],
        title = json['title'],
        companyName = json['company_name'],
        description = json['description'],
        isCurrent = json['is_current'],
        startDate = DateTime.parse(json['start_date']),
        endDate = DateTime.tryParse(json['end_date'].toString());
}
