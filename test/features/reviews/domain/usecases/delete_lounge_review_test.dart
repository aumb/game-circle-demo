import 'package:dartz/dartz.dart';

import 'package:flutter_test/flutter_test.dart';
import 'package:gamecircle/features/reviews/domain/entities/review.dart';
import 'package:gamecircle/features/reviews/domain/repositories/reviews_repository.dart';
import 'package:gamecircle/features/reviews/domain/usecases/delete_lounge_review.dart';

import 'package:mocktail/mocktail.dart';

class MockReviewsRepository extends Mock implements ReviewsRepository {}

void main() {
  late DeleteLoungeReview usecase;
  late MockReviewsRepository mockReviewsRepository;

  setUp(() {
    mockReviewsRepository = MockReviewsRepository();
    usecase = DeleteLoungeReview(mockReviewsRepository);
  });

  Review? review = Review(
    id: 0,
    rating: 3,
    review: "asdsadsad",
    images: [],
  );

  test(
    'should delete review from the repository',
    () async {
      // arrange
      when(
        () => mockReviewsRepository.deleteLoungeReview(
          id: any(named: "id"),
        ),
      ).thenAnswer((_) async => Right(review));

      // act
      final result = await usecase(DeleteLoungeReviewParams(
        id: 0,
      ));

      // assert
      expect(result, Right(review));
      verify(() => mockReviewsRepository.deleteLoungeReview(id: 0));
      verifyNoMoreInteractions(mockReviewsRepository);
    },
  );
}
