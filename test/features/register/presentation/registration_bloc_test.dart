import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:gamecircle/core/entities/token.dart';
import 'package:gamecircle/core/errors/failure.dart';
import 'package:gamecircle/core/usecases/usecases.dart';
import 'package:gamecircle/features/authentication/domain/usecases/get_cached_token.dart';
import 'package:gamecircle/features/authentication/presentation/bloc/authentication_bloc.dart';
import 'package:gamecircle/features/registration/domain/usecases/post_email_registration.dart';
import 'package:gamecircle/features/registration/presentation/bloc/registration_bloc.dart';
import 'package:mocktail/mocktail.dart';

class MockPostEmailRegistration extends Mock implements PostEmailRegistration {}

class MockGetCachedToken extends Mock implements GetCachedToken {}

void main() {
  late RegistrationBloc bloc;
  //ignore: close_sinks
  late AuthenticationBloc authenticationBloc;
  late MockGetCachedToken mockGetCachedToken;
  late MockPostEmailRegistration mockPostEmailRegistration;

  setUp(() {
    mockGetCachedToken = MockGetCachedToken();
    mockPostEmailRegistration = MockPostEmailRegistration();
    authenticationBloc = AuthenticationBloc(getCachedToken: mockGetCachedToken);
    bloc = RegistrationBloc(
        authenticationBloc: authenticationBloc,
        postEmailRegistration: mockPostEmailRegistration);

    registerFallbackValue<PostEmailRegistrationParams>(
      PostEmailRegistrationParams(
        email: "mathiew95@gmail.com",
        name: "Mathiew Abbas",
        password: "123456",
        confirmPassword: "123456",
      ),
    );

    registerFallbackValue<NoParams>(NoParams());
  });

  void setUpAuthenticationBlocMock() {
    final tToken = Token(accessToken: "abcdef", refreshToken: '123456');
    when(() => mockGetCachedToken(any()))
        .thenAnswer((invocation) async => Right(tToken));
  }

  void addEmailRegistrationEventToBloc({
    String? tEmail,
    String? tName,
    String? tPassword,
    String? tConfirmPassword,
  }) {
    bloc.add(PostEmailRegistrationEvent(
      email: tEmail,
      name: tName,
      password: tPassword,
      confirmPassword: tConfirmPassword,
    ));
  }

  group('postEmailRegistration', () {
    final tEmail = "mathiew95@gmail.com";
    final tName = "Mathiew Abbas";
    final tPassword = "123456";
    final tConfirmPassword = "123456";
    final tToken = Token(accessToken: "abcdef", refreshToken: '123456');

    test(
      'should get data from the concrete use case',
      () async {
        // arrange
        when(() => mockPostEmailRegistration(any()))
            .thenAnswer((_) async => Right(tToken));
        setUpAuthenticationBlocMock();
        // act
        addEmailRegistrationEventToBloc(
          tEmail: tEmail,
          tName: tName,
          tPassword: tPassword,
          tConfirmPassword: tConfirmPassword,
        );

        await untilCalled(() => mockPostEmailRegistration(any()));
        // assert
        verify(
          () => mockPostEmailRegistration(
            PostEmailRegistrationParams(
              email: tEmail,
              name: tName,
              password: tPassword,
              confirmPassword: tConfirmPassword,
            ),
          ),
        );
      },
    );

    test(
      'should emit [Loading, Loaded] when data is gotten successfully',
      () async {
        // arrange
        when(() => mockPostEmailRegistration(any()))
            .thenAnswer((_) async => Right(tToken));

        setUpAuthenticationBlocMock();
        // assert
        final expected = [
          Loading(),
          Loaded(token: tToken),
        ];
        expectLater(bloc, emitsInOrder(expected));
        // act
        addEmailRegistrationEventToBloc(
          tEmail: tEmail,
          tName: tName,
          tPassword: tPassword,
          tConfirmPassword: tConfirmPassword,
        );
      },
    );

    test(
      'should emit [Loading, Error] when getting data fails',
      () async {
        // arrange
        final failure = ServerFailure(code: 500, message: "unexpected_error");
        when(() => mockPostEmailRegistration(any())).thenAnswer(
          (_) async => Left(
            failure,
          ),
        );
        // assert later
        final expected = [
          Loading(),
          Error(
            message: failure.message,
          ),
        ];
        expectLater(bloc, emitsInOrder(expected));
        // act
        addEmailRegistrationEventToBloc(
          tEmail: tEmail,
          tName: tName,
          tPassword: tPassword,
          tConfirmPassword: tConfirmPassword,
        );
      },
    );
  });
}
