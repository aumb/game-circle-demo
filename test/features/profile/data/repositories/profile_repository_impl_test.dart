import 'dart:convert';

import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:gamecircle/core/models/user_model.dart';
import 'package:gamecircle/features/profile/data/datasources/profile_remote_data_source.dart';
import 'package:gamecircle/features/profile/data/repositories/profile_repository_impl.dart';
import 'package:mocktail/mocktail.dart';

import '../../../../fixtures/fixture_reader.dart';

class MockRemoteDataSource extends Mock implements ProfileRemoteDataSource {}

void main() {
  late ProfileRepositoryImpl repository;
  late MockRemoteDataSource mockRemoteDataSource;

  setUp(() {
    mockRemoteDataSource = MockRemoteDataSource();
    repository = ProfileRepositoryImpl(
      remoteDataSource: mockRemoteDataSource,
    );
  });

  group("postUserInformation", () {
    final tUserModel = UserModel.fromJson(json.decode(fixture('user.json')));
    test(
      'should return remote data when the call to remote data source is successful',
      () async {
        // arrange
        when(() => mockRemoteDataSource.postUserInformation())
            .thenAnswer((_) async => tUserModel);
        // act
        final result = await repository.postUserInformation();
        // assert
        verify(() => mockRemoteDataSource.postUserInformation()).called(1);

        expect(result, equals(Right(tUserModel)));
      },
    );
  });
}
