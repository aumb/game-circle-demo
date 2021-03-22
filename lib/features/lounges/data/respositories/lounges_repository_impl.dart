import 'package:gamecircle/core/errors/exceptions.dart';
import 'package:gamecircle/features/lounges/data/datasources/lounges_remote_data_source.dart';
import 'package:gamecircle/features/lounges/domain/entities/lounge.dart';
import 'package:gamecircle/core/errors/failure.dart';
import 'package:dartz/dartz.dart';
import 'package:gamecircle/features/lounges/domain/repositories/lounges_repository.dart';

class LoungesRepositoryImpl implements LoungesRepository {
  final LoungesRemoteDataSource remoteDataSource;

  LoungesRepositoryImpl({
    required this.remoteDataSource,
  });

  @override
  Future<Either<Failure, List<Lounge?>>> getLounges({
    num? longitude,
    num? latitude,
    String? sortBy,
    String? query,
  }) async {
    try {
      final lounges = await remoteDataSource.getLounges(
        longitude: longitude,
        latitude: latitude,
        sortBy: sortBy,
        query: query,
      );
      return Right(lounges);
    } on ServerException catch (e) {
      return Left(ServerFailure.fromServerException(e.error));
    }
  }

  @override
  Future<Either<Failure, List<Lounge?>>> getMoreLounges(
      {num? longitude, num? latitude, String? sortBy, String? query}) async {
    try {
      final lounges = await remoteDataSource.getMoreLounges(
        longitude: longitude,
        latitude: latitude,
        sortBy: sortBy,
        query: query,
      );
      return Right(lounges);
    } on ServerException catch (e) {
      return Left(ServerFailure.fromServerException(e.error));
    }
  }
}
