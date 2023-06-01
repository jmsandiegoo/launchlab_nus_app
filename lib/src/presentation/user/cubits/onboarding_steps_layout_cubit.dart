import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

@immutable
class OnboardingStepsLayoutState extends Equatable {
  final int steps;
  final int currStep;

  const OnboardingStepsLayoutState({this.steps = 4, this.currStep = 1});

  @override
  List<Object?> get props => [steps, currStep];
}

class OnboardingStepsLayoutCubit extends Cubit<OnboardingStepsLayoutState> {
  OnboardingStepsLayoutCubit() : super(const OnboardingStepsLayoutState());

  void handleNextStep() {
    emit(OnboardingStepsLayoutState(currStep: state.currStep + 1));
  }

  void handlePrevStep() {
    emit(OnboardingStepsLayoutState(currStep: state.currStep - 1));
  }
}
