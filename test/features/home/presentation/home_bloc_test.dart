import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:gamecircle/core/entities/user.dart';
import 'package:gamecircle/core/errors/failure.dart';
import 'package:gamecircle/core/managers/session_manager.dart';
import 'package:gamecircle/core/usecases/usecases.dart';
import 'package:gamecircle/features/home/domain/usecases/get_current_user_info.dart';
import 'package:gamecircle/features/home/domain/usecases/get_current_user_location.dart';
import 'package:gamecircle/features/home/presentation/bloc/home_bloc.dart';
import 'package:geolocator/geolocator.dart';
import 'package:mocktail/mocktail.dart';

class MockGetCurrentUserInfo extends Mock implements GetCurrentUserInfo {}

class MockSessionManager extends Mock implements SessionManager {}

class MockGetCurrentUserLocation extends Mock
    implements GetCurrentUserLocation {}

void main() {
  late HomeBloc homeBloc;
  late MockGetCurrentUserInfo mockGetCurrentUserInfo;
  late MockGetCurrentUserLocation mockGetCurrentUserLocation;
  late MockSessionManager mockSessionManager;

  setUp(() {
    registerFallbackValue<NoParams>(NoParams());
    mockGetCurrentUserInfo = MockGetCurrentUserInfo();
    mockGetCurrentUserLocation = MockGetCurrentUserLocation();
    mockSessionManager = MockSessionManager();
    homeBloc = HomeBloc(
      getCurrentUserLocation: mockGetCurrentUserLocation,
      getCurrentUserInfo: mockGetCurrentUserInfo,
      sessionManager: mockSessionManager,
    );
  });

  void setUpUserLocation() {
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
    when(() => mockGetCurrentUserLocation(any()))
        .thenAnswer((_) async => Right(tPosition));
  }

  group('getCachedToken', () {
    final tUser = User(name: "mathiew", email: 'mathiew956@gmail.com', id: 1);

    test(
      'should get data from the local use case',
      () async {
        // arrange
        setUpUserLocation();
        when(() => mockGetCurrentUserInfo(any()))
            .thenAnswer((_) async => Right(tUser));

        // act
        homeBloc.add(GetUserInformationEvent());
        await untilCalled(() => mockGetCurrentUserInfo(any()));
        // assert
        verify(
          () => mockGetCurrentUserInfo(
            NoParams(),
          ),
        );
      },
    );

    test(
      'should emit [HomeLoading, HomeLoaded] when data is gotten successfully',
      () async {
        // arrange
        setUpUserLocation();
        when(() => mockGetCurrentUserInfo(any()))
            .thenAnswer((_) async => Right(tUser));
        // assert later
        final expected = [
          HomeLoading(),
          HomeLoaded(),
        ];
        expectLater(homeBloc, emitsInOrder(expected));
        // act
        homeBloc.add(GetUserInformationEvent());
      },
    );

    test(
      'should emit [HomeLoading, HomeError] when getting data fails',
      () async {
        // arrange
        final failure = ServerFailure(code: 500, message: "unexpected error");
        setUpUserLocation();
        when(() => mockGetCurrentUserInfo(any())).thenAnswer(
          (_) async => Left(
            failure,
          ),
        );
        // assert later
        final expected = [
          HomeLoading(),
          HomeError(
            message: failure.message,
          ),
        ];
        expectLater(homeBloc, emitsInOrder(expected));
        // act
        homeBloc.add(GetUserInformationEvent());
      },
    );
  });
}
