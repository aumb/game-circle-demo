import 'package:dartz/dartz.dart';
import 'package:gamecircle/core/entities/token.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:gamecircle/features/login/domain/repositories/login_repository.dart';
import 'package:gamecircle/features/login/domain/usecases/post_social_login.dart';
import 'package:mocktail/mocktail.dart';

class MockLoginRepository extends Mock implements LoginRepository {}

void main() {
  late PostSocialLogin usecase;
  late MockLoginRepository mockLoginRepository;

  setUp(() {
    mockLoginRepository = MockLoginRepository();
    usecase = PostSocialLogin(mockLoginRepository);
  });

  final tProvider = "google";
  final tToken = "abcedfg";
  final token = Token(
    accessToken: "abcedfg",
    refreshToken: '123456',
  );

  test(
    'should get token for the social credidentials from the repository',
    () async {
      // arrange
      when(() => mockLoginRepository.postSocialLogin(any(), any()))
          .thenAnswer((_) async => Right(token));

      // act
      final result = await usecase(
          PostSocialLoginParams(provider: tProvider, token: tToken));

      // assert
      expect(result, Right(token));
      verify(() => mockLoginRepository.postSocialLogin(tProvider, tToken));
      verifyNoMoreInteractions(mockLoginRepository);
    },
  );
}
