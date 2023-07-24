import 'dart:core';

import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';
import 'package:launchlab/src/domain/user/models/user_entity.dart';

@immutable
class GetProfileInfoResponse extends Equatable {
  const GetProfileInfoResponse({
    required this.userProfile,
  });

  final UserEntity userProfile;

  @override
  List<Object?> get props => [
        userProfile,
      ];
}
