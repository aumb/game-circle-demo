import 'dart:io';

import 'package:gamecircle/features/reviews/domain/entities/review.dart';

abstract class ReviewsRemoteDataSource {
  Future<List<Review?>> getLoungeReviews({
    String? sortBy,
  });

  Future<List<Review?>> getMoreLoungeReviews({
    String? sortBy,
  });

  Future<List<Review?>> getUserReviews({
    String? sortBy,
  });

  Future<List<Review?>> getMoreUserReviews({
    String? sortBy,
  });

  Future<Review?> deleteLoungeReview({
    required int? id,
  });

  Future<Review?> postLoungeReview({
    int? loungeId,
    double? rating,
    String? review,
    List<File?>? images,
  });

  Future<Review?> patchLoungeReview({
    int? reviewId,
    double? rating,
    String? review,
    List<int?>? deletedImages,
    List<File?>? images,
  });
}
