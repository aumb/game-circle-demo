import 'dart:ui';

import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:gamecircle/core/errors/exceptions.dart';
import 'package:gamecircle/core/errors/failure.dart';
import 'package:gamecircle/features/locale/data/datasources/locale_local_data_source.dart';
import 'package:gamecircle/features/locale/data/repositories/locale_repository_impl.dart';
import 'package:mocktail/mocktail.dart';

class MockLocalDataSource extends Mock implements LocaleLocalDataSource {}

void main() {
  late LocaleRepositoryImpl repository;
  late MockLocalDataSource mockLocalDataSource;

  setUp(() {
    mockLocalDataSource = MockLocalDataSource();
    repository = LocaleRepositoryImpl(
      localDataSource: mockLocalDataSource,
    );
  });

  group('getCachedToken', () {
    final tLocale = Locale('en');

    test('should get token from local storage', () async {
      //arrange
      when(() => mockLocalDataSource.getCachedLocale())
          .thenAnswer((invocation) async => tLocale);
      //act
      final result = await repository.getCachedLocale();
      //assert
      verify(() => mockLocalDataSource.getCachedLocale()).called(1);

      expect(result, equals(Right(tLocale)));
    });

    test('should return [ServerFailure] if an error occurs', () async {
      final error = ServerException(
          ServerError(message: "local_storage_access_error", code: 401));
      final failure = ServerFailure.fromServerException(error.error);
      // arrange
      when(() => mockLocalDataSource.getCachedLocale()).thenThrow(error);
      // act
      final result = await repository.getCachedLocale();
      // assert
      verify(() => mockLocalDataSource.getCachedLocale());

      expect(result, equals(Left(failure)));
    });
  });
}
