import 'package:gamecircle/core/entities/user.dart';
import 'package:gamecircle/core/errors/failure.dart';
import 'package:dartz/dartz.dart';
import 'package:gamecircle/core/usecases/usecases.dart';
import 'package:gamecircle/features/home/domain/repositories/user_repository.dart';

class GetCurrentUserInfo implements UseCase<User?, NoParams> {
  final UserRepository repository;

  GetCurrentUserInfo(this.repository);

  @override
  Future<Either<Failure, User?>> call(NoParams params) async {
    return await repository.getCurrentUserInfo();
  }
}
