import 'package:dartz/dartz.dart';
import 'package:gamecircle/core/entities/token.dart';

import 'package:gamecircle/core/usecases/usecases.dart';
import 'package:gamecircle/features/authentication/domain/repositories/authentication_repository.dart';
import 'package:gamecircle/core/errors/failure.dart';

class GetCachedToken implements UseCase<Token?, NoParams> {
  final AuthenticationRepository repository;

  GetCachedToken(this.repository);

  @override
  Future<Either<Failure, Token?>> call(NoParams params) async {
    return await repository.getCachedToken();
  }
}
