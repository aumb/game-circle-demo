import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:gamecircle/core/errors/failure.dart';
import 'package:gamecircle/features/reviews/domain/entities/review.dart';
import 'package:gamecircle/features/reviews/domain/usecases/get_more_user_reviews.dart';
import 'package:gamecircle/features/reviews/domain/usecases/get_user_reviews.dart';

part 'user_reviews_event.dart';
part 'user_reviews_state.dart';

class UserReviewsBloc extends Bloc<UserReviewsEvent, UserReviewsState> {
  final GetUserReviews getUserReviews;
  final GetMoreUserReviews getMoreUserReviews;

  UserReviewsBloc({
    required this.getUserReviews,
    required this.getMoreUserReviews,
  }) : super(UserReviewsLoading());

  List<Review?> _reviews = [];
  List<Review?> get reviews => _reviews;

  bool canGetMoreReviews = true;

  @override
  Stream<UserReviewsState> mapEventToState(
    UserReviewsEvent event,
  ) async* {
    if (event is GetUserReviewsEvent) {
      canGetMoreReviews = true;
      if (state is! UserReviewsLoading) yield UserReviewsLoading();

      final reviews = await getUserReviews(
        GetUserReviewsParams(
          sortBy: 'updated_at',
        ),
      );
      yield* _handledGetUserReviewsState(reviews);
    } else if (event is GetMoreUserReviewsEvent) {
      if (state is! UserReviewsLoadingMore) yield UserReviewsLoadingMore();

      final reviews = await getMoreUserReviews(
        GetUserReviewsParams(
          sortBy: 'updated_at',
        ),
      );
      yield* _handledGetMoreLoungesState(reviews);
    }
  }

  Stream<UserReviewsState> _handledGetUserReviewsState(
    Either<Failure, List<Review?>?> failureOrToken,
  ) async* {
    yield failureOrToken.fold((failure) {
      return _handleFailureEvent(failure);
    }, (lounges) {
      _reviews = [];
      _reviews.addAll(lounges!);
      return UserReviewsLoaded();
    });
  }

  Stream<UserReviewsState> _handledGetMoreLoungesState(
    Either<Failure, List<Review?>?> failureOrToken,
  ) async* {
    yield failureOrToken.fold((failure) {
      return _handleGetMoreFailureEvent(failure);
    }, (lounges) {
      if (lounges!.isEmpty) canGetMoreReviews = false;
      _reviews.addAll(lounges);
      return UserReviewsLoadedMore();
    });
  }

  UserReviewsError _handleFailureEvent(Failure failure) {
    UserReviewsError error;
    if (failure is ServerFailure) {
      error = UserReviewsError(
        message: failure.message,
        code: failure.code,
      );
    } else {
      error = UserReviewsError(message: "unexpected_error", code: 500);
    }

    return error;
  }

  UserReviewsErrorMore _handleGetMoreFailureEvent(Failure failure) {
    UserReviewsErrorMore error;
    if (failure is ServerFailure) {
      error = UserReviewsErrorMore(message: failure.message);
    } else {
      error = UserReviewsErrorMore(message: "unexpected_error");
    }

    return error;
  }
}
