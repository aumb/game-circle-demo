import 'package:dartz/dartz.dart';

import 'package:flutter_test/flutter_test.dart';
import 'package:gamecircle/features/reviews/domain/entities/review.dart';
import 'package:gamecircle/features/reviews/domain/repositories/reviews_repository.dart';
import 'package:gamecircle/features/reviews/domain/usecases/get_lounge_reviews.dart';

import 'package:mocktail/mocktail.dart';

class MockReviewsRepository extends Mock implements ReviewsRepository {}

void main() {
  late GetLoungeReviews usecase;
  late MockReviewsRepository mockReviewsRepository;

  setUp(() {
    mockReviewsRepository = MockReviewsRepository();
    usecase = GetLoungeReviews(mockReviewsRepository);
  });

  Review? review = Review(
    id: 0,
    rating: 3,
    review: "asdsadsad",
    images: [],
  );

  List<Review?>? reviews = [review, review, review];

  test(
    'should get a list of reviews from the repository',
    () async {
      // arrange
      when(
        () => mockReviewsRepository.getLoungeReviews(
          sortBy: any(named: "sortBy"),
          id: any(named: "id"),
        ),
      ).thenAnswer((_) async => Right(reviews));

      // act
      final result = await usecase(GetLoungeReviewsParams(
        sortBy: "",
        id: 0,
      ));

      // assert
      expect(result, Right(reviews));
      verify(() => mockReviewsRepository.getLoungeReviews(
            sortBy: "",
            id: 0,
          ));
      verifyNoMoreInteractions(mockReviewsRepository);
    },
  );
}
