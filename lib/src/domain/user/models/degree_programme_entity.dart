import 'package:equatable/equatable.dart';

class DegreeProgrammeEntity implements Equatable {
  const DegreeProgrammeEntity(this.id, this.type, this.name);

  final String id;
  final String type;
  final String name;

  @override
  String toString() {
    return name;
  }

  @override
  List<Object?> get props => [id, type, name];

  @override
  bool? get stringify => true;
}
