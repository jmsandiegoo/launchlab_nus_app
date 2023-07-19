import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';
import 'package:launchlab/src/domain/user/models/user_entity.dart';

@immutable
class OnboardUserRequest extends Equatable {
  const OnboardUserRequest({
    required this.user,
  });

  final UserEntity user;

  OnboardUserRequest copyWith({
    UserEntity? user,
  }) {
    return OnboardUserRequest(
      user: user ?? this.user,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'user': user.toJsonWithRelations(),
    };
  }

  @override
  List<Object?> get props => [
        user,
      ];
}
