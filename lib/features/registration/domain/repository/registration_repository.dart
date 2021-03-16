import 'package:dartz/dartz.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';

import 'package:gamecircle/core/errors/failure.dart';
import 'package:gamecircle/core/entities/token.dart';
import 'package:google_sign_in/google_sign_in.dart';

abstract class RegistrationRepository {
  Future<Either<Failure, Token?>> postEmailRegistration({
    String? email,
    String? name,
    String? password,
    String? confirmPassword,
  });
}
