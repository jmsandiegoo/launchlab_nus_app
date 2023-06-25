import 'package:equatable/equatable.dart';
import 'package:launchlab/src/domain/user/models/preference_entity.dart';

class UpdateUserSkillsRequest extends Equatable {
  const UpdateUserSkillsRequest({
    required this.userPreference,
  });

  final PreferenceEntity userPreference;

  Map<String, dynamic> toJson() {
    return {
      'preference': userPreference.toJson(),
    };
  }

  @override
  List<Object?> get props => [
        userPreference,
      ];
}
