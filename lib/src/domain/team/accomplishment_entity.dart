import 'package:equatable/equatable.dart';

class AccomplishmentTeamEntity extends Equatable {
  const AccomplishmentTeamEntity(this.id, this.title, this.issuer,
      this.description, this.isActive, this.startDate, this.endDate);

  @override
  List<Object?> get props =>
      [id, title, issuer, description, isActive, startDate, endDate];

  final String id;
  final String title;
  final String issuer;
  final String description;
  final bool isActive;
  final DateTime startDate;
  final DateTime? endDate;

  //Factory Method
  AccomplishmentTeamEntity.fromJson(Map<String, dynamic> json)
      : id = json['id'],
        title = json['title'],
        issuer = json['issuer'],
        description = json['description'],
        isActive = json['is_active'],
        startDate = DateTime.parse(json['start_date']),
        endDate = DateTime.tryParse(json['end_date'].toString());
}
