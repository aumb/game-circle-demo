import 'package:dartz/dartz.dart';
import 'package:gamecircle/core/entities/token.dart';
import 'package:gamecircle/core/errors/failure.dart';

abstract class AuthenticationRepository {
  Future<Either<Failure, Token?>> getCachedToken();
}
