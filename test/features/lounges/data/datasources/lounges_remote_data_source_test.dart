import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:gamecircle/core/api.dart';
import 'package:gamecircle/core/errors/exceptions.dart';
import 'package:gamecircle/core/models/pagination_model.dart';
import 'package:gamecircle/features/lounges/data/datasources/lounges_remote_data_source.dart';
import 'package:gamecircle/features/lounges/data/models/lounge_model.dart';
import 'package:matcher/matcher.dart';
import 'package:mocktail/mocktail.dart';

import '../../../../fixtures/fixture_reader.dart';

class MockHttpClient extends Mock implements HttpClientAdapter {}

void main() {
  late LoungesRemoteDataSourceImpl dataSource;
  late MockHttpClient mockHttpClient;
  final Dio dio = Dio();

  setUpAll(() {
    final tPaginationModel =
        PaginationModel.fromJson(json.decode(fixture('lounges.json')));
    registerFallbackValue<RequestOptions>(RequestOptions(path: API.lounges));
    mockHttpClient = MockHttpClient();

    dataSource = LoungesRemoteDataSourceImpl(
      client: dio,
    );

    dio.httpClientAdapter = mockHttpClient;
    dataSource.paginationModel = tPaginationModel;
  });

  void setUpMockHttpClientSuccess() async {
    final responsepayload = fixture("lounges.json");

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
    final tPaginationModel =
        PaginationModel.fromJson(json.decode(fixture('lounges.json')));
    final tLoungesModel = LoungeModel.fromJsonList(tPaginationModel.items);

    test(
      'should return List<Lounges> when the response code is 200 (success)',
      () async {
        // arrange
        setUpMockHttpClientSuccess();
        // act
        final result = await dataSource.getLounges();
        // assert
        expect(result, equals(tLoungesModel));
      },
    );

    test(
      'should throw a ServerException when the response code is 404 or other',
      () async {
        // arrange
        setUpMockHttpClientFailure();
        // act
        final call = dataSource.getLounges;
        // assert
        expect(() => call(), throwsA(TypeMatcher<ServerException>()));
      },
    );
  });

  group('getMoreLounges', () {
    final tPaginationModel =
        PaginationModel.fromJson(json.decode(fixture('lounges.json')));
    final tLoungesModel = LoungeModel.fromJsonList(tPaginationModel.items);

    test(
      'should return List<Lounges> when the response code is 200 (success)',
      () async {
        // arrange
        setUpMockHttpClientSuccess();
        // act
        final result = await dataSource.getMoreLounges();
        // assert
        expect(result, equals(tLoungesModel));
      },
    );

    test(
      'should throw a ServerException when the response code is 404 or other',
      () async {
        // arrange
        setUpMockHttpClientFailure();
        // act
        final call = dataSource.getMoreLounges;
        // assert
        expect(() => call(), throwsA(TypeMatcher<ServerException>()));
      },
    );
  });
}
