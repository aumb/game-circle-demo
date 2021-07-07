part of 'lounge_reviews_bloc.dart';

abstract class LoungeReviewsState extends Equatable {
  const LoungeReviewsState();

  @override
  List<Object?> get props => [];
}

class LoungeReviewsInitial extends LoungeReviewsState {}

class LoungeReviewsLoading extends LoungeReviewsState {}

class LoungeReviewsLoaded extends LoungeReviewsState {}

class LoungeReviewsError extends LoungeReviewsState {
  final String? message;
  final int? code;

  LoungeReviewsError({this.message, this.code});

  @override
  List<Object?> get props => [message, code];
}

class LoungeReviewsLoadingMore extends LoungeReviewsState {}

class LoungeReviewsLoadedMore extends LoungeReviewsState {}

class LoungeReviewsErrorMore extends LoungeReviewsState {
  final String? message;
  final int? code;

  LoungeReviewsErrorMore({this.message, this.code});

  @override
  List<Object?> get props => [message, code];
}
