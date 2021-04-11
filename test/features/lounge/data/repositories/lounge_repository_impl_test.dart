import 'dart:convert';

import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:gamecircle/features/lounge/data/datasources/lounge_remote_data_source.dart';
import 'package:gamecircle/features/lounge/data/repositories/lounge_repository_impl.dart';
import 'package:gamecircle/features/lounges/data/models/lounge_model.dart';
import 'package:gamecircle/features/lounges/domain/entities/lounge.dart';
import 'package:mocktail/mocktail.dart';

import '../../../../fixtures/fixture_reader.dart';

class MockRemoteDataSource extends Mock implements LoungeRemoteDataSource {}

void main() {
  late LoungeRepositoryImpl repository;
  late MockRemoteDataSource mockRemoteDataSource;

  setUp(() {
    mockRemoteDataSource = MockRemoteDataSource();
    repository = LoungeRepositoryImpl(
      remoteDataSource: mockRemoteDataSource,
    );
  });

  group("getLounge", () {
    final Lounge? tLounge =
        LoungeModel.fromJson(json.decode(fixture('lounge.json')));

    test(
      'should return remote data when the call to remote data source is successful',
      () async {
        // arrange
        when(() => mockRemoteDataSource.getLounge(id: any(named: "id")))
            .thenAnswer((_) async => tLounge);
        // act
        final result = await repository.getLounge(id: 2);
        // assert
        verify(() => mockRemoteDataSource.getLounge(id: 2)).called(1);

        expect(result, equals(Right(tLounge)));
      },
    );
  });
}
