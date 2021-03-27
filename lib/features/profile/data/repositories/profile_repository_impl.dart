import 'package:gamecircle/core/errors/exceptions.dart';
import 'package:gamecircle/core/errors/failure.dart';
import 'package:gamecircle/core/entities/user.dart';
import 'package:dartz/dartz.dart';
import 'package:gamecircle/features/profile/data/datasources/profile_remote_data_source.dart';
import 'dart:io';

import 'package:gamecircle/features/profile/domain/repositories/profile_repository.dart';

class ProfileRepositoryImpl implements ProfileRepository {
  final ProfileRemoteDataSource remoteDataSource;

  ProfileRepositoryImpl({
    required this.remoteDataSource,
  });

  @override
  Future<Either<Failure, User?>> postUserInformation({
    String? name,
    String? email,
    File? image,
  }) async {
    try {
      final lounges = await remoteDataSource.postUserInformation(
        name: name,
        email: email,
        image: image,
      );
      return Right(lounges);
    } on ServerException catch (e) {
      return Left(ServerFailure.fromServerException(e.error));
    }
  }
}
