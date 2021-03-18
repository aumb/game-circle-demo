import 'package:dartz/dartz.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:gamecircle/core/usecases/usecases.dart';
import 'package:gamecircle/features/locale/domain/repositories/locale_repository.dart';
import 'package:gamecircle/features/locale/domain/usecases/get_cached_locale.dart';

import 'package:mocktail/mocktail.dart';

class MockLocaleRepository extends Mock implements LocaleRepository {}

void main() {
  late GetCachedLocale usecase;
  late MockLocaleRepository mockLocaleRepository;

  setUp(() {
    mockLocaleRepository = MockLocaleRepository();
    usecase = GetCachedLocale(mockLocaleRepository);
  });

  final locale = Locale('en');

  test(
    'should get locale from local storage',
    () async {
      // arrange
      when(() => mockLocaleRepository.getCachedLocale())
          .thenAnswer((_) async => Right(locale));

      // act
      final result = await usecase(NoParams());

      // assert
      expect(result, Right(locale));
      verify(() => mockLocaleRepository.getCachedLocale());
      verifyNoMoreInteractions(mockLocaleRepository);
    },
  );
}
