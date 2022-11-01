import 'package:equatable/equatable.dart';
import 'package:telling/data/models/response_base.dart';

class Failure extends Equatable {
  const Failure({
    this.error = true,
    this.statusCode,
    this.message,
    this.errors,
  });

  final bool? error;
  final String? message;
  final int? statusCode;
  final List<ErrorInputMessage>? errors;

  factory Failure.fromResponse(ResponseBase response) {
    return Failure(
      message: response.message,
      statusCode: response.statusCode,
      errors: response.errors,
    );
  }

  @override
  List<Object?> get props => [
        error,
        statusCode,
        message,
        errors,
      ];
}

class UnauthorizedFailure extends Failure {}

class UnhandledFailure extends Failure {
  Exception exception;

  UnhandledFailure({
    required this.exception,
  });
}
