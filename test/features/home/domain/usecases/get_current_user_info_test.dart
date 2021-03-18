import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:gamecircle/core/entities/user.dart';
import 'package:gamecircle/core/usecases/usecases.dart';
import 'package:gamecircle/features/home/domain/repositories/user_repository.dart';
import 'package:gamecircle/features/home/domain/usecases/get_current_user_info.dart';
import 'package:mocktail/mocktail.dart';

class MockUserRepository extends Mock implements UserRepository {}

void main() {
  late GetCurrentUserInfo usecase;
  late MockUserRepository mockUserRepository;

  setUp(() {
    mockUserRepository = MockUserRepository();
    usecase = GetCurrentUserInfo(mockUserRepository);
  });

  final tUser = User(
    id: 0,
    name: "Mathiew Abbas",
    imageUrl: "url",
    email: "email",
  );

  test('should get current logged in user information', () async {
    //arrange
    when(() => mockUserRepository.getCurrentUserInfo())
        .thenAnswer((invocation) async => Right(tUser));
    //act
    final result = await usecase(NoParams());

    expect(result, equals(Right(tUser)));
    verify(() => mockUserRepository.getCurrentUserInfo());
    verifyNoMoreInteractions(mockUserRepository);
  });
}
