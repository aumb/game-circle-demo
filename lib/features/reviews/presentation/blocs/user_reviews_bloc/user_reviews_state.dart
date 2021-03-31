part of 'user_reviews_bloc.dart';

abstract class UserReviewsState extends Equatable {
  const UserReviewsState();

  @override
  List<Object?> get props => [];
}

class UserReviewsInitial extends UserReviewsState {}

class UserReviewsLoading extends UserReviewsState {}

class UserReviewsLoaded extends UserReviewsState {}

class UserReviewsLoadingMore extends UserReviewsState {}

class UserReviewsLoadedMore extends UserReviewsState {}

class UserReviewsErrorMore extends UserReviewsState {
  final String? message;

  UserReviewsErrorMore({required this.message});

  @override
  List<Object?> get props => [message];
}

class UserReviewsError extends UserReviewsState {
  final String? message;

  UserReviewsError({required this.message});

  @override
  List<Object?> get props => [message];
}
