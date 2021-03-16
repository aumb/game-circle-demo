import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:gamecircle/core/models/token_model.dart';
import 'package:gamecircle/features/login/data/datasources/login_local_data_source.dart';
import 'package:gamecircle/features/registration/data/datasources/registration_local_data_source.dart';
import 'package:mocktail/mocktail.dart';

import 'package:shared_preferences/shared_preferences.dart';

class MockSharedPreferences extends Mock implements SharedPreferences {}

void main() {
  late RegistrationLocalDataSourceImpl dataSource;
  late MockSharedPreferences mockSharedPreferences;

  setUp(() {
    mockSharedPreferences = MockSharedPreferences();
    dataSource = RegistrationLocalDataSourceImpl(
      sharedPreferences: mockSharedPreferences,
    );
  });

  group('cacheToken', () {
    final tTokenModel =
        TokenModel(accessToken: "abcdef", refreshToken: "123456");

    test(
      'should call SharedPreferences to cache the data',
      () async {
        //arrange
        when(() => mockSharedPreferences.setString(any(), any()))
            .thenAnswer((invocation) => Future.value(true));
        // act
        dataSource.cacheToken(tTokenModel);
        // assert
        final expectedJsonString = json.encode(tTokenModel.toJson());
        verify(() => mockSharedPreferences.setString(
              CACHED_TOKEN,
              expectedJsonString,
            )).called(1);
      },
    );
  });
}
