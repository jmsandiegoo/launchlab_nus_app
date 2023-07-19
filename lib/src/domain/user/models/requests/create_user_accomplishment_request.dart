import 'package:equatable/equatable.dart';
import 'package:launchlab/src/domain/user/models/accomplishment_entity.dart';

class CreateUserAccomplishmentRequest extends Equatable {
  const CreateUserAccomplishmentRequest({
    required this.accomplishment,
  });

  final AccomplishmentEntity accomplishment;

  Map<String, dynamic> toJson() {
    return {
      'accomplishment': accomplishment.toJson(),
    };
  }

  @override
  List<Object?> get props => [
        accomplishment,
      ];
}
