import 'package:dartz/dartz.dart';

import 'package:flutter_test/flutter_test.dart';
import 'package:gamecircle/core/usecases/usecases.dart';
import 'package:gamecircle/features/favorites/domain/repositories/favorites_repository.dart';
import 'package:gamecircle/features/favorites/domain/usecases/get_favorite_lounges.dart';
import 'package:gamecircle/features/lounges/domain/entities/lounge.dart';

import 'package:mocktail/mocktail.dart';

class MockLoungesRepository extends Mock implements FavoritesRepository {}

void main() {
  late GetFavoriteLounges usecase;
  late MockLoungesRepository mockFavoritesRepository;

  setUp(() {
    mockFavoritesRepository = MockLoungesRepository();
    usecase = GetFavoriteLounges(mockFavoritesRepository);
  });

  List<Lounge?>? lounges = [];

  test(
    'should get list of lounges from the repository',
    () async {
      // arrange
      when(
        () => mockFavoritesRepository.getFavoriteLounges(),
      ).thenAnswer((_) async => Right(lounges));

      // act
      final result = await usecase(NoParams());

      // assert
      expect(result, Right(lounges));
      verify(() => mockFavoritesRepository.getFavoriteLounges());
      verifyNoMoreInteractions(mockFavoritesRepository);
    },
  );
}
