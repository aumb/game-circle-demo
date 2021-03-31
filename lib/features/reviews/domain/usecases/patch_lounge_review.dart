import 'dart:io';

import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:gamecircle/core/errors/failure.dart';
import 'package:gamecircle/core/usecases/usecases.dart';
import 'package:gamecircle/features/reviews/domain/entities/review.dart';
import 'package:gamecircle/features/reviews/domain/repositories/reviews_repository.dart';

class PatchLoungeReview implements UseCase<Review?, PatchLoungeReviewParams> {
  final ReviewsRepository repository;

  PatchLoungeReview(this.repository);

  @override
  Future<Either<Failure, Review?>> call(PatchLoungeReviewParams params) async {
    return await repository.patchLoungeReview(
      reviewId: params.reviewId,
      rating: params.rating,
      review: params.review,
      images: params.images,
      deletedImages: params.deletedImages,
    );
  }
}

class PatchLoungeReviewParams extends Equatable {
  final int? reviewId;
  final double? rating;
  final String? review;
  final List<File?>? images;
  final List<int?>? deletedImages;

  PatchLoungeReviewParams({
    this.reviewId,
    this.rating,
    this.review,
    this.images,
    this.deletedImages,
  });

  @override
  List<Object?> get props => [reviewId, rating, review, images];
}
