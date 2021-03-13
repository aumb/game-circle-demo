import 'package:dartz/dartz.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';

import 'package:gamecircle/core/usecases/usecases.dart';
import 'package:gamecircle/features/login/domain/repositories/login_repository.dart';
import 'package:gamecircle/core/errors/failure.dart';

class PostFacebookLogin implements UseCase<AccessToken?, NoParams> {
  final LoginRepository repository;

  PostFacebookLogin(this.repository);

  @override
  Future<Either<Failure, AccessToken?>> call(NoParams params) async {
    return await repository.postFacebookLogin();
  }
}
