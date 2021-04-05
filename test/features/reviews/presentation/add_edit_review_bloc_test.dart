import 'dart:convert';

import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:gamecircle/core/errors/failure.dart';
import 'package:gamecircle/core/models/pagination_model.dart';
import 'package:gamecircle/core/usecases/usecases.dart';
import 'package:gamecircle/features/reviews/data/models/review_model.dart';
import 'package:gamecircle/features/reviews/domain/entities/review.dart';
import 'package:gamecircle/features/reviews/domain/usecases/delete_lounge_review.dart';
import 'package:gamecircle/features/reviews/domain/usecases/get_user_reviews.dart';
import 'package:gamecircle/features/reviews/domain/usecases/patch_lounge_review.dart';
import 'package:gamecircle/features/reviews/domain/usecases/post_lounge_review.dart';
import 'package:gamecircle/features/reviews/presentation/blocs/add_edit_review_bloc/add_edit_review_bloc.dart';
import 'package:gamecircle/features/reviews/presentation/blocs/user_reviews_bloc/user_reviews_bloc.dart';
import 'package:mocktail/mocktail.dart';

import '../../../fixtures/fixture_reader.dart';

class MockDeleteLoungeReview extends Mock implements DeleteLoungeReview {}

class MockPatchLoungeReview extends Mock implements PatchLoungeReview {}

class MockPostLoungeReview extends Mock implements PostLoungeReview {}

void main() {
  late AddEditReviewBloc addEditReviewBloc;
  late MockDeleteLoungeReview mockDeleteLoungeReview;
  late MockPatchLoungeReview mockPatchLoungeReview;
  late MockPostLoungeReview mockPostLoungeReview;

  final tReview = ReviewModel.fromJson(
    json.decode(
      fixture('review.json'),
    ),
  );

  setUp(() {
    registerFallbackValue<NoParams>(NoParams());
    registerFallbackValue<DeleteLoungeReviewParams>(
      DeleteLoungeReviewParams(
        id: 1,
      ),
    );
    registerFallbackValue<PostLoungeReviewParams>(
      PostLoungeReviewParams(
        loungeId: 1,
        rating: 1,
        review: "test",
        images: [],
      ),
    );
    registerFallbackValue<PatchLoungeReviewParams>(
      PatchLoungeReviewParams(
        reviewId: 1,
        rating: 1,
        review: "test",
        images: [],
      ),
    );
    mockDeleteLoungeReview = MockDeleteLoungeReview();
    mockPatchLoungeReview = MockPatchLoungeReview();
    mockPostLoungeReview = MockPostLoungeReview();
    addEditReviewBloc = AddEditReviewBloc(
      deleteLoungeReview: mockDeleteLoungeReview,
      patchLoungeReview: mockPatchLoungeReview,
      postLoungeReview: mockPostLoungeReview,
      review: tReview,
    );
  });

  group('postLoungeReview', () {
    test(
      'should get data from the local use case',
      () async {
        // arrange
        when(() => mockPostLoungeReview(any()))
            .thenAnswer((_) async => Right(tReview));
        // act
        addEditReviewBloc.add(PostReviewEvent());
        await untilCalled(() => mockPostLoungeReview(any()));
        // assert
        verify(
          () => mockPostLoungeReview(PostLoungeReviewParams(
            loungeId: 1,
            rating: null,
            review: null,
            images: [],
          )),
        );
      },
    );

    // test(
    //   'should emit [AddEditReviewLoading, AddEditReviewLoaded] when data is gotten successfully',
    //   () async {
    //     // arrange
    //     when(() => mockPostLoungeReview(any()))
    //         .thenAnswer((_) async => Right(tReview));
    //     // assert later
    //     final expected = [
    //       AddEditReviewLoading(),
    //       AddEditReviewLoaded(),
    //     ];
    //     expectLater(addEditReviewBloc.stream, emitsInOrder(expected));
    //     // act
    //     addEditReviewBloc.add(PostReviewEvent());
    //   },
    // );

    // test(
    //   'should emit [UserReviewsLoading, UserReviewsError] when getting data fails',
    //   () async {
    //     // arrange
    //     final failure = ServerFailure(code: 500, message: "unexpected error");
    //     when(() => mockGetUserReviews(any())).thenAnswer(
    //       (_) async => Left(
    //         failure,
    //       ),
    //     );
    //     // assert later
    //     final expected = [
    //       // LoungesLoading(),
    //       UserReviewsError(
    //         message: failure.message,
    //       ),
    //     ];
    //     expectLater(userReviewsBloc.stream, emitsInOrder(expected));
    //     // act
    //     userReviewsBloc.add(GetUserReviewsEvent());
    //   },
    // );
  });

  group('patchLoungeReview', () {
    test(
      'should get data from the local use case',
      () async {
        // arrange
        when(() => mockPatchLoungeReview(any()))
            .thenAnswer((_) async => Right(tReview));
        // act
        addEditReviewBloc.add(PatchReviewEvent());
        await untilCalled(() => mockPatchLoungeReview(any()));
        // assert
        verify(
          () => mockPatchLoungeReview(PatchLoungeReviewParams(
            reviewId: 13,
            rating: null,
            review: null,
            images: [],
          )),
        );
      },
    );

    // test(
    //   'should emit [AddEditReviewLoading, AddEditReviewLoaded] when data is gotten successfully',
    //   () async {
    //     // arrange
    //     when(() => mockPostLoungeReview(any()))
    //         .thenAnswer((_) async => Right(tReview));
    //     // assert later
    //     final expected = [
    //       AddEditReviewLoading(),
    //       AddEditReviewLoaded(),
    //     ];
    //     expectLater(addEditReviewBloc.stream, emitsInOrder(expected));
    //     // act
    //     addEditReviewBloc.add(PostReviewEvent());
    //   },
    // );

    // test(
    //   'should emit [UserReviewsLoading, UserReviewsError] when getting data fails',
    //   () async {
    //     // arrange
    //     final failure = ServerFailure(code: 500, message: "unexpected error");
    //     when(() => mockGetUserReviews(any())).thenAnswer(
    //       (_) async => Left(
    //         failure,
    //       ),
    //     );
    //     // assert later
    //     final expected = [
    //       // LoungesLoading(),
    //       UserReviewsError(
    //         message: failure.message,
    //       ),
    //     ];
    //     expectLater(userReviewsBloc.stream, emitsInOrder(expected));
    //     // act
    //     userReviewsBloc.add(GetUserReviewsEvent());
    //   },
    // );
  });

  group('deleteLoungeReview', () {
    test(
      'should get data from the local use case',
      () async {
        // arrange
        when(() => mockDeleteLoungeReview(any()))
            .thenAnswer((_) async => Right(tReview));
        // act
        addEditReviewBloc.add(DeleteReviewEvent());
        await untilCalled(() => mockDeleteLoungeReview(any()));
        // assert
        verify(
          () => mockDeleteLoungeReview(
            DeleteLoungeReviewParams(
              id: 13,
            ),
          ),
        );
      },
    );

    // test(
    //   'should emit [AddEditReviewLoading, AddEditReviewLoaded] when data is gotten successfully',
    //   () async {
    //     // arrange
    //     when(() => mockPostLoungeReview(any()))
    //         .thenAnswer((_) async => Right(tReview));
    //     // assert later
    //     final expected = [
    //       AddEditReviewLoading(),
    //       AddEditReviewLoaded(),
    //     ];
    //     expectLater(addEditReviewBloc.stream, emitsInOrder(expected));
    //     // act
    //     addEditReviewBloc.add(PostReviewEvent());
    //   },
    // );

    // test(
    //   'should emit [UserReviewsLoading, UserReviewsError] when getting data fails',
    //   () async {
    //     // arrange
    //     final failure = ServerFailure(code: 500, message: "unexpected error");
    //     when(() => mockGetUserReviews(any())).thenAnswer(
    //       (_) async => Left(
    //         failure,
    //       ),
    //     );
    //     // assert later
    //     final expected = [
    //       // LoungesLoading(),
    //       UserReviewsError(
    //         message: failure.message,
    //       ),
    //     ];
    //     expectLater(userReviewsBloc.stream, emitsInOrder(expected));
    //     // act
    //     userReviewsBloc.add(GetUserReviewsEvent());
    //   },
    // );
  });

  //TODO: In order to test stream states the stream needs to extends equatable.
}
