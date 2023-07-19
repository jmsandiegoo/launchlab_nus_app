import 'package:equatable/equatable.dart';
import 'package:launchlab/src/domain/common/models/skill_entity.dart';

class SearchFilterEntity extends Equatable {
  const SearchFilterEntity(
      {this.categoryInput = '',
      this.commitmentInput = '',
      this.interestInput = const []});

  @override
  List<Object?> get props => [categoryInput, commitmentInput, interestInput];

  final String categoryInput;
  final String commitmentInput;
  final List<SkillEntity> interestInput;

  String interestFilterString() {
    String interestString = '';
    if (interestInput.isEmpty) {
      return 'interest_name.neq.{}';
    } else {
      for (SkillEntity interest in interestInput) {
        interestString += 'interest_name.cs.{"${interest.toString()}"}, ';
      }
      return interestString.substring(0, interestString.length - 2);
    }
  }
}
