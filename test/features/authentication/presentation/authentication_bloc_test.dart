import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:gamecircle/core/entities/token.dart';
import 'package:gamecircle/core/errors/failure.dart';
import 'package:gamecircle/core/usecases/usecases.dart';
import 'package:gamecircle/features/authentication/domain/usecases/get_cached_token.dart';
import 'package:gamecircle/features/authentication/presentation/bloc/authentication_bloc.dart';
import 'package:mocktail/mocktail.dart';

class MockGetCachedToken extends Mock implements GetCachedToken {}

void main() {
  late AuthenticationBloc authenticationBloc;
  late MockGetCachedToken mockGetCachedToken;

  setUp(() {
    registerFallbackValue<NoParams>(NoParams());
    mockGetCachedToken = MockGetCachedToken();
    authenticationBloc = AuthenticationBloc(
      getCachedToken: mockGetCachedToken,
    );
  });

  group('getCachedToken', () {
    final tToken = Token(accessToken: "abcdef", refreshToken: '123456');

    test(
      'should get data from the local use case',
      () async {
        // arrange
        // setUpMockInputConverterSuccess();
        when(() => mockGetCachedToken(any()))
            .thenAnswer((_) async => Right(tToken));
        // act
        authenticationBloc.add(GetCachedTokenEvent());
        await untilCalled(() => mockGetCachedToken(any()));
        // assert
        verify(
          () => mockGetCachedToken(
            NoParams(),
          ),
        );
      },
    );

    test(
      'should emit [AuthenticatedState] when data is gotten successfully',
      () async {
        // arrange
        // setUpMockInputConverterSuccess();
        when(() => mockGetCachedToken(any()))
            .thenAnswer((_) async => Right(tToken));
        // assert later
        final expected = [
          AuthenticatedState(),
        ];
        expectLater(authenticationBloc.stream, emitsInOrder(expected));
        // act
        authenticationBloc.add(GetCachedTokenEvent());
      },
    );

    test(
      'should emit [UnauthenticatedState], [Error] when getting data fails',
      () async {
        // arrange
        final failure = ServerFailure(code: 500, message: "unexpected error");
        when(() => mockGetCachedToken(any())).thenAnswer(
          (_) async => Left(
            failure,
          ),
        );
        // assert later
        final expected = [
          // Empty(),
          // UnauthenticatedState(),
          AuthenticationError(
            message: failure.message,
            code: failure.code,
          ),
        ];
        expectLater(authenticationBloc.stream, emitsInOrder(expected));
        // act
        authenticationBloc.add(GetCachedTokenEvent());
      },
    );
  });
}
