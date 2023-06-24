/// Represents all possible app failures

class Failure implements Exception {
  final String? message;

  /// private constructor
  const Failure._({this.message});

  /// 401 Failure
  const factory Failure.unauthorized() = _UnauthorizedFailure;

  /// 400 error
  const factory Failure.badRequest() = _BadRequestFailure;

  /// Get the error message for specified failure
  String get errorMessage => message ?? '$this';
}

class _UnauthorizedFailure extends Failure {
  const _UnauthorizedFailure() : super._();
}

class _BadRequestFailure extends Failure {
  const _BadRequestFailure() : super._();
}
