import 'dart:io';

import 'package:dartz/dartz.dart';
import 'package:gamecircle/core/errors/failure.dart';
import 'package:gamecircle/features/reviews/domain/entities/review.dart';

abstract class ReviewsRepository {
  Future<Either<Failure, List<Review?>>> getUserReviews({
    String? sortBy,
  });

  Future<Either<Failure, List<Review?>>> getMoreUserReviews({
    String? sortBy,
  });

  Future<Either<Failure, List<Review?>>> getLoungeReviews({
    String? sortBy,
    required int? id,
  });

  Future<Either<Failure, List<Review?>>> getMoreLoungeReviews({
    String? sortBy,
    required int? id,
  });

  Future<Either<Failure, Review?>> deleteLoungeReview({
    required int? id,
  });

  Future<Either<Failure, Review?>> postLoungeReview({
    int? loungeId,
    double? rating,
    String? review,
    List<File?>? images,
  });

  Future<Either<Failure, Review?>> patchLoungeReview({
    int? reviewId,
    double? rating,
    String? review,
    List<int?>? deletedImages,
    List<File?>? images,
  });
}
