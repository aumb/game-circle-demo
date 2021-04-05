import 'package:dio/dio.dart';
import 'package:gamecircle/core/utils/safe_print.dart';

class ServerException implements Exception {
  final ServerError error;

  ServerException(this.error);

  static ServerError handleError(dynamic e) {
    safePrint(e.toString());
    if (e is ServerException) {
      throw e;
    } else if (e is DioError) {
      final serverError = ServerError.fromJson(e.response?.data);
      throw ServerException(serverError);
    } else {
      final serverError = ServerError.fromJson(null);
      throw ServerException(serverError);
    }
  }
}

class CacheException implements Exception {}

class ServerError {
  final String? message;
  final int? code;

  ServerError({
    required this.message,
    required this.code,
  });

  factory ServerError.fromJson(Map<String, dynamic>? json) {
    if (json != null) {
      return ServerError(
        message: (json['error'] is String)
            ? json['error']
            : _getErrorsFromMap(json['error']),
        code: (json['code'] is int) ? json['code'] : 500,
      );
    } else {
      return ServerError(code: 500, message: "unexpected_error");
    }
  }

  static _getErrorsFromMap(Map<String, dynamic>? json) {
    final List firstListError = json?.values.first;
    final String firstError = firstListError.first;

    return firstError;
  }
}
