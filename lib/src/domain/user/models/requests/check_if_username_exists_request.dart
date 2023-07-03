import 'package:equatable/equatable.dart';

class CheckIfUsernameExistsRequest extends Equatable {
  const CheckIfUsernameExistsRequest({
    required this.username,
    this.currUsername,
  });

  final String username;
  final String? currUsername;

  @override
  List<Object?> get props => [
        username,
        currUsername,
      ];
}
