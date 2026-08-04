import 'failure.dart';

class AppException implements Exception {
  const AppException({required this.message, this.code});

  final String message;
  final String? code;

  Failure get failure => ServerFailure(message: message, code: code);

  @override
  String toString() => message;
}
