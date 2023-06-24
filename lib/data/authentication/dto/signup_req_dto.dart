import 'package:json_annotation/json_annotation.dart';

/// states that this class in this file can access the private
/// generated implementation of json serialization.
part 'signup_req_dto.g.dart';

@JsonSerializable()
class SignupReqDTO {
  SignupReqDTO({
    required this.email,
    required this.password,
  });
  final String email;
  final String password;

  factory SignupReqDTO.fromJson(Map<String, dynamic> json) =>
      _$SignupReqDTOFromJson(json);

  Map<String, dynamic> toJson() => _$SignupReqDTOToJson(this);
}
