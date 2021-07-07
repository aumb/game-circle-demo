import 'package:dartz/dartz.dart';
import 'package:gamecircle/core/errors/failure.dart';
import 'package:gamecircle/core/usecases/usecases.dart';
import 'package:gamecircle/features/reviews/domain/entities/review.dart';
import 'package:gamecircle/features/reviews/domain/repositories/reviews_repository.dart';
import 'package:gamecircle/features/reviews/domain/usecases/get_lounge_reviews.dart';

class GetMoreLoungeReviews
    implements UseCase<List<Review?>?, GetLoungeReviewsParams> {
  final ReviewsRepository repository;

  GetMoreLoungeReviews(this.repository);

  @override
  Future<Either<Failure, List<Review?>?>> call(
      GetLoungeReviewsParams params) async {
    return await repository.getMoreLoungeReviews(
      sortBy: params.sortBy,
      id: params.id,
    );
  }
}
