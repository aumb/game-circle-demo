import 'package:dartz/dartz.dart';
import 'package:gamecircle/core/errors/failure.dart';
import 'package:gamecircle/core/usecases/usecases.dart';
import 'package:gamecircle/features/lounges/domain/entities/lounge.dart';
import 'package:gamecircle/features/lounges/domain/repositories/lounges_repository.dart';
import 'package:gamecircle/features/lounges/domain/usecases/get_lounges.dart';

class GetMoreLounges implements UseCase<List<Lounge?>, GetLoungesParams> {
  final LoungesRepository repository;

  GetMoreLounges(this.repository);

  @override
  Future<Either<Failure, List<Lounge?>>> call(GetLoungesParams params) async {
    return await repository.getMoreLounges(
      latitude: params.latitude,
      longitude: params.longitude,
      sortBy: params.sortBy,
      query: params.query,
    );
  }
}
