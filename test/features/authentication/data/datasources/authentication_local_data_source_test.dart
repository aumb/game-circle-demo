import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:gamecircle/core/errors/exceptions.dart';
import 'package:gamecircle/features/authentication/data/datasources/authentication_local_data_source.dart';
import 'package:gamecircle/features/login/data/datasources/login_local_data_source.dart';
import 'package:gamecircle/core/models/token_model.dart';
import 'package:mocktail/mocktail.dart';
import 'package:matcher/matcher.dart';

import 'package:shared_preferences/shared_preferences.dart';

class MockSharedPreferences extends Mock implements SharedPreferences {}

void main() {
  late AuthenticationLocalDataSourceImpl dataSource;
  late MockSharedPreferences mockSharedPreferences;

  setUp(() {
    mockSharedPreferences = MockSharedPreferences();
    dataSource = AuthenticationLocalDataSourceImpl(
      sharedPreferences: mockSharedPreferences,
    );
  });

  group('getCachedToken', () {
    final tTokenModel =
        TokenModel(accessToken: "abcdef", refreshToken: "123456");

    test(
      'should call SharedPreferences to cache the data',
      () async {
        //arrange
        when(() => mockSharedPreferences.getString(any()))
            .thenAnswer((invocation) => jsonEncode(tTokenModel.toJson()));
        // act
        final result = await dataSource.getCachedToken();
        // assert
        verify(() => mockSharedPreferences.getString(CACHED_TOKEN));
        expect(result, equals(tTokenModel));
      },
    );

    test(
      'should throw a [ServerException] when an error occurs while getting token',
      () async {
        final error = ServerException(
            ServerError(message: "Could not access local storage", code: 401));
        // arrange
        when(() => mockSharedPreferences.getString(any())).thenThrow(error);
        // act
        final call = dataSource.getCachedToken;
        // assert
        expect(() => call(), throwsA(TypeMatcher<ServerException>()));
      },
    );
  });
}
