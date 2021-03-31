import 'dart:convert';

import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:gamecircle/core/errors/failure.dart';
import 'package:gamecircle/core/models/pagination_model.dart';
import 'package:gamecircle/core/usecases/usecases.dart';
import 'package:gamecircle/features/reviews/data/models/review_model.dart';
import 'package:gamecircle/features/reviews/domain/entities/review.dart';
import 'package:gamecircle/features/reviews/domain/usecases/get_more_user_reviews.dart';
import 'package:gamecircle/features/reviews/domain/usecases/get_user_reviews.dart';
import 'package:gamecircle/features/reviews/presentation/blocs/user_reviews_bloc/user_reviews_bloc.dart';
import 'package:mocktail/mocktail.dart';

import '../../../fixtures/fixture_reader.dart';

class MockGetUserReviews extends Mock implements GetUserReviews {}

class MockGetMoreUserReviews extends Mock implements GetMoreUserReviews {}

void main() {
  late UserReviewsBloc userReviewsBloc;
  late MockGetUserReviews mockGetUserReviews;
  late MockGetMoreUserReviews mockGetMoreUserReviews;

  setUp(() {
    registerFallbackValue<NoParams>(NoParams());
    registerFallbackValue<GetUserReviewsParams>(GetUserReviewsParams(
      sortBy: 'updated_at',
    ));
    mockGetUserReviews = MockGetUserReviews();
    mockGetMoreUserReviews = MockGetMoreUserReviews();
    userReviewsBloc = UserReviewsBloc(
      getUserReviews: mockGetUserReviews,
      getMoreUserReviews: mockGetMoreUserReviews,
    );
  });

  group('getUserReviews', () {
    final tPagination = PaginationModel.fromJson(
      json.decode(
        fixture('reviews.json'),
      ),
    );
    final tReviews = ReviewModel.fromJsonList(tPagination.items);

    test(
      'should get data from the local use case',
      () async {
        // arrange
        when(() => mockGetUserReviews(any()))
            .thenAnswer((_) async => Right(tReviews));
        // act
        userReviewsBloc.add(GetUserReviewsEvent());
        await untilCalled(() => mockGetUserReviews(any()));
        // assert
        verify(
          () => mockGetUserReviews(GetUserReviewsParams(
            sortBy: 'updated_at',
          )),
        );
      },
    );

    test(
      'should emit [UserReviewsLoading, UserReviewsLoaded] when data is gotten successfully',
      () async {
        // arrange
        when(() => mockGetUserReviews(any()))
            .thenAnswer((_) async => Right(tReviews));
        // assert later
        final expected = [
          // LoungesLoading(),
          UserReviewsLoaded(),
        ];
        expectLater(userReviewsBloc.stream, emitsInOrder(expected))
            .then((value) {
          expect(userReviewsBloc.reviews, equals(tReviews));
        });
        // act
        userReviewsBloc.add(GetUserReviewsEvent());
      },
    );

    test(
      'should emit [UserReviewsLoading, UserReviewsError] when getting data fails',
      () async {
        // arrange
        final failure = ServerFailure(code: 500, message: "unexpected error");
        when(() => mockGetUserReviews(any())).thenAnswer(
          (_) async => Left(
            failure,
          ),
        );
        // assert later
        final expected = [
          // LoungesLoading(),
          UserReviewsError(
            message: failure.message,
          ),
        ];
        expectLater(userReviewsBloc.stream, emitsInOrder(expected));
        // act
        userReviewsBloc.add(GetUserReviewsEvent());
      },
    );
  });

  group('getMoreUserReviews', () {
    final tPagination = PaginationModel.fromJson(
      json.decode(
        fixture('reviews.json'),
      ),
    );
    final tReviews = ReviewModel.fromJsonList(tPagination.items);

    test(
      'should get data from the use case',
      () async {
        // arrange
        when(() => mockGetMoreUserReviews(any()))
            .thenAnswer((_) async => Right(tReviews));
        // act
        userReviewsBloc.add(GetMoreUserReviewsEvent());
        await untilCalled(() => mockGetMoreUserReviews(any()));
        // assert
        verify(
          () => mockGetMoreUserReviews(GetUserReviewsParams(
            sortBy: 'updated_at',
          )),
        );
      },
    );

    test(
      'should emit [LoungesLoadingMore, LoungesLoadedMore] when data is gotten successfully',
      () async {
        final List<Review?> reviews = userReviewsBloc.reviews;
        // arrange
        // setUpMockInputConverterSuccess();
        when(() => mockGetMoreUserReviews(any()))
            .thenAnswer((_) async => Right(tReviews));
        // assert later
        final expected = [
          UserReviewsLoadingMore(),
          UserReviewsLoadedMore(),
        ];
        expectLater(userReviewsBloc.stream, emitsInOrder(expected))
            .then((value) {
          reviews.addAll(tReviews);
          expect(userReviewsBloc.reviews, equals(reviews));
        });
        // act
        userReviewsBloc.add(GetMoreUserReviewsEvent());
      },
    );

    test(
      'should emit [LoungesLoading, LoungesErrorMore] when getting data fails',
      () async {
        // arrange
        final failure = ServerFailure(code: 500, message: "unexpected error");
        when(() => mockGetMoreUserReviews(any())).thenAnswer(
          (_) async => Left(
            failure,
          ),
        );
        // assert later
        final expected = [
          UserReviewsLoadingMore(),
          UserReviewsErrorMore(
            message: failure.message,
          ),
        ];
        expectLater(userReviewsBloc.stream, emitsInOrder(expected));
        // act
        userReviewsBloc.add(GetMoreUserReviewsEvent());
      },
    );

    test(
      'should stop loading more when an empty lounges list is returned',
      () async {
        // arrange
        // setUpMockInputConverterSuccess();
        when(() => mockGetMoreUserReviews(any()))
            .thenAnswer((_) async => Right([]));
        // assert later
        final expected = [
          UserReviewsLoadingMore(),
          UserReviewsLoadedMore(),
        ];
        expectLater(userReviewsBloc.stream, emitsInOrder(expected))
            .then((value) {
          expect(userReviewsBloc.canGetMoreReviews, equals(false));
        });
        // act
        userReviewsBloc.add(GetMoreUserReviewsEvent());
      },
    );
  });
}
