import 'dart:convert';

import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:gamecircle/core/models/pagination_model.dart';
import 'package:gamecircle/features/favorites/data/datasources/favorites_remote_data_source.dart';
import 'package:gamecircle/features/favorites/data/repositories/favorites_repository_impl.dart';
import 'package:gamecircle/features/lounges/data/models/lounge_model.dart';
import 'package:mocktail/mocktail.dart';

import '../../../../fixtures/fixture_reader.dart';

class MockRemoteDataSource extends Mock implements FavoritesRemoteDataSource {}

void main() {
  late FavoritesRepositoryImpl repository;
  late MockRemoteDataSource mockRemoteDataSource;

  setUp(() {
    mockRemoteDataSource = MockRemoteDataSource();
    repository = FavoritesRepositoryImpl(
      remoteDataSource: mockRemoteDataSource,
    );
  });

  group("getFavoriteLounges", () {
    final tPaginationModel =
        PaginationModel.fromJson(json.decode(fixture('lounges.json')));
    final tLoungesModel = LoungeModel.fromJsonList(tPaginationModel.items);
    final tLounges = tLoungesModel;
    test(
      'should return remote data when the call to remote data source is successful',
      () async {
        // arrange
        when(() => mockRemoteDataSource.getFavoriteLounges())
            .thenAnswer((_) async => tLoungesModel);
        // act
        final result = await repository.getFavoriteLounges();
        // assert
        verify(() => mockRemoteDataSource.getFavoriteLounges()).called(1);

        expect(result, equals(Right(tLounges)));
      },
    );
  });

  group("getMoreFavoriteLounges", () {
    final tPaginationModel =
        PaginationModel.fromJson(json.decode(fixture('lounges.json')));
    final tLoungesModel = LoungeModel.fromJsonList(tPaginationModel.items);
    final tLounges = tLoungesModel;
    test(
      'should return remote data when the call to remote data source is successful',
      () async {
        // arrange
        when(() => mockRemoteDataSource.getMoreFavoriteLounges())
            .thenAnswer((_) async => tLoungesModel);
        // act
        final result = await repository.getMoreFavoriteLounges();
        // assert
        verify(() => mockRemoteDataSource.getMoreFavoriteLounges()).called(1);

        expect(result, equals(Right(tLounges)));
      },
    );
  });
}
