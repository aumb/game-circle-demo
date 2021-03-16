import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';

import 'package:gamecircle/core/usecases/usecases.dart';
import 'package:gamecircle/core/entities/token.dart';
import 'package:gamecircle/core/errors/failure.dart';
import 'package:gamecircle/features/registration/domain/repository/registration_repository.dart';

class PostEmailRegistration
    implements UseCase<Token?, PostEmailRegistrationParams> {
  final RegistrationRepository repository;

  PostEmailRegistration(this.repository);

  @override
  Future<Either<Failure, Token?>> call(
      PostEmailRegistrationParams params) async {
    return await repository.postEmailRegistration(
      email: params.email,
      name: params.name,
      password: params.password,
      confirmPassword: params.confirmPassword,
    );
  }
}

class PostEmailRegistrationParams extends Equatable {
  final String? email;
  final String? name;
  final String? password;
  final String? confirmPassword;

  PostEmailRegistrationParams({
    required this.email,
    required this.name,
    required this.password,
    required this.confirmPassword,
  });

  @override
  List<Object?> get props => [
        email,
        name,
        password,
        confirmPassword,
      ];
}
