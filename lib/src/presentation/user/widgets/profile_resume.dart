import 'dart:io';

import 'package:flutter/material.dart';
import 'package:launchlab/src/presentation/common/widgets/form_fields/file_upload.dart';
import 'package:launchlab/src/presentation/common/widgets/useful.dart';

class ProfileResume extends StatelessWidget {
  const ProfileResume(
      {super.key,
      this.userResume,
      required this.onChangedHandler,
      required this.isLoading});

  final File? userResume;
  final void Function(File?) onChangedHandler;
  final bool isLoading;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            subHeaderText("Resume"),
          ],
        ),
        const SizedBox(
          height: 15.0,
        ),
        FileUploadWidget(
          selectedFile: userResume,
          onFileUploadChangedHandler: onChangedHandler,
          isLoading: isLoading,
          allowedExtensions: const ["pdf"],
        ),
      ],
    );
  }
}
