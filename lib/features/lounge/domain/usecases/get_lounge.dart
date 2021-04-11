import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';

import 'package:gamecircle/core/usecases/usecases.dart';
import 'package:gamecircle/core/errors/failure.dart';
import 'package:gamecircle/features/lounge/domain/respositories/lounge_repository.dart';
import 'package:gamecircle/features/lounges/domain/entities/lounge.dart';

class GetLounge implements UseCase<Lounge?, GetLoungeParams> {
  final LoungeRepository repository;

  GetLounge(this.repository);

  @override
  Future<Either<Failure, Lounge?>> call(GetLoungeParams params) async {
    return await repository.getLounge(
      id: params.id,
    );
  }
}

class GetLoungeParams extends Equatable {
  final int id;

  GetLoungeParams({
    required this.id,
  });

  @override
  List<Object?> get props => [id];
}
