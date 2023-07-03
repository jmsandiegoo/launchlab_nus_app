/// Represents all possible app failures

class Failure implements Exception {
  final String? code;
  final String? message;

  /// Private constructor
  const Failure._({this.code, this.message});

  /// 401 Failure
  factory Failure.unauthorized(
          {String? code, String message = "Authentication error occured."}) =>
      _UnauthorizedFailure(code: code, message: message);

  /// 400 / 500 error
  factory Failure.request(
          {String? code,
          String message = "Request failed please try again."}) =>
      _RequestFailure(code: code, message: message);

  /// Unexpected
  factory Failure.unexpected(
          {String? code, String message = "Unexpected error occured."}) =>
      _UnexpectedFailure(code: code, message: message);

  /// Get the error message for specified failure
  String get errorMessage => message ?? '$this';
}

class _UnauthorizedFailure extends Failure {
  const _UnauthorizedFailure({String? code, String? message})
      : super._(code: code, message: message);
}

class _RequestFailure extends Failure {
  const _RequestFailure({String? code, String? message})
      : super._(code: code, message: message);
}

class _UnexpectedFailure extends Failure {
  const _UnexpectedFailure({String? code, String? message})
      : super._(message: message);
}
