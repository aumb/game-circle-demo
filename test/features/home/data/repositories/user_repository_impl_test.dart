import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:gamecircle/core/entities/user.dart';
import 'package:gamecircle/features/home/data/datasources/user_remote_data_source.dart';
import 'package:gamecircle/features/home/data/repositories/user_repository_impl.dart';
import 'package:mocktail/mocktail.dart';

class MockRemoteDataSource extends Mock implements UserRemoteDataSource {}

void main() {
  late UserRepositoryImpl repository;
  late MockRemoteDataSource mockRemoteDataSource;

  setUp(() {
    mockRemoteDataSource = MockRemoteDataSource();
    repository = UserRepositoryImpl(
      remoteDataSource: mockRemoteDataSource,
    );
  });

  group("getCurrentUserInfo", () {
    final tUser = User(name: "abcdef", email: "123456", id: 1);

    test(
      'should return remote data when the call to remote data source is successful',
      () async {
        // arrange
        when(() => mockRemoteDataSource.getCurrentUserInfo())
            .thenAnswer((_) async => tUser);
        // act
        final result = await repository.getCurrentUserInfo();
        // assert
        verify(() => mockRemoteDataSource.getCurrentUserInfo()).called(1);

        expect(result, equals(Right(tUser)));
      },
    );
  });
}
