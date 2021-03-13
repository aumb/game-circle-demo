import 'package:gamecircle/core/errors/exceptions.dart';
import 'package:gamecircle/features/login/data/datasources/login_local_data_source.dart';
import 'package:gamecircle/features/login/data/datasources/login_remote_data_source.dart';
import 'package:gamecircle/features/login/domain/entities/token.dart';
import 'package:gamecircle/core/errors/failure.dart';
import 'package:dartz/dartz.dart';
import 'package:gamecircle/features/login/domain/repositories/login_repository.dart';
import 'package:google_sign_in/google_sign_in.dart';

class LoginRespositoryImpl implements LoginRepository {
  final LoginRemoteDataSource remoteDataSource;
  final LoginLocalDataSource localDataSource;

  const LoginRespositoryImpl({
    required this.remoteDataSource,
    required this.localDataSource,
  });

  @override
  Future<Either<Failure, Token?>> postEmailLogin(
      String? email, String? password) async {
    try {
      final remoteToken =
          await remoteDataSource.postEmailLogin(email, password);
      localDataSource.cacheToken(remoteToken);
      return Right(remoteToken);
    } on ServerException catch (e) {
      return Left(ServerFailure.fromServerException(e.error));
    }
  }

  @override
  Future<Either<Failure, Token?>> postSocialLogin(
      String? provider, String? token) async {
    try {
      final remoteToken =
          await remoteDataSource.postSocialLogin(provider, token);
      localDataSource.cacheToken(remoteToken);
      return Right(remoteToken);
    } on ServerException catch (e) {
      return Left(ServerFailure.fromServerException(e.error));
    }
  }

  @override
  Future<Either<Failure, GoogleSignInAuthentication?>> postGoogleLogin() async {
    try {
      final GoogleSignInAuthentication? googleSignInAccount =
          await remoteDataSource.postGoogleLogin();
      return Right(googleSignInAccount);
    } on ServerException catch (e) {
      return Left(ServerFailure.fromServerException(e.error));
    }
  }
}
