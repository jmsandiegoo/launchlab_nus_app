import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

@immutable
class OnboardingContainerState extends Equatable {
  const OnboardingContainerState();

  @override
  List<Object?> get props => [];
}

class OnboardingContainerCubit extends Cubit<OnboardingContainerState> {
  OnboardingContainerCubit() : super(const OnboardingContainerState());
}
