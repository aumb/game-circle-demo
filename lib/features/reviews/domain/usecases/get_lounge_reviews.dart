import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:gamecircle/core/errors/failure.dart';
import 'package:gamecircle/core/usecases/usecases.dart';
import 'package:gamecircle/features/reviews/domain/entities/review.dart';
import 'package:gamecircle/features/reviews/domain/repositories/reviews_repository.dart';

class GetLoungeReviews
    implements UseCase<List<Review?>?, GetLoungeReviewsParams> {
  final ReviewsRepository repository;

  GetLoungeReviews(this.repository);

  @override
  Future<Either<Failure, List<Review?>?>> call(
      GetLoungeReviewsParams params) async {
    return await repository.getLoungeReviews(
      sortBy: params.sortBy,
      id: params.id,
    );
  }
}

class GetLoungeReviewsParams extends Equatable {
  final String? sortBy;
  final int? id;

  GetLoungeReviewsParams({
    this.sortBy,
    required this.id,
  });

  @override
  List<Object?> get props => [
        sortBy,
        id,
      ];
}
