import 'package:dartz/dartz.dart';
import 'package:gamecircle/core/entities/token.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:gamecircle/features/registration/domain/repository/registration_repository.dart';
import 'package:gamecircle/features/registration/domain/usecases/post_email_registration.dart';
import 'package:mocktail/mocktail.dart';

class MockRegistrationRepository extends Mock
    implements RegistrationRepository {}

void main() {
  late PostEmailRegistration usecase;
  late MockRegistrationRepository mockRegistrationRepository;

  setUp(() {
    mockRegistrationRepository = MockRegistrationRepository();
    usecase = PostEmailRegistration(mockRegistrationRepository);
  });

  final tEmail = "mathiew95@gmail.com";
  final tName = "Mathiew Abbas";
  final tPassword = "123456";
  final tConfirmPassword = "123456";
  final token = Token(
    accessToken: "abcedfg",
    refreshToken: '123456',
  );

  test(
    'should get token for the email credidentials from the repository',
    () async {
      // arrange
      when(
        () => mockRegistrationRepository.postEmailRegistration(
          email: any(named: "email"),
          name: any(named: "name"),
          password: any(named: "password"),
          confirmPassword: any(named: "confirmPassword"),
        ),
      ).thenAnswer((_) async => Right(token));

      // act
      final result = await usecase(PostEmailRegistrationParams(
        email: tEmail,
        name: tName,
        password: tPassword,
        confirmPassword: tConfirmPassword,
      ));

      // assert
      expect(result, Right(token));
      verify(() => mockRegistrationRepository.postEmailRegistration(
            email: tEmail,
            name: tName,
            password: tPassword,
            confirmPassword: tConfirmPassword,
          ));
      verifyNoMoreInteractions(mockRegistrationRepository);
    },
  );
}
