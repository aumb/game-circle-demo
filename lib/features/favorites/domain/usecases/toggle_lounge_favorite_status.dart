import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:gamecircle/core/errors/failure.dart';
import 'package:gamecircle/core/usecases/usecases.dart';
import 'package:gamecircle/features/favorites/domain/repositories/favorites_repository.dart';

class ToggleLoungeFavoriteStatus
    implements UseCase<String?, ToggleLoungeFavoriteStatusParams> {
  final FavoritesRepository repository;

  ToggleLoungeFavoriteStatus(this.repository);

  @override
  Future<Either<Failure, String?>> call(
      ToggleLoungeFavoriteStatusParams params) async {
    return await repository.toggleLoungeFavoriteStatus(id: params.id);
  }
}

class ToggleLoungeFavoriteStatusParams extends Equatable {
  final int id;

  ToggleLoungeFavoriteStatusParams({required this.id});

  @override
  List<Object?> get props => [id];
}
