import 'package:equatable/equatable.dart';
import 'package:launchlab/src/domain/user/models/accomplishment_entity.dart';

class DeleteUserAccomplishmentRequest extends Equatable {
  const DeleteUserAccomplishmentRequest({
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
