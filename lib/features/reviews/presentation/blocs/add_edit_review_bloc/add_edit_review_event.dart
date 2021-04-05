part of 'add_edit_review_bloc.dart';

abstract class AddEditReviewEvent extends Equatable {
  const AddEditReviewEvent();

  @override
  List<Object?> get props => [];
}

class ChangedRatingEvent extends AddEditReviewEvent {
  final double? rating;

  ChangedRatingEvent({
    required this.rating,
  });

  @override
  List<Object?> get props => [rating];
}

class ChangedReviewEvent extends AddEditReviewEvent {
  final String? reviewText;

  ChangedReviewEvent({
    required this.reviewText,
  });

  @override
  List<Object?> get props => [reviewText];
}

class AddedImageEvent extends AddEditReviewEvent {
  final List<File?> images;

  AddedImageEvent({
    required this.images,
  });

  @override
  List<Object?> get props => [images];
}

class DeletedImageEvent extends AddEditReviewEvent {
  final dynamic image;

  DeletedImageEvent({
    required this.image,
  });

  @override
  List<Object?> get props => [image];
}

class DeleteReviewEvent extends AddEditReviewEvent {}

class PostReviewEvent extends AddEditReviewEvent {}

class PatchReviewEvent extends AddEditReviewEvent {}
