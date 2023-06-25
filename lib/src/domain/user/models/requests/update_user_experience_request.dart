import 'package:equatable/equatable.dart';
import 'package:launchlab/src/domain/user/models/experience_entity.dart';

class UpdateUserExperienceRequest extends Equatable {
  const UpdateUserExperienceRequest({
    required this.experience,
  });

  final ExperienceEntity experience;

  Map<String, dynamic> toJson() {
    return {
      'experience': experience.toJson(),
    };
  }

  @override
  List<Object?> get props => [
        experience,
      ];
}
