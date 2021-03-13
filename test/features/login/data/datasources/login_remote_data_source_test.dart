import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:gamecircle/core/api.dart';
import 'package:gamecircle/core/errors/exceptions.dart';
import 'package:gamecircle/features/login/data/datasources/login_remote_data_source.dart';
import 'package:gamecircle/features/login/data/models/token_model.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:mocktail/mocktail.dart';
import 'package:matcher/matcher.dart';

import '../../../../fixtures/fixture_reader.dart';

class MockHttpClient extends Mock implements HttpClientAdapter {}

class MockGoogleSignIn extends Mock implements GoogleSignIn {}

class MockFacebookSignIn extends Mock implements FacebookAuth {}

void main() {
  late LoginRemoteDataSourceImpl dataSource;
  late MockHttpClient mockHttpClient;
  late MockGoogleSignIn mockGoogleSignIn;
  late MockFacebookSignIn mockFacebookSignIn;
  final Dio dio = Dio();

  setUpAll(() {
    registerFallbackValue<RequestOptions>(RequestOptions(path: API.login));
    mockHttpClient = MockHttpClient();
    mockGoogleSignIn = MockGoogleSignIn();
    mockFacebookSignIn = MockFacebookSignIn();

    dataSource = LoginRemoteDataSourceImpl(
      client: dio,
      googleSignIn: mockGoogleSignIn,
      facebookSignIn: mockFacebookSignIn,
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
    final tPassword = "123456";
    final tTokenModel = TokenModel.fromJson(json.decode(fixture('token.json')));

    test(
      'should return Token when the response code is 200 (success)',
      () async {
        // arrange
        setUpMockHttpClientSuccess();
        // act
        final result = await dataSource.postEmailLogin(tEmail, tPassword);
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
        final call = dataSource.postEmailLogin;
        // assert
        expect(() => call(tEmail, tPassword),
            throwsA(TypeMatcher<ServerException>()));
      },
    );
  });

  group('postSocialLogin', () {
    final tProvider = "facebook";
    final tToken = "123456";
    final tTokenModel = TokenModel.fromJson(json.decode(fixture('token.json')));

    test(
      'should return Token when the response code is 200 (success)',
      () async {
        // arrange
        setUpMockHttpClientSuccess();
        // act
        final result = await dataSource.postSocialLogin(tProvider, tToken);
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
        final call = dataSource.postSocialLogin;
        // assert
        expect(() => call(tProvider, tToken),
            throwsA(TypeMatcher<ServerException>()));
      },
    );
  });

  group('postFacebookLogin', () {
    final token = AccessToken(
      token: "123456",
    );

    final emptyToken = AccessToken();

    test(
      'should return AcessToken when the response code is 200 (success)',
      () async {
        // arrange
        when(() => mockFacebookSignIn.login())
            .thenAnswer((invocation) async => token);
        // act
        final result = await dataSource.postFacebookLogin();
        // assert
        expect(result, equals(token));
      },
    );

    test(
      'should throw a ServerException when the response code is 404 or other',
      () async {
        // arrange
        when(() => mockFacebookSignIn.login())
            .thenAnswer((invocation) async => emptyToken);
        // act
        final call = dataSource.postFacebookLogin;
        // assert
        expect(() => call(), throwsA(TypeMatcher<ServerException>()));
      },
    );
  });

  //TODO: implement google sign in tests when available.
}
