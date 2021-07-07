import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:gamecircle/core/errors/failure.dart';
import 'package:gamecircle/features/lounges/domain/entities/lounge.dart';
import 'package:gamecircle/features/reviews/domain/entities/review.dart';
import 'package:gamecircle/features/reviews/domain/entities/reviews_filter_option.dart';
import 'package:gamecircle/features/reviews/domain/usecases/get_lounge_reviews.dart';
import 'package:gamecircle/features/reviews/domain/usecases/get_more_lounge_reviews.dart';

part 'lounge_reviews_event.dart';
part 'lounge_reviews_state.dart';

class LoungeReviewsBloc extends Bloc<LoungeReviewsEvent, LoungeReviewsState> {
  final Lounge lounge;
  final GetLoungeReviews getLoungeReviews;
  final GetMoreLoungeReviews getMoreLoungeReviews;

  LoungeReviewsBloc({
    required this.getLoungeReviews,
    required this.getMoreLoungeReviews,
    required this.lounge,
  }) : super(LoungeReviewsInitial());

  List<Review?> _reviews = [];
  List<Review?> get reviews => _reviews;

  bool canGetMoreReviews = true;
  ReviewsFilterOption filter = ReviewsFilterOption.mostRecent;

  @override
  Stream<LoungeReviewsState> mapEventToState(
    LoungeReviewsEvent event,
  ) async* {
    if (event is GetLoungeReviewsEvent) {
      yield LoungeReviewsLoading();

      final failureOrReviews = await getLoungeReviews(GetLoungeReviewsParams(
        sortBy: filter.value,
        id: lounge.id,
      ));

      yield* _handleGetLoungesState(failureOrReviews);
    } else if (event is GetMoreLoungeReviewsEvent) {
      yield LoungeReviewsLoadingMore();

      final failureOrReviews =
          await getMoreLoungeReviews(GetLoungeReviewsParams(
        sortBy: filter.value,
        id: lounge.id,
      ));

      yield* _handleGetMoreLoungesState(failureOrReviews);
    }
  }

  Stream<LoungeReviewsState> _handleGetLoungesState(
    Either<Failure, List<Review?>?> failureOrReviews,
  ) async* {
    yield failureOrReviews.fold((failure) {
      return _handleFailureEvent(failure);
    }, (reviews) {
      _reviews = [];
      _reviews.addAll(reviews ?? []);
      return LoungeReviewsLoaded();
    });
  }

  Stream<LoungeReviewsState> _handleGetMoreLoungesState(
    Either<Failure, List<Review?>?> failureOrReviews,
  ) async* {
    yield failureOrReviews.fold((failure) {
      return _handleGetMoreFailureEvent(failure);
    }, (reviews) {
      if (reviews!.isEmpty) canGetMoreReviews = false;
      _reviews.addAll(reviews);
      return LoungeReviewsLoadedMore();
    });
  }

  LoungeReviewsError _handleFailureEvent(Failure failure) {
    LoungeReviewsError error;
    if (failure is ServerFailure) {
      error = LoungeReviewsError(message: failure.message, code: failure.code);
    } else {
      error = LoungeReviewsError(
        message: "unexpected_error",
        code: 500,
      );
    }

    return error;
  }

  LoungeReviewsErrorMore _handleGetMoreFailureEvent(Failure failure) {
    LoungeReviewsErrorMore error;
    if (failure is ServerFailure) {
      error = LoungeReviewsErrorMore(message: failure.message);
    } else {
      error = LoungeReviewsErrorMore(message: "unexpected_error");
    }

    return error;
  }

  void setFilter(ReviewsFilterOption loungeFilterOption) {
    if (loungeFilterOption != filter) {
      canGetMoreReviews = true;
      filter = loungeFilterOption;
    }
  }
}
