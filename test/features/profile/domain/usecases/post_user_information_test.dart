import 'package:dartz/dartz.dart';

import 'package:flutter_test/flutter_test.dart';
import 'package:gamecircle/core/entities/user.dart';
import 'package:gamecircle/features/profile/domain/repositories/profile_repository.dart';
import 'package:gamecircle/features/profile/domain/usecases/post_user_information.dart';

import 'package:mocktail/mocktail.dart';

class MockProfileRepository extends Mock implements ProfileRepository {}

void main() {
  late PostUserInformation usecase;
  late MockProfileRepository mockProfileRepository;

  setUp(() {
    mockProfileRepository = MockProfileRepository();
    usecase = PostUserInformation(mockProfileRepository);
  });

  User? user = User(
    id: 0,
    name: "Mathiew Abbas",
    email: "mathiewabbas@gmail.com",
  );

  test(
    'should post user from the repository',
    () async {
      // arrange
      when(
        () => mockProfileRepository.postUserInformation(
          name: any(named: "name"),
          email: any(named: "email"),
          image: any(named: "image"),
        ),
      ).thenAnswer((_) async => Right(user));

      // act
      final result = await usecase(PostUserInformationParams());

      // assert
      expect(result, Right(user));
      verify(() => mockProfileRepository.postUserInformation());
      verifyNoMoreInteractions(mockProfileRepository);
    },
  );
}
