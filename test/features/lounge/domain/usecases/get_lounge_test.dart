import 'dart:convert';

import 'package:dartz/dartz.dart';

import 'package:flutter_test/flutter_test.dart';
import 'package:gamecircle/features/lounge/domain/respositories/lounge_repository.dart';
import 'package:gamecircle/features/lounge/domain/usecases/get_lounge.dart';
import 'package:gamecircle/features/lounges/data/models/lounge_model.dart';
import 'package:gamecircle/features/lounges/domain/entities/lounge.dart';

import 'package:mocktail/mocktail.dart';

import '../../../../fixtures/fixture_reader.dart';

class MockLoungeRepository extends Mock implements LoungeRepository {}

void main() {
  late GetLounge usecase;
  late MockLoungeRepository mockLoungeRepository;

  setUp(() {
    mockLoungeRepository = MockLoungeRepository();
    usecase = GetLounge(mockLoungeRepository);
  });

  Lounge? lounge = LoungeModel.fromJson(json.decode(fixture('lounge.json')));

  test(
    'should get lounge from the repository',
    () async {
      // arrange
      when(
        () => mockLoungeRepository.getLounge(
          id: any(named: "id"),
        ),
      ).thenAnswer((_) async => Right(lounge));

      // act
      final result = await usecase(GetLoungeParams(id: 2));

      // assert
      expect(result, Right(lounge));
      verify(() => mockLoungeRepository.getLounge(
            id: 2,
          ));
      verifyNoMoreInteractions(mockLoungeRepository);
    },
  );
}
