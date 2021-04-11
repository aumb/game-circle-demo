import 'package:dartz/dartz.dart';
import 'package:gamecircle/core/errors/failure.dart';
import 'package:gamecircle/features/lounges/domain/entities/lounge.dart';

abstract class LoungeRepository {
  Future<Either<Failure, Lounge?>> getLounge({
    required int id,
  });
}
