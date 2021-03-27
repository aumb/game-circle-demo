import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:gamecircle/core/api.dart';
import 'package:gamecircle/core/errors/exceptions.dart';
import 'package:gamecircle/core/models/user_model.dart';
import 'package:gamecircle/features/profile/data/datasources/profile_remote_data_source.dart';
import 'package:matcher/matcher.dart';
import 'package:mocktail/mocktail.dart';

import '../../../../fixtures/fixture_reader.dart';

class MockHttpClient extends Mock implements HttpClientAdapter {}

void main() {
  late ProfileRemoteDataSourceImpl dataSource;
  late MockHttpClient mockHttpClient;
  final Dio dio = Dio();

  setUpAll(() {
    registerFallbackValue<RequestOptions>(RequestOptions(path: API.lounges));
    mockHttpClient = MockHttpClient();

    dataSource = ProfileRemoteDataSourceImpl(
      client: dio,
    );

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

  group('getLounges', () {
    final tUserModel = UserModel.fromJson(json.decode(fixture('user.json')));

    test(
      'should return [User] when the response code is 200 (success)',
      () async {
        // arrange
        setUpMockHttpClientSuccess();
        // act
        final result = await dataSource.postUserInformation();
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
        final call = dataSource.postUserInformation;
        // assert
        expect(() => call(), throwsA(TypeMatcher<ServerException>()));
      },
    );
  });
}
