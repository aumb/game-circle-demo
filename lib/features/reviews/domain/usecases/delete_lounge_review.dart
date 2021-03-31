import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:gamecircle/core/errors/failure.dart';
import 'package:gamecircle/core/usecases/usecases.dart';
import 'package:gamecircle/features/reviews/domain/entities/review.dart';
import 'package:gamecircle/features/reviews/domain/repositories/reviews_repository.dart';

class DeleteLoungeReview implements UseCase<Review?, DeleteLoungeReviewParams> {
  final ReviewsRepository repository;

  DeleteLoungeReview(this.repository);

  @override
  Future<Either<Failure, Review?>> call(DeleteLoungeReviewParams params) async {
    return await repository.deleteLoungeReview(
      id: params.id,
    );
  }
}

class DeleteLoungeReviewParams extends Equatable {
  final int? id;

  DeleteLoungeReviewParams({
    this.id,
  });

  @override
  List<Object?> get props => [id];
}
