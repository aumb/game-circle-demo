class ServerException implements Exception {
  final ServerError error;

  ServerException(this.error);
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
        code: json['code'],
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
