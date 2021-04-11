import 'package:dartz/dartz.dart';
import 'package:gamecircle/core/errors/failure.dart';
import 'package:gamecircle/features/lounges/domain/entities/lounge.dart';

abstract class FavoritesRepository {
  Future<Either<Failure, List<Lounge?>>> getFavoriteLounges();

  Future<Either<Failure, List<Lounge?>>> getMoreFavoriteLounges();

  Future<Either<Failure, String?>> toggleLoungeFavoriteStatus(
      {required int id});
}
