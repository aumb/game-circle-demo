import 'package:equatable/equatable.dart';
import 'package:gamecircle/core/entities/user.dart';
import 'package:gamecircle/core/errors/failure.dart';
import 'package:dartz/dartz.dart';
import 'package:gamecircle/core/usecases/usecases.dart';
import 'package:gamecircle/features/home/domain/repositories/user_repository.dart';

class GetUserInfo implements UseCase<User?, GetUserInfoParams> {
  final UserRepository repository;

  GetUserInfo(this.repository);

  @override
  Future<Either<Failure, User?>> call(GetUserInfoParams params) async {
    return await repository.getUserInfo(
      params.id,
    );
  }
}

class GetUserInfoParams extends Equatable {
  final int? id;

  GetUserInfoParams({
    required this.id,
  });

  @override
  List<Object?> get props => [id];
}
