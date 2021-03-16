import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:gamecircle/core/api.dart';
import 'package:gamecircle/core/errors/exceptions.dart';
import 'package:gamecircle/core/models/token_model.dart';
import 'package:gamecircle/features/registration/data/datasources/registration_remote_data_source.dart';
import 'package:mocktail/mocktail.dart';
import 'package:matcher/matcher.dart';

import '../../../../fixtures/fixture_reader.dart';

class MockHttpClient extends Mock implements HttpClientAdapter {}

void main() {
  late RegistrationRemoteDataSourceImpl dataSource;
  late MockHttpClient mockHttpClient;
  final Dio dio = Dio();

  setUpAll(() {
    registerFallbackValue<RequestOptions>(RequestOptions(path: API.login));
    mockHttpClient = MockHttpClient();

    dataSource = RegistrationRemoteDataSourceImpl(
      client: dio,
    );
    dio.httpClientAdapter = mockHttpClient;
  });

  void setUpMockHttpClientSuccess() async {
    final responsepayload = fixture("token.json");

    final httpResponse =
        ResponseBody.fromString(responsepayload, 200, headers: {
      Headers.contentTypeHeader: [Headers.jsonContentType],
    });

    when(() => mockHttpClient.fetch(any(), any(), any()))
        .thenAnswer((_) async => httpResponse);
  }

  void setUpMockHttpClientFailure() {
    final responsepayload = jsonEncode({
      "error": "Something went wrong",
      "code": 500,
    });

    final httpResponse =
        ResponseBody.fromString(responsepayload, 404, headers: {
      Headers.contentTypeHeader: [Headers.jsonContentType],
    });
    when(() => mockHttpClient.fetch(any(), any(), any()))
        .thenAnswer((_) async => httpResponse);
  }

  group('postEmailLogin', () {
    final tEmail = "mathiew95@gmail.com";
    final tName = "Mathiew Abbas";
    final tPassword = "123456";
    final tConfirmPassword = "123456";
    final tTokenModel = TokenModel.fromJson(json.decode(fixture('token.json')));

    test(
      'should return Token when the response code is 200 (success)',
      () async {
        // arrange
        setUpMockHttpClientSuccess();
        // act
        final result = await dataSource.postEmailRegistration(
            email: tEmail,
            name: tName,
            password: tPassword,
            confirmPassword: tConfirmPassword);
        // assert
        expect(result, equals(tTokenModel));
      },
    );

    test(
      'should throw a ServerException when the response code is 404 or other',
      () async {
        // arrange
        setUpMockHttpClientFailure();
        // act
        final call = dataSource.postEmailRegistration;
        // assert
        expect(
            () => call(
                email: tEmail,
                name: tName,
                password: tPassword,
                confirmPassword: tConfirmPassword),
            throwsA(TypeMatcher<ServerException>()));
      },
    );
  });
}
