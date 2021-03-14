import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:gamecircle/core/errors/exceptions.dart';
import 'package:gamecircle/core/errors/failure.dart';
import 'package:gamecircle/core/models/token_model.dart';
import 'package:gamecircle/features/authentication/data/datasources/authentication_local_data_source.dart';
import 'package:gamecircle/features/authentication/data/repositories/authentication_repository_impl.dart';
import 'package:mocktail/mocktail.dart';

class MockLocalDataSource extends Mock
    implements AuthenticationLocalDataSource {}

void main() {
  late AuthenticationRepositoryImpl repository;
  late MockLocalDataSource mockLocalDataSource;

  setUp(() {
    mockLocalDataSource = MockLocalDataSource();
    repository = AuthenticationRepositoryImpl(
      localDataSource: mockLocalDataSource,
    );
  });

  group('getCachedToken', () {
    final tTokenModel =
        TokenModel(accessToken: "abcdef", refreshToken: "123456");

    test('should get token from local storage', () async {
      //arrange
      when(() => mockLocalDataSource.getCachedToken())
          .thenAnswer((invocation) async => tTokenModel);
      //act
      final result = await repository.getCachedToken();
      //assert
      verify(() => mockLocalDataSource.getCachedToken()).called(1);

      expect(result, equals(Right(tTokenModel)));
    });

    test('should return [ServerFailure] if an error occurs', () async {
      final error = ServerException(
          ServerError(message: "Could not access local storage", code: 401));
      final failure = ServerFailure.fromServerException(error.error);
      // arrange
      when(() => mockLocalDataSource.getCachedToken()).thenThrow(error);
      // act
      final result = await repository.getCachedToken();
      // assert
      verify(() => mockLocalDataSource.getCachedToken());

      expect(result, equals(Left(failure)));
    });
  });
}
