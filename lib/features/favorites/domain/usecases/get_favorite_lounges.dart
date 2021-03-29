import 'package:dartz/dartz.dart';

import 'package:gamecircle/core/usecases/usecases.dart';
import 'package:gamecircle/core/errors/failure.dart';
import 'package:gamecircle/features/favorites/domain/repositories/favorites_repository.dart';
import 'package:gamecircle/features/lounges/domain/entities/lounge.dart';

class GetFavoriteLounges implements UseCase<List<Lounge?>, NoParams> {
  final FavoritesRepository repository;

  GetFavoriteLounges(this.repository);

  @override
  Future<Either<Failure, List<Lounge?>>> call(NoParams params) async {
    return await repository.getFavoriteLounges();
  }
}
