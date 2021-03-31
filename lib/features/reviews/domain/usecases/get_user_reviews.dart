import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:gamecircle/core/errors/failure.dart';
import 'package:gamecircle/core/usecases/usecases.dart';
import 'package:gamecircle/features/reviews/domain/entities/review.dart';
import 'package:gamecircle/features/reviews/domain/repositories/reviews_repository.dart';

class GetUserReviews implements UseCase<List<Review?>?, GetUserReviewsParams> {
  final ReviewsRepository repository;

  GetUserReviews(this.repository);

  @override
  Future<Either<Failure, List<Review?>?>> call(
      GetUserReviewsParams params) async {
    return await repository.getUserReviews(
      sortBy: params.sortBy,
    );
  }
}

class GetUserReviewsParams extends Equatable {
  final String? sortBy;

  GetUserReviewsParams({
    this.sortBy,
  });

  @override
  List<Object?> get props => [
        sortBy,
      ];
}
