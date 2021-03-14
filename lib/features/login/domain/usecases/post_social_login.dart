import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';

import 'package:gamecircle/core/usecases/usecases.dart';
import 'package:gamecircle/core/entities/token.dart';
import 'package:gamecircle/features/login/domain/repositories/login_repository.dart';
import 'package:gamecircle/core/errors/failure.dart';

class PostSocialLogin implements UseCase<Token?, PostSocialLoginParams> {
  final LoginRepository repository;

  PostSocialLogin(this.repository);

  @override
  Future<Either<Failure, Token?>> call(PostSocialLoginParams params) async {
    return await repository.postSocialLogin(
      params.provider,
      params.token,
    );
  }
}

class PostSocialLoginParams extends Equatable {
  final String? provider;
  final String? token;

  PostSocialLoginParams({
    required this.provider,
    required this.token,
  });

  @override
  List<Object?> get props => [provider, token];
}
