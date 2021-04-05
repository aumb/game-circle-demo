part of 'add_edit_review_bloc.dart';

abstract class AddEditReviewState {
  const AddEditReviewState();
}

class AddEditReviewInitial extends AddEditReviewState {}

class AddEditReviewDeleting extends AddEditReviewState {}

class AddEditReviewLoading extends AddEditReviewState {}

class AddEditReviewLoaded extends AddEditReviewState {}

class AddEditReviewError extends AddEditReviewState {
  final String? message;

  AddEditReviewError({required this.message});
}

class AddEditReviewImagesChanged extends AddEditReviewState {}

class AddEditReviewFormChanged extends AddEditReviewState {}
