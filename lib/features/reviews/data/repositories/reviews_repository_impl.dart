import 'package:gamecircle/core/errors/exceptions.dart';
import 'package:gamecircle/features/reviews/data/datasources/reviews_remote_data_source.dart';
import 'package:gamecircle/features/reviews/domain/entities/review.dart';
import 'package:gamecircle/core/errors/failure.dart';
import 'package:dartz/dartz.dart';
import 'dart:io';

import 'package:gamecircle/features/reviews/domain/repositories/reviews_repository.dart';

class ReviewsRepositoryImpl implements ReviewsRepository {
  final ReviewsRemoteDataSource remoteDataSource;

  ReviewsRepositoryImpl({
    required this.remoteDataSource,
  });

  @override
  Future<Either<Failure, Review?>> deleteLoungeReview(
      {required int? id}) async {
    try {
      final review = await remoteDataSource.deleteLoungeReview(
        id: id,
      );
      return Right(review);
    } on ServerException catch (e) {
      return Left(ServerFailure.fromServerException(e.error));
    }
  }

  @override
  Future<Either<Failure, List<Review?>>> getLoungeReviews(
      {String? sortBy}) async {
    try {
      final reviews = await remoteDataSource.getLoungeReviews(
        sortBy: sortBy,
      );
      return Right(reviews);
    } on ServerException catch (e) {
      return Left(ServerFailure.fromServerException(e.error));
    }
  }

  @override
  Future<Either<Failure, List<Review?>>> getMoreLoungeReviews(
      {String? sortBy}) async {
    try {
      final reviews = await remoteDataSource.getMoreLoungeReviews(
        sortBy: sortBy,
      );
      return Right(reviews);
    } on ServerException catch (e) {
      return Left(ServerFailure.fromServerException(e.error));
    }
  }

  @override
  Future<Either<Failure, List<Review?>>> getMoreUserReviews(
      {String? sortBy}) async {
    try {
      final reviews = await remoteDataSource.getMoreUserReviews(
        sortBy: sortBy,
      );
      return Right(reviews);
    } on ServerException catch (e) {
      return Left(ServerFailure.fromServerException(e.error));
    }
  }

  @override
  Future<Either<Failure, List<Review?>>> getUserReviews(
      {String? sortBy}) async {
    try {
      final reviews = await remoteDataSource.getUserReviews(
        sortBy: sortBy,
      );
      return Right(reviews);
    } on ServerException catch (e) {
      return Left(ServerFailure.fromServerException(e.error));
    }
  }

  @override
  Future<Either<Failure, Review?>> patchLoungeReview({
    int? reviewId,
    double? rating,
    String? review,
    List<int?>? deletedImages,
    List<File?>? images,
  }) async {
    try {
      final patchedReview = await remoteDataSource.patchLoungeReview(
        reviewId: reviewId,
        rating: rating,
        review: review,
        deletedImages: deletedImages,
        images: images,
      );
      return Right(patchedReview);
    } on ServerException catch (e) {
      return Left(ServerFailure.fromServerException(e.error));
    }
  }

  @override
  Future<Either<Failure, Review?>> postLoungeReview({
    int? loungeId,
    double? rating,
    String? review,
    List<File?>? images,
  }) async {
    try {
      final createdReview = await remoteDataSource.postLoungeReview(
        loungeId: loungeId,
        rating: rating,
        review: review,
        images: images,
      );
      return Right(createdReview);
    } on ServerException catch (e) {
      return Left(ServerFailure.fromServerException(e.error));
    }
  }
}
