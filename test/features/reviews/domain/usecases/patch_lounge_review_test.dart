import 'package:dartz/dartz.dart';

import 'package:flutter_test/flutter_test.dart';
import 'package:gamecircle/features/reviews/domain/entities/review.dart';
import 'package:gamecircle/features/reviews/domain/repositories/reviews_repository.dart';
import 'package:gamecircle/features/reviews/domain/usecases/patch_lounge_review.dart';

import 'package:mocktail/mocktail.dart';

class MockReviewsRepository extends Mock implements ReviewsRepository {}

void main() {
  late PatchLoungeReview usecase;
  late MockReviewsRepository mockReviewsRepository;

  setUp(() {
    mockReviewsRepository = MockReviewsRepository();
    usecase = PatchLoungeReview(mockReviewsRepository);
  });

  Review? review = Review(
    id: 0,
    loungeId: 0,
    rating: 3,
    review: "asdsadsad",
    images: [],
  );

  test(
    'should patch review from the repository',
    () async {
      // arrange
      when(
        () => mockReviewsRepository.patchLoungeReview(
          reviewId: any(named: "reviewId"),
          rating: any(named: "rating"),
          review: any(named: "review"),
          images: any(named: "images"),
          deletedImages: any(named: "deletedImages"),
        ),
      ).thenAnswer((_) async => Right(review));

      // act
      final result = await usecase(PatchLoungeReviewParams(
        reviewId: review.id,
        rating: review.rating?.toDouble(),
        review: review.review,
        deletedImages: [],
        images: [],
      ));

      // assert
      expect(result, Right(review));
      verify(() => mockReviewsRepository.patchLoungeReview(
            reviewId: 0,
            rating: 3,
            review: "asdsadsad",
            deletedImages: [],
            images: [],
          ));
      verifyNoMoreInteractions(mockReviewsRepository);
    },
  );
}
