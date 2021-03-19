import 'package:gamecircle/core/errors/exceptions.dart';
import 'package:gamecircle/core/errors/failure.dart';
import 'package:gamecircle/core/entities/user.dart';
import 'package:dartz/dartz.dart';
import 'package:gamecircle/features/home/data/datasources/user_local_data_source.dart';
import 'package:gamecircle/features/home/data/datasources/user_remote_data_source.dart';
import 'package:gamecircle/features/home/domain/repositories/user_repository.dart';

class UserRepositoryImpl implements UserRepository {
  final UserRemoteDataSource remoteDataSource;
  final UserLocalDataSource localDataSource;

  UserRepositoryImpl({
    required this.remoteDataSource,
    required this.localDataSource,
  });

  @override
  Future<Either<Failure, User?>> getCurrentUserInfo() async {
    try {
      final User? user = await remoteDataSource.getCurrentUserInfo();
      return Right(user);
    } on ServerException catch (e) {
      return Left(ServerFailure.fromServerException(e.error));
    }
  }

  @override
  Future<Either<Failure, User?>> getUserInfo(int? id) async {
    try {
      final user = await remoteDataSource.getUserInfo(id);
      return Right(user);
    } on ServerException catch (e) {
      return Left(ServerFailure.fromServerException(e.error));
    }
  }

  @override
  Future<Either<Failure, User?>> postLogoutUser() async {
    try {
      final User? user = await remoteDataSource.postLogoutUser();
      await localDataSource.deleteCachedToken();
      return Right(user);
    } on ServerException catch (e) {
      return Left(ServerFailure.fromServerException(e.error));
    }
  }
}
