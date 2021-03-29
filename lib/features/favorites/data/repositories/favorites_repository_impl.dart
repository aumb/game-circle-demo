import 'package:dartz/dartz.dart';
import 'package:gamecircle/core/errors/exceptions.dart';
import 'package:gamecircle/core/errors/failure.dart';
import 'package:gamecircle/features/favorites/data/datasources/favorites_remote_data_source.dart';
import 'package:gamecircle/features/favorites/domain/repositories/favorites_repository.dart';
import 'package:gamecircle/features/lounges/domain/entities/lounge.dart';

class FavoritesRepositoryImpl implements FavoritesRepository {
  final FavoritesRemoteDataSource remoteDataSource;

  FavoritesRepositoryImpl({
    required this.remoteDataSource,
  });

  @override
  Future<Either<Failure, List<Lounge?>>> getFavoriteLounges() async {
    try {
      final lounges = await remoteDataSource.getFavoriteLounges();
      return Right(lounges);
    } on ServerException catch (e) {
      return Left(ServerFailure.fromServerException(e.error));
    }
  }

  @override
  Future<Either<Failure, List<Lounge?>>> getMoreFavoriteLounges(
      {num? longitude, num? latitude, String? sortBy, String? query}) async {
    try {
      final lounges = await remoteDataSource.getMoreFavoriteLounges();
      return Right(lounges);
    } on ServerException catch (e) {
      return Left(ServerFailure.fromServerException(e.error));
    }
  }
}
