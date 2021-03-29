import 'package:dartz/dartz.dart';

import 'package:flutter_test/flutter_test.dart';
import 'package:gamecircle/core/usecases/usecases.dart';
import 'package:gamecircle/features/favorites/domain/repositories/favorites_repository.dart';
import 'package:gamecircle/features/favorites/domain/usecases/get_more_favorite_lounges.dart';
import 'package:gamecircle/features/lounges/domain/entities/lounge.dart';

import 'package:mocktail/mocktail.dart';

class MockLoungesRepository extends Mock implements FavoritesRepository {}

void main() {
  late GetMoreFavoriteLounges usecase;
  late MockLoungesRepository mockFavoritesRepository;

  setUp(() {
    mockFavoritesRepository = MockLoungesRepository();
    usecase = GetMoreFavoriteLounges(mockFavoritesRepository);
  });

  List<Lounge?>? lounges = [];

  test(
    'should get list of "more" lounges from the repository',
    () async {
      // arrange
      when(
        () => mockFavoritesRepository.getMoreFavoriteLounges(),
      ).thenAnswer((_) async => Right(lounges));

      // act
      final result = await usecase(NoParams());

      // assert
      expect(result, Right(lounges));
      verify(() => mockFavoritesRepository.getMoreFavoriteLounges());
      verifyNoMoreInteractions(mockFavoritesRepository);
    },
  );
}
