import 'package:dartz/dartz.dart';

import 'package:flutter_test/flutter_test.dart';
import 'package:gamecircle/features/reviews/domain/entities/review.dart';
import 'package:gamecircle/features/reviews/domain/repositories/reviews_repository.dart';
import 'package:gamecircle/features/reviews/domain/usecases/post_lounge_review.dart';

import 'package:mocktail/mocktail.dart';

class MockReviewsRepository extends Mock implements ReviewsRepository {}

void main() {
  late PostLoungeReview usecase;
  late MockReviewsRepository mockReviewsRepository;

  setUp(() {
    mockReviewsRepository = MockReviewsRepository();
    usecase = PostLoungeReview(mockReviewsRepository);
  });

  Review? review = Review(
    id: 0,
    loungeId: 0,
    rating: 3,
    review: "asdsadsad",
    images: [],
  );

  test(
    'should post review from the repository',
    () async {
      // arrange
      when(
        () => mockReviewsRepository.postLoungeReview(
          loungeId: any(named: "loungeId"),
          rating: any(named: "rating"),
          review: any(named: "review"),
          images: any(named: "images"),
        ),
      ).thenAnswer((_) async => Right(review));

      // act
      final result = await usecase(PostLoungeReviewParams(
        loungeId: review.loungeId,
        rating: review.rating?.toDouble(),
        review: review.review,
        images: [],
      ));

      // assert
      expect(result, Right(review));
      verify(() => mockReviewsRepository.postLoungeReview(
            loungeId: 0,
            rating: 3,
            review: "asdsadsad",
            images: [],
          ));
      verifyNoMoreInteractions(mockReviewsRepository);
    },
  );
}
