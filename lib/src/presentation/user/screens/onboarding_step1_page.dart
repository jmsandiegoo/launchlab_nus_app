import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:launchlab/src/presentation/common/widgets/form/picture_upload_picker.dart';
import 'package:launchlab/src/presentation/common/widgets/useful.dart';
import 'package:launchlab/src/presentation/user/cubits/onboarding_step1_page_cubit.dart';

class OnboardingStep1Page extends StatelessWidget {
  const OnboardingStep1Page({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => OnboardingStep1PageCubit(),
      child: BlocBuilder<OnboardingStep1PageCubit, OnboardingStep1PageState>(
        builder: (context, state) {
          final onboardingStep1PageCubit =
              BlocProvider.of<OnboardingStep1PageCubit>(context);
          return ListView(
            children: [
              headerText("Tell us about yourself"),
              PictureUploadPicker(
                imageHandler: (image) =>
                    onboardingStep1PageCubit.handleImagePick(image),
                image: state.image,
              ),
            ],
          );
        },
      ),
    );
  }
}
