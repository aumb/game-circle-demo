import 'package:dartz/dartz.dart';
import 'package:gamecircle/core/entities/token.dart';
import 'package:gamecircle/core/errors/exceptions.dart';
import 'package:gamecircle/core/errors/failure.dart';
import 'package:gamecircle/features/authentication/data/datasources/authentication_local_data_source.dart';
import 'package:gamecircle/features/authentication/domain/repositories/authentication_repository.dart';

class AuthenticationRepositoryImpl implements AuthenticationRepository {
  final AuthenticationLocalDataSource localDataSource;

  const AuthenticationRepositoryImpl({
    required this.localDataSource,
  });

  @override
  Future<Either<Failure, Token?>> getCachedToken() async {
    try {
      final remoteToken = await localDataSource.getCachedToken();
      return Right(remoteToken);
    } on ServerException catch (e) {
      return Left(ServerFailure.fromServerException(e.error));
    }
  }
}
