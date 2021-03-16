import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:gamecircle/core/models/token_model.dart';
import 'package:gamecircle/core/entities/token.dart';
import 'package:gamecircle/features/registration/data/datasources/registration_local_data_source.dart';
import 'package:gamecircle/features/registration/data/datasources/registration_remote_data_source.dart';
import 'package:gamecircle/features/registration/data/repositories/registration_repository_impl.dart';
import 'package:mocktail/mocktail.dart';

class MockRemoteDataSource extends Mock
    implements RegistrationRemoteDataSource {}

class MockLocalDataSource extends Mock implements RegistrationLocalDataSource {}

void main() {
  late RegistrationRepositoryImpl repository;
  late MockRemoteDataSource mockRemoteDataSource;
  late MockLocalDataSource mockLocalDataSource;

  setUp(() {
    mockLocalDataSource = MockLocalDataSource();
    mockRemoteDataSource = MockRemoteDataSource();
    repository = RegistrationRepositoryImpl(
      remoteDataSource: mockRemoteDataSource,
      localDataSource: mockLocalDataSource,
    );
  });

  group("postEmailLogin", () {
    final tEmail = "mathiew95@gmail.com";
    final tName = "Mathiew Abbas";
    final tConfirmPassword = "123456";
    final tPassword = "123456";

    final tTokenModel =
        TokenModel(accessToken: "abcdef", refreshToken: "123456");
    final Token tToken = tTokenModel;

    test(
      'should return remote data when the call to remote data source is successful',
      () async {
        // arrange
        when(() => mockRemoteDataSource.postEmailRegistration(
              email: any(named: "email"),
              name: any(named: "name"),
              password: any(named: "password"),
              confirmPassword: any(named: "confirmPassword"),
            )).thenAnswer((_) async => tTokenModel);
        when(() => mockLocalDataSource.cacheToken(any()))
            .thenAnswer((_) async => true);
        // act
        final result = await repository.postEmailRegistration(
          email: tEmail,
          name: tName,
          password: tPassword,
          confirmPassword: tConfirmPassword,
        );
        // assert
        verify(() => mockRemoteDataSource.postEmailRegistration(
              email: tEmail,
              name: tName,
              password: tPassword,
              confirmPassword: tConfirmPassword,
            )).called(1);

        expect(result, equals(Right(tToken)));
      },
    );

    test(
      'should cache the data locally when the call to remote data source is successful',
      () async {
        // arrange
        when(() => mockRemoteDataSource.postEmailRegistration(
              email: any(named: "email"),
              name: any(named: "name"),
              password: any(named: "password"),
              confirmPassword: any(named: "confirmPassword"),
            )).thenAnswer((_) async => tTokenModel);

        when(() => mockLocalDataSource.cacheToken(any()))
            .thenAnswer((_) async => true);
        // act
        await repository.postEmailRegistration(
          email: tEmail,
          name: tName,
          password: tPassword,
          confirmPassword: tConfirmPassword,
        );
        // assert
        verify(() => mockRemoteDataSource.postEmailRegistration(
              email: tEmail,
              name: tName,
              password: tPassword,
              confirmPassword: tConfirmPassword,
            )).called(1);
        verify(() => mockLocalDataSource.cacheToken(tTokenModel)).called(1);
      },
    );
  });
}
