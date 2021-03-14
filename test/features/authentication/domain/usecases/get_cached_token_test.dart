import 'package:dartz/dartz.dart';
import 'package:gamecircle/core/entities/token.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:gamecircle/core/usecases/usecases.dart';
import 'package:gamecircle/features/authentication/domain/repositories/authentication_repository.dart';
import 'package:gamecircle/features/authentication/domain/usecases/get_cached_token.dart';

import 'package:mocktail/mocktail.dart';

class MockLoginRepository extends Mock implements AuthenticationRepository {}

void main() {
  late GetCachedToken usecase;
  late MockLoginRepository mockLoginRepository;

  setUp(() {
    mockLoginRepository = MockLoginRepository();
    usecase = GetCachedToken(mockLoginRepository);
  });

  final token = Token(
    accessToken: "abcedfg",
    refreshToken: '123456',
  );

  test(
    'should get token from local storage',
    () async {
      // arrange
      when(() => mockLoginRepository.getCachedToken())
          .thenAnswer((_) async => Right(token));

      // act
      final result = await usecase(NoParams());

      // assert
      expect(result, Right(token));
      verify(() => mockLoginRepository.getCachedToken());
      verifyNoMoreInteractions(mockLoginRepository);
    },
  );
}
