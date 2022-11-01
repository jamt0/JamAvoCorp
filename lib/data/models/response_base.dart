import 'dart:io';
import 'package:dio/dio.dart';
import 'package:equatable/equatable.dart';
import 'package:telling/utils/helpers/cool_functions.dart';

class ErrorInputMessage {
  final String id;
  final String? message;

  ErrorInputMessage({required this.id, required this.message});

  factory ErrorInputMessage.fromJson(Map<String, dynamic> json) {
    return ErrorInputMessage(
      id: json['id'],
      message: json['message'],
    );
  }
}

class ResponseBase<T> extends Equatable {
  final bool error;
  final int? statusCode;
  final String? message;
  final T? data;
  final List<ErrorInputMessage>? errors;

  ResponseBase({
    required this.statusCode,
    required this.error,
    this.message,
    this.data,
    this.errors,
  });

  get success {
    return !this.error;
  }

  factory ResponseBase.fromJson(Map<String, dynamic> json,
      T Function(Map<String, dynamic>? data) mapper) {
    return ResponseBase(
      error: json['error'],
      message: json['message'],
      statusCode: HttpStatus.ok,
      data: mapper({"data": json['data']}),
      errors: listFromJson(json['errors'], ErrorInputMessage.fromJson),
    );
  }

  factory ResponseBase.fromError(DioError error) {
    return ResponseBase(
      error: true,
      message: (error.response?.data["message"] != null)
          ? error.response?.data["message"]
          : "Response with status code [${error.response?.statusCode}]",
      statusCode: error.response?.statusCode,
      errors: listFromJson(
        error.response?.data["errors"],
        ErrorInputMessage.fromJson,
      ),
    );
  }

  @override
  List<Object?> get props => [
        error,
        statusCode,
        message,
        data,
      ];
}
