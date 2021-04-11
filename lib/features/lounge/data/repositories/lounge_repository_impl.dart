import 'package:gamecircle/core/errors/exceptions.dart';
import 'package:gamecircle/features/lounge/data/datasources/lounge_remote_data_source.dart';
import 'package:gamecircle/features/lounge/domain/respositories/lounge_repository.dart';
import 'package:gamecircle/features/lounges/domain/entities/lounge.dart';
import 'package:gamecircle/core/errors/failure.dart';
import 'package:dartz/dartz.dart';

class LoungeRepositoryImpl implements LoungeRepository {
  final LoungeRemoteDataSource remoteDataSource;

  LoungeRepositoryImpl({
    required this.remoteDataSource,
  });

  @override
  Future<Either<Failure, Lounge?>> getLounge({
    required int id,
  }) async {
    try {
      final lounges = await remoteDataSource.getLounge(
        id: id,
      );
      return Right(lounges);
    } on ServerException catch (e) {
      return Left(ServerFailure.fromServerException(e.error));
    }
  }
}
