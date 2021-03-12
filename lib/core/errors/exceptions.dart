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
    return ServerError(
      message: json?['error'],
      code: json?['code'],
    );
  }
}
