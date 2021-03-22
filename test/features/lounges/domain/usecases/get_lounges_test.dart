import 'package:dartz/dartz.dart';

import 'package:flutter_test/flutter_test.dart';
import 'package:gamecircle/features/lounges/domain/entities/lounge.dart';
import 'package:gamecircle/features/lounges/domain/repositories/lounges_repository.dart';
import 'package:gamecircle/features/lounges/domain/usecases/get_lounges.dart';

import 'package:mocktail/mocktail.dart';

class MockLoungesRepository extends Mock implements LoungesRepository {}

void main() {
  late GetLounges usecase;
  late MockLoungesRepository mockLoungesRepository;

  setUp(() {
    mockLoungesRepository = MockLoungesRepository();
    usecase = GetLounges(mockLoungesRepository);
  });

  List<Lounge?>? lounges = [];

  test(
    'should get list of lounges from the repository',
    () async {
      // arrange
      when(
        () => mockLoungesRepository.getLounges(
          longitude: any(named: "longitude"),
          latitude: any(named: "latitude"),
          sortBy: any(named: "sortBy"),
          query: any(named: "query"),
        ),
      ).thenAnswer((_) async => Right(lounges));

      // act
      final result = await usecase(GetLoungesParams());

      // assert
      expect(result, Right(lounges));
      verify(() => mockLoungesRepository.getLounges());
      verifyNoMoreInteractions(mockLoungesRepository);
    },
  );
}
