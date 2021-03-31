import 'dart:convert';

import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:gamecircle/core/models/pagination_model.dart';
import 'package:gamecircle/features/reviews/data/datasources/reviews_remote_data_source.dart';
import 'package:gamecircle/features/reviews/data/models/review_model.dart';
import 'package:gamecircle/features/reviews/data/repositories/reviews_repository_impl.dart';
import 'package:mocktail/mocktail.dart';

import '../../../../fixtures/fixture_reader.dart';

class MockRemoteDataSource extends Mock implements ReviewsRemoteDataSource {}

void main() {
  late ReviewsRepositoryImpl repository;
  late MockRemoteDataSource mockRemoteDataSource;

  setUp(() {
    mockRemoteDataSource = MockRemoteDataSource();
    repository = ReviewsRepositoryImpl(
      remoteDataSource: mockRemoteDataSource,
    );
  });

  group("getLoungeReviews", () {
    final tPaginationModel =
        PaginationModel.fromJson(json.decode(fixture('reviews.json')));
    final tReviewsModel = ReviewModel.fromJsonList(tPaginationModel.items);
    final tReviews = tReviewsModel;
    test(
      'should return remote data when the call to remote data source is successful',
      () async {
        // arrange
        when(() => mockRemoteDataSource.getLoungeReviews())
            .thenAnswer((_) async => tReviewsModel);
        // act
        final result = await repository.getLoungeReviews();
        // assert
        verify(() => mockRemoteDataSource.getLoungeReviews()).called(1);

        expect(result, equals(Right(tReviews)));
      },
    );
  });

  group("getMoreLoungeReviews", () {
    final tPaginationModel =
        PaginationModel.fromJson(json.decode(fixture('reviews.json')));
    final tReviewsModel = ReviewModel.fromJsonList(tPaginationModel.items);
    final tReviews = tReviewsModel;
    test(
      'should return remote data when the call to remote data source is successful',
      () async {
        // arrange
        when(() => mockRemoteDataSource.getMoreLoungeReviews())
            .thenAnswer((_) async => tReviewsModel);
        // act
        final result = await repository.getMoreLoungeReviews();
        // assert
        verify(() => mockRemoteDataSource.getMoreLoungeReviews()).called(1);

        expect(result, equals(Right(tReviews)));
      },
    );
  });

  group("getUserReviews", () {
    final tPaginationModel =
        PaginationModel.fromJson(json.decode(fixture('reviews.json')));
    final tReviewsModel = ReviewModel.fromJsonList(tPaginationModel.items);
    final tReviews = tReviewsModel;
    test(
      'should return remote data when the call to remote data source is successful',
      () async {
        // arrange
        when(() => mockRemoteDataSource.getMoreUserReviews())
            .thenAnswer((_) async => tReviewsModel);
        // act
        final result = await repository.getMoreUserReviews();
        // assert
        verify(() => mockRemoteDataSource.getMoreUserReviews()).called(1);

        expect(result, equals(Right(tReviews)));
      },
    );
  });

  group("getMoreUserReviews", () {
    final tPaginationModel =
        PaginationModel.fromJson(json.decode(fixture('reviews.json')));
    final tReviewsModel = ReviewModel.fromJsonList(tPaginationModel.items);
    final tReviews = tReviewsModel;
    test(
      'should return remote data when the call to remote data source is successful',
      () async {
        // arrange
        when(() => mockRemoteDataSource.getMoreUserReviews())
            .thenAnswer((_) async => tReviewsModel);
        // act
        final result = await repository.getMoreUserReviews();
        // assert
        verify(() => mockRemoteDataSource.getMoreUserReviews()).called(1);

        expect(result, equals(Right(tReviews)));
      },
    );
  });

  group("deleteLoungeReview", () {
    final tReviewModel =
        ReviewModel.fromJson(json.decode(fixture('review.json')));
    final tReview = tReviewModel;
    test(
      'should return remote data when the call to remote data source is successful',
      () async {
        // arrange
        when(() =>
                mockRemoteDataSource.deleteLoungeReview(id: any(named: "id")))
            .thenAnswer((_) async => tReviewModel);
        // act
        final result = await repository.deleteLoungeReview(id: 1);
        // assert
        verify(() => mockRemoteDataSource.deleteLoungeReview(id: 1)).called(1);

        expect(result, equals(Right(tReview)));
      },
    );
  });

  group("postLoungeReview", () {
    final tReviewModel =
        ReviewModel.fromJson(json.decode(fixture('review.json')));
    final tReview = tReviewModel;
    test(
      'should return remote data when the call to remote data source is successful',
      () async {
        // arrange
        when(() => mockRemoteDataSource.postLoungeReview())
            .thenAnswer((_) async => tReviewModel);
        // act
        final result = await repository.postLoungeReview();
        // assert
        verify(() => mockRemoteDataSource.postLoungeReview()).called(1);

        expect(result, equals(Right(tReview)));
      },
    );
  });

  group("patchLoungeReview", () {
    final tReviewModel =
        ReviewModel.fromJson(json.decode(fixture('review.json')));
    final tReview = tReviewModel;
    test(
      'should return remote data when the call to remote data source is successful',
      () async {
        // arrange
        when(() => mockRemoteDataSource.patchLoungeReview())
            .thenAnswer((_) async => tReviewModel);
        // act
        final result = await repository.patchLoungeReview();
        // assert
        verify(() => mockRemoteDataSource.patchLoungeReview()).called(1);

        expect(result, equals(Right(tReview)));
      },
    );
  });
}
