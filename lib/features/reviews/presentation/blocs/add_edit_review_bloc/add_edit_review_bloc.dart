import 'dart:async';
import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:gamecircle/core/entities/gc_image.dart';
import 'package:gamecircle/core/errors/failure.dart';
import 'package:gamecircle/core/utils/string_utils.dart';
import 'package:gamecircle/features/reviews/domain/entities/review.dart';
import 'package:gamecircle/features/reviews/domain/usecases/delete_lounge_review.dart';
import 'package:gamecircle/features/reviews/domain/usecases/patch_lounge_review.dart';
import 'package:gamecircle/features/reviews/domain/usecases/post_lounge_review.dart';

part 'add_edit_review_event.dart';
part 'add_edit_review_state.dart';

class AddEditReviewBloc extends Bloc<AddEditReviewEvent, AddEditReviewState> {
  final Review? review;
  final PatchLoungeReview patchLoungeReview;
  final PostLoungeReview postLoungeReview;
  final DeleteLoungeReview deleteLoungeReview;

  late List<int?> deletedImages;
  late List<File?> addedImages;
  late List<GCImage?>? reviewImages;
  late List<dynamic>? allImages;

  late double? reviewRating;
  late String? reviewText;

  AddEditReviewBloc({
    required this.patchLoungeReview,
    required this.postLoungeReview,
    required this.deleteLoungeReview,
    this.review,
  }) : super(AddEditReviewInitial()) {
    reviewText = review?.review;
    reviewRating = review?.rating?.toDouble();
    reviewImages = [];
    deletedImages = [];
    addedImages = [];
    reviewImages!.addAll(review?.images ?? []);
    allImages = [...reviewImages ?? []];
  }

  bool get canSubmitPage =>
      StringUtils().isNotEmpty(reviewText) && isRatingValid && didValuesChange;

  bool get isRatingValid => reviewRating != null && reviewRating != 0;

  bool get didValuesChange {
    bool didChange = false;

    if (reviewRating != review?.rating) {
      didChange = true;
    } else if (reviewText != review?.review) {
      didChange = true;
    } else if (deletedImages.isNotEmpty || addedImages.isNotEmpty) {
      didChange = true;
    }
    return didChange;
  }

  @override
  Stream<AddEditReviewState> mapEventToState(
    AddEditReviewEvent event,
  ) async* {
    if (event is ChangedRatingEvent) {
      reviewRating = event.rating;
      yield AddEditReviewFormChanged();
    } else if (event is ChangedReviewEvent) {
      reviewText = event.reviewText;
      yield AddEditReviewFormChanged();
    } else if (event is AddedImageEvent) {
      addedImages.addAll(event.images);
      allImages = [
        ...addedImages,
        ...reviewImages ?? [],
      ];
      yield AddEditReviewImagesChanged();
    } else if (event is DeletedImageEvent) {
      yield _handleDeletedImageEvent(event);
    } else if (event is PatchReviewEvent) {
      yield AddEditReviewLoading();
      final changedReview = await patchLoungeReview(
        PatchLoungeReviewParams(
          reviewId: review?.id,
          rating: review?.rating != reviewRating ? reviewRating : null,
          review: review?.review != reviewText ? reviewText : null,
          deletedImages: deletedImages,
          images: addedImages,
        ),
      );
      yield* _handlePatchPostDelete(failureOrReview: changedReview);
    } else if (event is PostReviewEvent) {
      yield AddEditReviewLoading();
      final newReview = await postLoungeReview(
        PostLoungeReviewParams(
          loungeId: review?.lounge?.id,
          rating: review?.rating != reviewRating ? reviewRating : null,
          review: review?.review != reviewText ? reviewText : null,
          images: addedImages,
        ),
      );
      yield* _handlePatchPostDelete(failureOrReview: newReview);
    } else if (event is DeleteReviewEvent) {
      yield AddEditReviewDeleting();
      final newReview = await deleteLoungeReview(DeleteLoungeReviewParams(
        id: review?.id,
      ));
      yield* _handlePatchPostDelete(failureOrReview: newReview);
    }
  }

  AddEditReviewState _handleDeletedImageEvent(DeletedImageEvent event) {
    if (event.image is File) {
      final eventImage = event.image as File;
      final image =
          addedImages.firstWhere((element) => element?.path == eventImage.path);
      addedImages.remove(image);
    } else if (event.image is GCImage) {
      final eventImage = event.image as GCImage;
      final image = reviewImages!
          .firstWhere((element) => element?.imageUrl == eventImage.imageUrl);
      reviewImages!.remove(image);
      deletedImages.add(eventImage.id);
    }
    allImages = [
      ...addedImages,
      ...reviewImages ?? [],
    ];
    return AddEditReviewImagesChanged();
  }

  Stream<AddEditReviewState> _handlePatchPostDelete(
      {required Either<Failure, Review?> failureOrReview}) async* {
    yield failureOrReview.fold(
      (failure) {
        return _handlePatchAndPostFailureState(failure);
      },
      (review) {
        return AddEditReviewLoaded();
      },
    );
  }

  AddEditReviewError _handlePatchAndPostFailureState(Failure failure) {
    AddEditReviewError error;
    if (failure is ServerFailure) {
      error = AddEditReviewError(message: failure.message);
    } else {
      error = AddEditReviewError(message: "unexpected_error");
    }

    return error;
  }

  Color ratingColor() {
    Color _starColor = Color.fromRGBO(255, 255, 255, 0.87);
    if (reviewRating == 1.0) {
      _starColor = Colors.red;
    } else if (reviewRating == 2.0) {
      _starColor = Colors.orange;
    } else if (reviewRating == 3.0) {
      _starColor = Colors.yellow;
    } else if (reviewRating == 4.0) {
      _starColor = Colors.lightGreen;
    } else if (reviewRating == 5.0) {
      _starColor = Colors.green;
    }
    return _starColor;
  }

  String ratingText() {
    // Text _ratingText = Text("");
    String _ratingText = '';
    if (reviewRating == 1.0) {
      _ratingText = "horrible";
    } else if (reviewRating == 2.0) {
      _ratingText = "bad";
    } else if (reviewRating == 3.0) {
      _ratingText = "average";
    } else if (reviewRating == 4.0) {
      _ratingText = "good";
    } else if (reviewRating == 5.0) {
      _ratingText = "excellent";
    }
    return _ratingText;
  }
}
