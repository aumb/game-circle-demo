part of 'user_reviews_bloc.dart';

abstract class UserReviewsEvent extends Equatable {
  const UserReviewsEvent();

  @override
  List<Object> get props => [];
}

class GetUserReviewsEvent extends UserReviewsEvent {}

class GetMoreUserReviewsEvent extends UserReviewsEvent {}
