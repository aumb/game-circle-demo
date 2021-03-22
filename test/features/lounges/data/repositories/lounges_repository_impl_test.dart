import 'dart:convert';

import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:gamecircle/core/models/pagination_model.dart';
import 'package:gamecircle/features/lounges/data/datasources/lounges_remote_data_source.dart';
import 'package:gamecircle/features/lounges/data/models/lounge_model.dart';
import 'package:gamecircle/features/lounges/data/respositories/lounges_repository_impl.dart';
import 'package:mocktail/mocktail.dart';

import '../../../../fixtures/fixture_reader.dart';

class MockRemoteDataSource extends Mock implements LoungesRemoteDataSource {}

void main() {
  late LoungesRepositoryImpl repository;
  late MockRemoteDataSource mockRemoteDataSource;

  setUp(() {
    mockRemoteDataSource = MockRemoteDataSource();
    repository = LoungesRepositoryImpl(
      remoteDataSource: mockRemoteDataSource,
    );
  });

  group("getLounges", () {
    final tPaginationModel =
        PaginationModel.fromJson(json.decode(fixture('lounges.json')));
    final tLoungesModel = LoungeModel.fromJsonList(tPaginationModel.items);
    final tLounges = tLoungesModel;
    test(
      'should return remote data when the call to remote data source is successful',
      () async {
        // arrange
        when(() => mockRemoteDataSource.getLounges())
            .thenAnswer((_) async => tLoungesModel);
        // act
        final result = await repository.getLounges();
        // assert
        verify(() => mockRemoteDataSource.getLounges()).called(1);

        expect(result, equals(Right(tLounges)));
      },
    );
  });

  group("getMoreLounges", () {
    final tPaginationModel =
        PaginationModel.fromJson(json.decode(fixture('lounges.json')));
    final tLoungesModel = LoungeModel.fromJsonList(tPaginationModel.items);
    final tLounges = tLoungesModel;
    test(
      'should return remote data when the call to remote data source is successful',
      () async {
        // arrange
        when(() => mockRemoteDataSource.getMoreLounges())
            .thenAnswer((_) async => tLoungesModel);
        // act
        final result = await repository.getMoreLounges();
        // assert
        verify(() => mockRemoteDataSource.getMoreLounges()).called(1);

        expect(result, equals(Right(tLounges)));
      },
    );
  });
}
