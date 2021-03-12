import 'package:equatable/equatable.dart';
import 'package:gamecircle/core/errors/exceptions.dart';

abstract class Failure extends Equatable {
  @override
  List<Object?> get props => [];
}

class ServerFailure extends Failure {
  final String? message;
  final int? code;

  ServerFailure({required this.message, required this.code});

  factory ServerFailure.fromServerException(ServerError? error) {
    return ServerFailure(
      code: error?.code ?? 500,
      message: error?.message ?? 'An unexpected error has occured',
    );
  }
}
