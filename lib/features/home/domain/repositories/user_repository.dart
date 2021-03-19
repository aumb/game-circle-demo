import 'package:dartz/dartz.dart';
import 'package:gamecircle/core/entities/user.dart';
import 'package:gamecircle/core/errors/failure.dart';

abstract class UserRepository {
  ///Gets the current user based on his token
  Future<Either<Failure, User?>> getCurrentUserInfo();

  ///Gets a user by Id
  Future<Either<Failure, User?>> getUserInfo(int? id);

  Future<Either<Failure, User?>> postLogoutUser();
}
