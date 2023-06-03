import 'dart:io';
import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

@immutable
class OnboardingStep1PageState extends Equatable {
  final File? image;

  const OnboardingStep1PageState({this.image});

  @override
  List<Object?> get props => [image];
}

class OnboardingStep1PageCubit extends Cubit<OnboardingStep1PageState> {
  OnboardingStep1PageCubit() : super(const OnboardingStep1PageState());

  void handleImagePick(File? image) {
    emit(OnboardingStep1PageState(image: image));
  }
}
