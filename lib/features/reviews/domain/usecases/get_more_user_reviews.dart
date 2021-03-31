import 'package:dartz/dartz.dart';
import 'package:gamecircle/core/errors/failure.dart';
import 'package:gamecircle/core/usecases/usecases.dart';
import 'package:gamecircle/features/reviews/domain/entities/review.dart';
import 'package:gamecircle/features/reviews/domain/repositories/reviews_repository.dart';
import 'package:gamecircle/features/reviews/domain/usecases/get_user_reviews.dart';

class GetMoreUserReviews
    implements UseCase<List<Review?>?, GetUserReviewsParams> {
  final ReviewsRepository repository;

  GetMoreUserReviews(this.repository);

  @override
  Future<Either<Failure, List<Review?>?>> call(
      GetUserReviewsParams params) async {
    return await repository.getMoreUserReviews(
      sortBy: params.sortBy,
    );
  }
}
