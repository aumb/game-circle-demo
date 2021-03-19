import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:gamecircle/core/entities/token.dart';
import 'package:gamecircle/core/entities/user.dart';
import 'package:gamecircle/core/errors/failure.dart';
import 'package:gamecircle/core/usecases/usecases.dart';
import 'package:gamecircle/features/authentication/domain/usecases/get_cached_token.dart';
import 'package:gamecircle/features/authentication/presentation/bloc/authentication_bloc.dart';
import 'package:gamecircle/features/home/domain/usecases/post_logout_user.dart';
import 'package:gamecircle/features/logout/presentation/cubit/logout_cubit.dart';
import 'package:mocktail/mocktail.dart';

class MockPostLogoutUser extends Mock implements PostLogoutUser {}

class MockGetCachedToken extends Mock implements GetCachedToken {}

void main() {
  late LogoutCubit _logoutCubit;
  //ignore: close_sinks
  late AuthenticationBloc authenticationBloc;
  late MockPostLogoutUser mockPostLogoutUser;
  late MockGetCachedToken mockGetCachedToken;

  setUp(() {
    registerFallbackValue<NoParams>(NoParams());
    mockPostLogoutUser = MockPostLogoutUser();
    mockGetCachedToken = MockGetCachedToken();
    authenticationBloc = AuthenticationBloc(getCachedToken: mockGetCachedToken);
    _logoutCubit = LogoutCubit(
      postLogoutUser: mockPostLogoutUser,
      authenticationBloc: authenticationBloc,
    );
  });

  void setUpAuthenticationBlocMock() {
    final tToken = Token(accessToken: "", refreshToken: '');
    when(() => mockGetCachedToken(any()))
        .thenAnswer((invocation) async => Right(tToken));
  }

  group('postLogoutUser', () {
    final tUser = User(name: 'Test');

    test(
      'should get data from the concrete use case',
      () async {
        // arrange
        when(() => mockPostLogoutUser(any()))
            .thenAnswer((_) async => Right(tUser));
        setUpAuthenticationBlocMock();
        // act
        _logoutCubit.logout();
        await untilCalled(() => mockPostLogoutUser(any()));
        // assert
        verify(
          () => mockPostLogoutUser(NoParams()),
        );
      },
    );

    test(
      'should emit [Loading, Loaded] when data is gotten successfully',
      () async {
        // arrange
        when(() => mockPostLogoutUser(any()))
            .thenAnswer((_) async => Right(tUser));
        setUpAuthenticationBlocMock();
        // assert
        final expected = [
          LogoutLoading(),
          LogoutLoaded(),
        ];
        expectLater(_logoutCubit, emitsInOrder(expected));
        // act
        _logoutCubit.logout();
      },
    );

    test(
      'should emit [Loading, Error] when getting data fails',
      () async {
        // arrange
        final failure = ServerFailure(code: 500, message: "unexpected_error");
        when(() => mockPostLogoutUser(any())).thenAnswer(
          (_) async => Left(
            failure,
          ),
        );
        // assert later
        final expected = [
          // Empty(),
          LogoutLoading(),
          LogoutError(
            message: failure.message,
          ),
        ];
        expectLater(_logoutCubit, emitsInOrder(expected));
        // act
        _logoutCubit.logout();
      },
    );
  });
}
