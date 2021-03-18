import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:gamecircle/core/entities/user.dart';
import 'package:gamecircle/features/home/domain/repositories/user_repository.dart';
import 'package:gamecircle/features/home/domain/usecases/get_user_info.dart';
import 'package:mocktail/mocktail.dart';

class MockUserRepository extends Mock implements UserRepository {}

void main() {
  late GetUserInfo usecase;
  late MockUserRepository mockUserRepository;

  setUp(() {
    mockUserRepository = MockUserRepository();
    usecase = GetUserInfo(mockUserRepository);
  });

  final id = 0;
  final tUser = User(
    id: 0,
    name: "Mathiew Abbas",
    imageUrl: "url",
    email: "email",
  );

  test("shoudl get user information for id provided", () async {
    //arrange
    when(() => mockUserRepository.getUserInfo(any()))
        .thenAnswer((invocation) async => Right(tUser));
    //act
    final result = await usecase(GetUserInfoParams(id: id));
    //assert
    expect(result, equals(Right(tUser)));
    verify(() => mockUserRepository.getUserInfo(id));
    verifyNoMoreInteractions(mockUserRepository);
  });
}
