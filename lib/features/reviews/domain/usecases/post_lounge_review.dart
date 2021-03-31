import 'dart:io';

import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:gamecircle/core/errors/failure.dart';
import 'package:gamecircle/core/usecases/usecases.dart';
import 'package:gamecircle/features/reviews/domain/entities/review.dart';
import 'package:gamecircle/features/reviews/domain/repositories/reviews_repository.dart';

class PostLoungeReview implements UseCase<Review?, PostLoungeReviewParams> {
  final ReviewsRepository repository;

  PostLoungeReview(this.repository);

  @override
  Future<Either<Failure, Review?>> call(PostLoungeReviewParams params) async {
    return await repository.postLoungeReview(
      loungeId: params.loungeId,
      rating: params.rating,
      review: params.review,
      images: params.images,
    );
  }
}

class PostLoungeReviewParams extends Equatable {
  final int? loungeId;
  final double? rating;
  final String? review;
  final List<File?>? images;

  PostLoungeReviewParams({
    this.loungeId,
    this.rating,
    this.review,
    this.images,
  });

  @override
  List<Object?> get props => [loungeId, rating, review, images];
}
