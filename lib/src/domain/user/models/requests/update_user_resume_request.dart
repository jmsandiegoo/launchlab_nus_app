import 'dart:io';

import 'package:equatable/equatable.dart';

class UpdateUserResumeRequest extends Equatable {
  const UpdateUserResumeRequest({required this.userResume});

  final File? userResume;

  @override
  List<Object?> get props => throw UnimplementedError();
}
