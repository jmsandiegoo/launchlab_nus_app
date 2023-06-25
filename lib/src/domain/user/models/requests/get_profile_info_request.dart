import 'package:equatable/equatable.dart';

class GetProfileInfoRequest extends Equatable {
  const GetProfileInfoRequest({required this.userId});

  final String userId;
  @override
  List<Object?> get props => [userId];
}
