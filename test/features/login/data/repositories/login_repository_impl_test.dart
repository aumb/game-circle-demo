import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:gamecircle/features/login/data/datasources/login_local_data_source.dart';
import 'package:gamecircle/features/login/data/datasources/login_remote_data_source.dart';
import 'package:gamecircle/core/models/token_model.dart';
import 'package:gamecircle/features/login/data/repositories/login_repository_impl.dart';
import 'package:gamecircle/core/entities/token.dart';
import 'package:mocktail/mocktail.dart';

class MockRemoteDataSource extends Mock implements LoginRemoteDataSource {}

class MockLocalDataSource extends Mock implements LoginLocalDataSource {}

void main() {
  late LoginRespositoryImpl repository;
  late MockRemoteDataSource mockRemoteDataSource;
  late MockLocalDataSource mockLocalDataSource;

  setUp(() {
    mockLocalDataSource = MockLocalDataSource();
    mockRemoteDataSource = MockRemoteDataSource();
    repository = LoginRespositoryImpl(
      remoteDataSource: mockRemoteDataSource,
      localDataSource: mockLocalDataSource,
    );
  });

  group("postEmailLogin", () {
    final tEmail = "mathiew95@gmail.com";
    final tPassword = "123456";
    final tTokenModel =
        TokenModel(accessToken: "abcdef", refreshToken: "123456");
    final Token tToken = tTokenModel;

    test(
      'should return remote data when the call to remote data source is successful',
      () async {
        // arrange
        when(() => mockRemoteDataSource.postEmailLogin(any(), any()))
            .thenAnswer((_) async => tTokenModel);
        when(() => mockLocalDataSource.cacheToken(any()))
            .thenAnswer((_) async => true);
        // act
        final result = await repository.postEmailLogin(tEmail, tPassword);
        // assert
        verify(() => mockRemoteDataSource.postEmailLogin(tEmail, tPassword))
            .called(1);

        expect(result, equals(Right(tToken)));
      },
    );

    test(
      'should cache the data locally when the call to remote data source is successful',
      () async {
        // arrange
        when(() => mockRemoteDataSource.postEmailLogin(any(), any()))
            .thenAnswer((_) async => tTokenModel);

        when(() => mockLocalDataSource.cacheToken(any()))
            .thenAnswer((_) async => true);
        // act
        await repository.postEmailLogin(tEmail, tPassword);
        // assert
        verify(() => mockRemoteDataSource.postEmailLogin(tEmail, tPassword))
            .called(1);
        verify(() => mockLocalDataSource.cacheToken(tTokenModel)).called(1);
      },
    );
  });

  group("postSocialLogin", () {
    final tProvider = "facebook";
    final tSocialToken = "123456";
    final tTokenModel =
        TokenModel(accessToken: "abcdef", refreshToken: "123456");
    final Token tToken = tTokenModel;

    test(
      'should return remote data when the call to remote data source is successful',
      () async {
        // arrange
        when(() => mockRemoteDataSource.postSocialLogin(any(), any()))
            .thenAnswer((_) async => tTokenModel);
        when(() => mockLocalDataSource.cacheToken(any()))
            .thenAnswer((_) async => true);
        // act
        final result =
            await repository.postSocialLogin(tProvider, tSocialToken);
        // assert
        verify(() =>
                mockRemoteDataSource.postSocialLogin(tProvider, tSocialToken))
            .called(1);

        expect(result, equals(Right(tToken)));
      },
    );

    test(
      'should cache the data locally when the call to remote data source is successful',
      () async {
        // arrange
        when(() => mockRemoteDataSource.postSocialLogin(any(), any()))
            .thenAnswer((_) async => tTokenModel);

        when(() => mockLocalDataSource.cacheToken(any()))
            .thenAnswer((_) async => true);
        // act
        await repository.postSocialLogin(tProvider, tSocialToken);
        // assert
        verify(() =>
                mockRemoteDataSource.postSocialLogin(tProvider, tSocialToken))
            .called(1);
        verify(() => mockLocalDataSource.cacheToken(tTokenModel)).called(1);
      },
    );
  });
}
