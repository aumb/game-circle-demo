import 'package:dartz/dartz.dart';
import 'package:gamecircle/core/errors/failure.dart';
import 'package:gamecircle/features/lounges/domain/entities/lounge.dart';

abstract class LoungesRepository {
  Future<Either<Failure, List<Lounge?>>> getLounges({
    num? longitude,
    num? latitude,
    String? sortBy,
    String? query,
  });

  Future<Either<Failure, List<Lounge?>>> getMoreLounges({
    num? longitude,
    num? latitude,
    String? sortBy,
    String? query,
  });
}
