part of 'lounge_reviews_bloc.dart';

abstract class LoungeReviewsEvent extends Equatable {
  const LoungeReviewsEvent();

  @override
  List<Object> get props => [];
}

class GetLoungeReviewsEvent extends LoungeReviewsEvent {}

class GetMoreLoungeReviewsEvent extends LoungeReviewsEvent {}
