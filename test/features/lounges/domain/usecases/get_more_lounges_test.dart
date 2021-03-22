import 'package:dartz/dartz.dart';

import 'package:flutter_test/flutter_test.dart';
import 'package:gamecircle/features/lounges/domain/entities/lounge.dart';
import 'package:gamecircle/features/lounges/domain/repositories/lounges_repository.dart';
import 'package:gamecircle/features/lounges/domain/usecases/get_lounges.dart';
import 'package:gamecircle/features/lounges/domain/usecases/get_more_lounges.dart';

import 'package:mocktail/mocktail.dart';

class MockLoungesRepository extends Mock implements LoungesRepository {}

void main() {
  late GetMoreLounges usecase;
  late MockLoungesRepository mockLoungesRepository;

  setUp(() {
    mockLoungesRepository = MockLoungesRepository();
    usecase = GetMoreLounges(mockLoungesRepository);
  });

  List<Lounge?>? lounges = [];

  test(
    'should get list of "more" lounges from the repository',
    () async {
      // arrange
      when(
        () => mockLoungesRepository.getMoreLounges(
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
      verify(() => mockLoungesRepository.getMoreLounges());
      verifyNoMoreInteractions(mockLoungesRepository);
    },
  );
}
