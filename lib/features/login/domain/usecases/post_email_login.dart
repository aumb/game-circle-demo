import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';

import 'package:gamecircle/core/usecases/usecases.dart';
import 'package:gamecircle/features/login/domain/entities/token.dart';
import 'package:gamecircle/features/login/domain/repositories/login_repository.dart';
import 'package:gamecircle/core/errors/failure.dart';

class PostEmailLogin implements UseCase<Token?, PostEmailLoginParams> {
  final LoginRepository repository;

  PostEmailLogin(this.repository);

  @override
  Future<Either<Failure, Token?>> call(PostEmailLoginParams params) async {
    return await repository.postEmailLogin(
      params.email,
      params.password,
    );
  }
}

class PostEmailLoginParams extends Equatable {
  final String? email;
  final String? password;

  PostEmailLoginParams({
    required this.email,
    required this.password,
  });

  @override
  List<Object?> get props => [email, password];
}
