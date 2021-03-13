import 'package:dartz/dartz.dart';

import 'package:gamecircle/core/usecases/usecases.dart';
import 'package:gamecircle/features/login/domain/repositories/login_repository.dart';
import 'package:gamecircle/core/errors/failure.dart';
import 'package:google_sign_in/google_sign_in.dart';

class PostGoogleLogin
    implements UseCase<GoogleSignInAuthentication?, NoParams> {
  final LoginRepository repository;

  PostGoogleLogin(this.repository);

  @override
  Future<Either<Failure, GoogleSignInAuthentication?>> call(
      NoParams params) async {
    return await repository.postGoogleLogin();
  }
}
