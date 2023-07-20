import 'dart:io';

import 'package:flutter/material.dart';
import 'package:launchlab/src/domain/user/models/user_resume_entity.dart';
import 'package:open_file/open_file.dart';

class ApplicantResume extends StatelessWidget {
  final UserResumeEntity resume;
  const ApplicantResume({super.key, required this.resume});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const SizedBox(height: 5.0),
        GestureDetector(
            onTap: () {
              OpenFile.open(resume.file.path);
            },
            child: Card(
                child: Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 20.0, vertical: 15.0),
                    child: Row(children: [
                      const Icon(Icons.description_outlined),
                      const SizedBox(
                        width: 5.0,
                      ),
                      Expanded(
                        child: Text(
                          resume.file.path.split(Platform.pathSeparator).last,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ]))))
      ],
    );
  }
}
