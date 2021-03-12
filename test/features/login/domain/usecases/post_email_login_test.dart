import 'package:dartz/dartz.dart';
import 'package:gamecircle/features/login/domain/entities/token.dart';
import 'package:gamecircle/features/login/domain/usecases/post_email_login.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:gamecircle/features/login/domain/repositories/login_repository.dart';
import 'package:mocktail/mocktail.dart';

class MockLoginRepository extends Mock implements LoginRepository {}

void main() {
  late PostEmailLogin usecase;
  late MockLoginRepository mockLoginRepository;

  setUp(() {
    mockLoginRepository = MockLoginRepository();
    usecase = PostEmailLogin(mockLoginRepository);
  });

  final tEmail = "mathiew95@gmail.com";
  final tPassword = "123456";
  final token = Token(
    accessToken: "abcedfg",
    refreshToken: '123456',
  );

  test(
    'should get token for the email credidentials from the repository',
    () async {
      // arrange
      when(() => mockLoginRepository.postEmailLogin(any(), any()))
          .thenAnswer((_) async => Right(token));

      // act
      final result = await usecase(
          PostEmailLoginParams(email: tEmail, password: tPassword));

      // assert
      expect(result, Right(token));
      verify(() => mockLoginRepository.postEmailLogin(tEmail, tPassword));
      verifyNoMoreInteractions(mockLoginRepository);
    },
  );
}
