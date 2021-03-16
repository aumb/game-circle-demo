import 'package:gamecircle/core/errors/exceptions.dart';
import 'package:gamecircle/core/entities/token.dart';
import 'package:gamecircle/core/errors/failure.dart';
import 'package:dartz/dartz.dart';
import 'package:gamecircle/features/registration/data/datasources/registration_local_data_source.dart';
import 'package:gamecircle/features/registration/data/datasources/registration_remote_data_source.dart';
import 'package:gamecircle/features/registration/domain/repository/registration_repository.dart';

class RegistrationRepositoryImpl implements RegistrationRepository {
  final RegistrationRemoteDataSource remoteDataSource;
  final RegistrationLocalDataSource localDataSource;

  const RegistrationRepositoryImpl({
    required this.remoteDataSource,
    required this.localDataSource,
  });

  @override
  Future<Either<Failure, Token?>> postEmailRegistration(
      {String? email,
      String? name,
      String? password,
      String? confirmPassword}) async {
    try {
      final remoteToken = await remoteDataSource.postEmailRegistration(
          email: email,
          name: name,
          password: password,
          confirmPassword: confirmPassword);
      localDataSource.cacheToken(remoteToken);
      return Right(remoteToken);
    } on ServerException catch (e) {
      return Left(ServerFailure.fromServerException(e.error));
    }
  }
}
