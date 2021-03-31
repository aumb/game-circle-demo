import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:gamecircle/core/api.dart';
import 'package:gamecircle/core/errors/exceptions.dart';
import 'package:gamecircle/core/models/pagination_model.dart';
import 'package:gamecircle/features/reviews/data/datasources/reviews_remote_data_source_impl.dart';
import 'package:gamecircle/features/reviews/data/models/review_model.dart';
import 'package:matcher/matcher.dart';
import 'package:mocktail/mocktail.dart';

import '../../../../fixtures/fixture_reader.dart';

class MockHttpClient extends Mock implements HttpClientAdapter {}

void main() {
  late ReviewsRemoteDataSourceImpl dataSource;
  late MockHttpClient mockHttpClient;
  final Dio dio = Dio();

  setUpAll(() {
    final tPaginationModel =
        PaginationModel.fromJson(json.decode(fixture('reviews.json')));
    registerFallbackValue<RequestOptions>(RequestOptions(path: API.lounges));
    mockHttpClient = MockHttpClient();

    dataSource = ReviewsRemoteDataSourceImpl(
      client: dio,
    );

    dio.httpClientAdapter = mockHttpClient;
    dataSource.paginationModel = tPaginationModel;
  });

  void setUpMockHttpClientSuccess() async {
    final responsepayload = fixture("reviews.json");

    final httpResponse =
        ResponseBody.fromString(responsepayload, 200, headers: {
      Headers.contentTypeHeader: [Headers.jsonContentType],
    });

    when(() => mockHttpClient.fetch(any(), any(), any()))
        .thenAnswer((_) async => httpResponse);
  }

  void setUpMockSingleReviewkHttpClientSuccess() async {
    final responsepayload = fixture("review.json");

    final httpResponse =
        ResponseBody.fromString(responsepayload, 200, headers: {
      Headers.contentTypeHeader: [Headers.jsonContentType],
    });

    when(() => mockHttpClient.fetch(any(), any(), any()))
        .thenAnswer((_) async => httpResponse);
  }

  void setUpMockHttpClientFailure() {
    final responsepayload = jsonEncode({
      "error": "Something went wrong",
      "code": 500,
    });

    final httpResponse =
        ResponseBody.fromString(responsepayload, 404, headers: {
      Headers.contentTypeHeader: [Headers.jsonContentType],
    });
    when(() => mockHttpClient.fetch(any(), any(), any()))
        .thenAnswer((_) async => httpResponse);
  }

  group('getLoungeReviews', () {
    final tPaginationModel =
        PaginationModel.fromJson(json.decode(fixture('reviews.json')));
    final tReviewsModel = ReviewModel.fromJsonList(tPaginationModel.items);

    test(
      'should return List<Review> when the response code is 200 (success)',
      () async {
        // arrange
        setUpMockHttpClientSuccess();
        // act
        final result = await dataSource.getLoungeReviews();
        // assert
        expect(result, equals(tReviewsModel));
      },
    );

    test(
      'should throw a ServerException when the response code is 404 or other',
      () async {
        // arrange
        setUpMockHttpClientFailure();
        // act
        final call = dataSource.getLoungeReviews;
        // assert
        expect(() => call(), throwsA(TypeMatcher<ServerException>()));
      },
    );
  });

  group('getMoreLoungeReviews', () {
    final tPaginationModel =
        PaginationModel.fromJson(json.decode(fixture('reviews.json')));
    final tReviewsModel = ReviewModel.fromJsonList(tPaginationModel.items);

    test(
      'should return List<Review> when the response code is 200 (success)',
      () async {
        // arrange
        setUpMockHttpClientSuccess();
        // act
        final result = await dataSource.getMoreLoungeReviews();
        // assert
        expect(result, equals(tReviewsModel));
      },
    );

    test(
      'should throw a ServerException when the response code is 404 or other',
      () async {
        // arrange
        setUpMockHttpClientFailure();
        // act
        final call = dataSource.getMoreLoungeReviews;
        // assert
        expect(() => call(), throwsA(TypeMatcher<ServerException>()));
      },
    );
  });

  group('getUserReviews', () {
    final tPaginationModel =
        PaginationModel.fromJson(json.decode(fixture('reviews.json')));
    final tReviewsModel = ReviewModel.fromJsonList(tPaginationModel.items);

    test(
      'should return List<Review> when the response code is 200 (success)',
      () async {
        // arrange
        setUpMockHttpClientSuccess();
        // act
        final result = await dataSource.getUserReviews();
        // assert
        expect(result, equals(tReviewsModel));
      },
    );

    test(
      'should throw a ServerException when the response code is 404 or other',
      () async {
        // arrange
        setUpMockHttpClientFailure();
        // act
        final call = dataSource.getUserReviews;
        // assert
        expect(() => call(), throwsA(TypeMatcher<ServerException>()));
      },
    );
  });

  group('getMoreUserReviews', () {
    final tPaginationModel =
        PaginationModel.fromJson(json.decode(fixture('reviews.json')));
    final tReviewsModel = ReviewModel.fromJsonList(tPaginationModel.items);

    test(
      'should return List<Review> when the response code is 200 (success)',
      () async {
        // arrange
        setUpMockHttpClientSuccess();
        // act
        final result = await dataSource.getMoreUserReviews();
        // assert
        expect(result, equals(tReviewsModel));
      },
    );

    test(
      'should throw a ServerException when the response code is 404 or other',
      () async {
        // arrange
        setUpMockHttpClientFailure();
        // act
        final call = dataSource.getMoreUserReviews;
        // assert
        expect(() => call(), throwsA(TypeMatcher<ServerException>()));
      },
    );
  });

  group('deleteLoungeReview', () {
    final tReviewsModel =
        ReviewModel.fromJson(json.decode(fixture('review.json')));

    test(
      'should return Review when the response code is 200 (success)',
      () async {
        // arrange
        setUpMockSingleReviewkHttpClientSuccess();
        // act
        final result = await dataSource.deleteLoungeReview(id: 1);
        // assert
        expect(result, equals(tReviewsModel));
      },
    );

    test(
      'should throw a ServerException when the response code is 404 or other',
      () async {
        // arrange
        setUpMockHttpClientFailure();
        // act
        final call = dataSource.deleteLoungeReview;
        // assert
        expect(() => call(id: 1), throwsA(TypeMatcher<ServerException>()));
      },
    );
  });

  group('postLoungeReview', () {
    final tReviewsModel =
        ReviewModel.fromJson(json.decode(fixture('review.json')));

    test(
      'should return Review when the response code is 200 (success)',
      () async {
        // arrange
        setUpMockSingleReviewkHttpClientSuccess();
        // act
        final result = await dataSource.postLoungeReview(
          loungeId: tReviewsModel.id,
          rating: tReviewsModel.rating?.toDouble(),
          review: tReviewsModel.review,
          images: [],
        );
        // assert
        expect(result, equals(tReviewsModel));
      },
    );

    test(
      'should throw a ServerException when the response code is 404 or other',
      () async {
        // arrange
        setUpMockHttpClientFailure();
        // act
        final call = dataSource.postLoungeReview;
        // assert
        expect(
            () => call(
                  loungeId: tReviewsModel.id,
                  rating: tReviewsModel.rating?.toDouble(),
                  review: tReviewsModel.review,
                  images: [],
                ),
            throwsA(TypeMatcher<ServerException>()));
      },
    );
  });

  group('patchLoungeReview', () {
    final tReviewsModel =
        ReviewModel.fromJson(json.decode(fixture('review.json')));

    test(
      'should return Review when the response code is 200 (success)',
      () async {
        // arrange
        setUpMockSingleReviewkHttpClientSuccess();
        // act
        final result = await dataSource.patchLoungeReview(
          reviewId: tReviewsModel.id,
          rating: tReviewsModel.rating?.toDouble(),
          review: tReviewsModel.review,
          images: [],
        );
        // assert
        expect(result, equals(tReviewsModel));
      },
    );

    test(
      'should throw a ServerException when the response code is 404 or other',
      () async {
        // arrange
        setUpMockHttpClientFailure();
        // act
        final call = dataSource.patchLoungeReview;
        // assert
        expect(
            () => call(
                  reviewId: tReviewsModel.id,
                  rating: tReviewsModel.rating?.toDouble(),
                  review: tReviewsModel.review,
                  images: [],
                ),
            throwsA(TypeMatcher<ServerException>()));
      },
    );
  });
}
