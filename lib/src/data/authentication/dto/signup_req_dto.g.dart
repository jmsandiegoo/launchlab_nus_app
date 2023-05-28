// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'signup_req_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

SignupReqDTO _$SignupReqDTOFromJson(Map<String, dynamic> json) => SignupReqDTO(
      email: json['email'] as String,
      password: json['password'] as String,
    );

Map<String, dynamic> _$SignupReqDTOToJson(SignupReqDTO instance) =>
    <String, dynamic>{
      'email': instance.email,
      'password': instance.password,
    };
