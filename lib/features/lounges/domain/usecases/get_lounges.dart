import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';

import 'package:gamecircle/core/usecases/usecases.dart';
import 'package:gamecircle/core/errors/failure.dart';
import 'package:gamecircle/features/lounges/domain/entities/lounge.dart';
import 'package:gamecircle/features/lounges/domain/repositories/lounges_repository.dart';

class GetLounges implements UseCase<List<Lounge?>, GetLoungesParams> {
  final LoungesRepository repository;

  GetLounges(this.repository);

  @override
  Future<Either<Failure, List<Lounge?>>> call(GetLoungesParams params) async {
    return await repository.getLounges(
      latitude: params.latitude,
      longitude: params.longitude,
      sortBy: params.sortBy,
      query: params.query,
    );
  }
}

class GetLoungesParams extends Equatable {
  final num? longitude;
  final num? latitude;
  final String? sortBy;
  final String? query;

  GetLoungesParams({
    this.longitude,
    this.latitude,
    this.sortBy,
    this.query,
  });

  @override
  List<Object?> get props => [
        longitude,
        latitude,
        sortBy,
        query,
      ];
}
