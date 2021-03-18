import 'dart:ui';

import 'package:flutter_test/flutter_test.dart';
import 'package:gamecircle/core/errors/exceptions.dart';
import 'package:gamecircle/core/utils/const_utils.dart';
import 'package:gamecircle/features/locale/data/datasources/locale_local_data_source.dart';
import 'package:mocktail/mocktail.dart';
import 'package:matcher/matcher.dart';

import 'package:shared_preferences/shared_preferences.dart';

class MockSharedPreferences extends Mock implements SharedPreferences {}

void main() {
  late LocaleLocalDataSourceImpl dataSource;
  late MockSharedPreferences mockSharedPreferences;

  setUp(() {
    mockSharedPreferences = MockSharedPreferences();
    dataSource = LocaleLocalDataSourceImpl(
      sharedPreferences: mockSharedPreferences,
    );
  });

  group('getCachedLocale', () {
    final tLocale = Locale('en', 'US');

    test(
      'should call SharedPreferences to cache the data',
      () async {
        //arrange
        when(() => mockSharedPreferences.getString(any())).thenReturn("en");
        // act
        final result = await dataSource.getCachedLocale();
        // assert
        verify(() => mockSharedPreferences.getString(CACHED_LOCALE));
        expect(result, equals(tLocale));
      },
    );

    test(
      'should throw a [ServerException] when an error occurs while getting token',
      () async {
        final error = ServerException(
            ServerError(message: "local_storage_access_error", code: 401));
        // arrange
        when(() => mockSharedPreferences.getString(any())).thenThrow(error);
        // act
        final call = dataSource.getCachedLocale;
        // assert
        expect(() => call(), throwsA(TypeMatcher<ServerException>()));
      },
    );
  });
}
