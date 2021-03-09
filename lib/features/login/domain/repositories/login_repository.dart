import 'package:dartz/dartz.dart';

import 'package:gamecircle/core/errors/failure.dart';
import 'package:gamecircle/features/login/domain/entities/token.dart';

abstract class LoginRepository {
  Future<Either<Failure, Token>> postEmailLogin({
    required String? email,
    required String? password,
  });

  Future<Either<Failure, Token>> postSocialLogin({
    required String? provider,
    required String? token,
  });
}
