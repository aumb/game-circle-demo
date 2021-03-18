import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:gamecircle/core/api.dart';
import 'package:gamecircle/core/errors/exceptions.dart';
import 'package:gamecircle/core/models/user_model.dart';
import 'package:gamecircle/features/home/data/datasources/user_remote_data_source.dart';
import 'package:mocktail/mocktail.dart';
import 'package:matcher/matcher.dart';

import '../../../../fixtures/fixture_reader.dart';

class MockHttpClient extends Mock implements HttpClientAdapter {}

void main() {
  late UserRemoteDataSourceImpl dataSource;
  late MockHttpClient mockHttpClient;
  final Dio dio = Dio();

  setUp(() {
    registerFallbackValue<RequestOptions>(RequestOptions(path: API.user));
    registerFallbackValue<RequestOptions>(RequestOptions(path: API.users));
    mockHttpClient = MockHttpClient();

    dataSource = UserRemoteDataSourceImpl(client: dio);
    dio.httpClientAdapter = mockHttpClient;
  });

  void setUpMockHttpClientSuccess() async {
    final responsepayload = fixture("user.json");

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

  group('getCurrentUserInfo', () {
    final tUserModel = UserModel.fromJson(json.decode(fixture('user.json')));

    test(
      'should return [User] when the response code is 200 (success)',
      () async {
        // arrange
        setUpMockHttpClientSuccess();
        // act
        final result = await dataSource.getCurrentUserInfo();
        // assert
        expect(result, equals(tUserModel));
      },
    );

    test(
      'should throw a ServerException when the response code is 404 or other',
      () async {
        // arrange
        setUpMockHttpClientFailure();
        // act
        final call = dataSource.getCurrentUserInfo;
        // assert
        expect(() => call(), throwsA(TypeMatcher<ServerException>()));
      },
    );
  });

  group('getUserInfo', () {
    final id = 0;
    final tUserModel = UserModel.fromJson(json.decode(fixture('user.json')));

    test(
      'should return [User] when the response code is 200 (success)',
      () async {
        // arrange
        setUpMockHttpClientSuccess();
        // act
        final result = await dataSource.getUserInfo(id);
        // assert
        expect(result, equals(tUserModel));
      },
    );

    test(
      'should throw a ServerException when the response code is 404 or other',
      () async {
        // arrange
        setUpMockHttpClientFailure();
        // act
        final call = dataSource.getUserInfo;
        // assert
        expect(() => call(id), throwsA(TypeMatcher<ServerException>()));
      },
    );
  });
}
