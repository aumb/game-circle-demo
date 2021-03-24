import 'package:gamecircle/core/errors/failure.dart';
import 'package:dartz/dartz.dart';
import 'package:gamecircle/core/usecases/usecases.dart';
import 'package:gamecircle/features/home/domain/repositories/user_repository.dart';
import 'package:geolocator/geolocator.dart';

class GetCurrentUserLocation implements UseCase<Position?, NoParams> {
  final UserRepository repository;

  GetCurrentUserLocation(this.repository);

  @override
  Future<Either<Failure, Position?>> call(NoParams params) async {
    return await repository.getCurrentUserLocation();
  }
}
