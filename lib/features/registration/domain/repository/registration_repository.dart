import 'package:dartz/dartz.dart';

import 'package:gamecircle/core/errors/failure.dart';
import 'package:gamecircle/core/entities/token.dart';

abstract class RegistrationRepository {
  Future<Either<Failure, Token?>> postEmailRegistration({
    String? email,
    String? name,
    String? password,
    String? confirmPassword,
  });
}
