import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:gamecircle/core/errors/failure.dart';
import 'package:gamecircle/features/login/domain/entities/token.dart';
import 'package:gamecircle/features/login/domain/usecases/post_email_login.dart';
import 'package:gamecircle/features/login/domain/usecases/post_social_login.dart';
import 'package:gamecircle/features/login/presentation/bloc/login_bloc.dart';
import 'package:mocktail/mocktail.dart';

class MockPostEmailLogin extends Mock implements PostEmailLogin {}

class MockPostSocialLogin extends Mock implements PostSocialLogin {}

void main() {
  late LoginBloc bloc;
  late MockPostEmailLogin mockPostEmailLogin;
  late MockPostSocialLogin mockPostSocialLogin;

  setUpAll(() {
    registerFallbackValue<PostEmailLoginParams>(
      PostEmailLoginParams(
        email: "mathiew95@gmail.com",
        password: "123456",
      ),
    );

    registerFallbackValue<PostSocialLoginParams>(
      PostSocialLoginParams(
        provider: "facebook",
        token: "123456",
      ),
    );

    mockPostEmailLogin = MockPostEmailLogin();
    mockPostSocialLogin = MockPostSocialLogin();

    bloc = LoginBloc(
      postEmailLogin: mockPostEmailLogin,
      postSocialLogin: mockPostSocialLogin,
    );
  });

  // test('initialState should be Empty', () {
  //   // assert
  //   expect(bloc.initialState, equals(Empty()));
  // });

  group('postEmailLogin', () {
    final tEmail = "mathiew95@gmail.com";
    final tPassword = "123456";
    final tToken = Token(accessToken: "abcdef", refreshToken: '123456');

    // void setUpMockInputConverterSuccess() =>
    //     when(mockInputConverter.stringToUnsignedInteger(any))
    //         .thenReturn(Right(tNumberParsed));

    // test(
    //   'should emit [Error] when the input is invalid',
    //   () async {
    //     // arrange
    //     when(mockInputConverter.stringToUnsignedInteger(any))
    //         .thenReturn(Left(InvalidInputFailure()));
    //     // assert later
    //     final expected = [
    //       Empty(),
    //       Error(message: INVALID_INPUT_FAILURE_MESSAGE),
    //     ];
    //     expectLater(bloc, emitsInOrder(expected));
    //     // act
    //     bloc.add(GetTriviaForConcreteNumber(tNumberString));
    //   },
    // );

    test(
      'should get data from the concrete use case',
      () async {
        // arrange
        // setUpMockInputConverterSuccess();
        when(() => mockPostEmailLogin(any()))
            .thenAnswer((_) async => Right(tToken));
        // act
        bloc.add(PostEmailLoginEvent(email: tEmail, password: tPassword));
        await untilCalled(() => mockPostEmailLogin(any()));
        // assert
        verify(
          () => mockPostEmailLogin(
            PostEmailLoginParams(email: tEmail, password: tPassword),
          ),
        );
      },
    );

    test(
      'should emit [Loading, Loaded] when data is gotten successfully',
      () async {
        // arrange
        // setUpMockInputConverterSuccess();
        when(() => mockPostEmailLogin(any()))
            .thenAnswer((_) async => Right(tToken));
        // assert later
        final expected = [
          // Empty(),
          Loading(),
          Loaded(token: tToken),
        ];
        expectLater(bloc, emitsInOrder(expected));
        // act
        bloc.add(PostEmailLoginEvent(
          email: tEmail,
          password: tPassword,
        ));
      },
    );

    test(
      'should emit [Loading, Error] when getting data fails',
      () async {
        // arrange
        final failure = ServerFailure(code: 500, message: "Unexpected eroor");
        when(() => mockPostEmailLogin(any())).thenAnswer(
          (_) async => Left(
            failure,
          ),
        );
        // assert later
        final expected = [
          // Empty(),
          Loading(),
          Error(
            message: failure.message,
          ),
        ];
        expectLater(bloc, emitsInOrder(expected));
        // act
        bloc.add(PostEmailLoginEvent(
          email: tEmail,
          password: tPassword,
        ));
      },
    );
  });

  group('postSocialLogin', () {
    final tProvider = "facebook";
    final tSocialToken = "123456";
    final tToken = Token(accessToken: "abcdef", refreshToken: '123456');

    // void setUpMockInputConverterSuccess() =>
    //     when(mockInputConverter.stringToUnsignedInteger(any))
    //         .thenReturn(Right(tNumberParsed));

    // test(
    //   'should emit [Error] when the input is invalid',
    //   () async {
    //     // arrange
    //     when(mockInputConverter.stringToUnsignedInteger(any))
    //         .thenReturn(Left(InvalidInputFailure()));
    //     // assert later
    //     final expected = [
    //       Empty(),
    //       Error(message: INVALID_INPUT_FAILURE_MESSAGE),
    //     ];
    //     expectLater(bloc, emitsInOrder(expected));
    //     // act
    //     bloc.add(GetTriviaForConcreteNumber(tNumberString));
    //   },
    // );

    test(
      'should get data from the concrete use case',
      () async {
        // arrange
        // setUpMockInputConverterSuccess();
        when(() => mockPostSocialLogin(any()))
            .thenAnswer((_) async => Right(tToken));
        // act
        bloc.add(
            PostSocialLoginEvent(provider: tProvider, token: tSocialToken));
        await untilCalled(() => mockPostSocialLogin(any()));
        // assert
        verify(
          () => mockPostSocialLogin(
            PostSocialLoginParams(provider: tProvider, token: tSocialToken),
          ),
        );
      },
    );

    test(
      'should emit [Loading, Loaded] when data is gotten successfully',
      () async {
        // arrange
        // setUpMockInputConverterSuccess();
        when(() => mockPostSocialLogin(any()))
            .thenAnswer((_) async => Right(tToken));
        // assert later
        final expected = [
          // Empty(),
          Loading(),
          Loaded(token: tToken),
        ];
        expectLater(bloc, emitsInOrder(expected));
        // act
        bloc.add(PostSocialLoginEvent(
          provider: tProvider,
          token: tSocialToken,
        ));
      },
    );

    test(
      'should emit [Loading, Error] when getting data fails',
      () async {
        final serverFailure =
            ServerFailure(code: 500, message: "unexpected error");
        // arrange
        // setUpMockInputConverterSuccess();
        when(() => mockPostSocialLogin(any()))
            .thenAnswer((_) async => Left(serverFailure));
        // assert later
        final expected = [
          // Empty(),
          Loading(),
          Error(message: serverFailure.message),
        ];
        expectLater(bloc, emitsInOrder(expected));
        // act
        bloc.add(PostSocialLoginEvent(
          provider: tProvider,
          token: tSocialToken,
        ));
      },
    );
  });
}
