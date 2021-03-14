import 'package:dartz/dartz.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';

import 'package:gamecircle/core/errors/failure.dart';
import 'package:gamecircle/core/entities/token.dart';
import 'package:google_sign_in/google_sign_in.dart';

abstract class LoginRepository {
  Future<Either<Failure, Token?>> postEmailLogin(
    String? email,
    String? password,
  );

  Future<Either<Failure, Token?>> postSocialLogin(
    String? provider,
    String? token,
  );

  Future<Either<Failure, GoogleSignInAuthentication?>> postGoogleLogin();

  Future<Either<Failure, AccessToken?>> postFacebookLogin();
}
