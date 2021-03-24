import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:gamecircle/core/usecases/usecases.dart';
import 'package:gamecircle/features/home/domain/repositories/user_repository.dart';
import 'package:gamecircle/features/home/domain/usecases/get_current_user_location.dart';
import 'package:geolocator/geolocator.dart';
import 'package:mocktail/mocktail.dart';

class MockUserRepository extends Mock implements UserRepository {}

void main() {
  late GetCurrentUserLocation usecase;
  late MockUserRepository mockUserRepository;

  setUp(() {
    mockUserRepository = MockUserRepository();
    usecase = GetCurrentUserLocation(mockUserRepository);
  });

  final tPosition = Position(
    longitude: 123,
    latitude: 123,
    altitude: 3,
    speed: 1,
    accuracy: 1,
    heading: 1,
    timestamp: DateTime.now(),
    speedAccuracy: 1,
  );

  test('should get current logged in user information', () async {
    //arrange
    when(() => mockUserRepository.getCurrentUserLocation())
        .thenAnswer((invocation) async => Right(tPosition));
    //act
    final result = await usecase(NoParams());

    expect(result, equals(Right(tPosition)));
    verify(() => mockUserRepository.getCurrentUserLocation());
    verifyNoMoreInteractions(mockUserRepository);
  });
}
