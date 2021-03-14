import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:gamecircle/core/entities/token.dart';
import 'package:gamecircle/core/errors/failure.dart';
import 'package:gamecircle/core/usecases/usecases.dart';
import 'package:gamecircle/core/utils/string_utils.dart';
import 'package:gamecircle/features/authentication/domain/usecases/get_cached_token.dart';

part 'authentication_event.dart';
part 'authentication_state.dart';

class AuthenticationBloc
    extends Bloc<AuthenticationEvent, AuthenticationState> {
  final GetCachedToken getCachedToken;

  AuthenticationBloc({
    required this.getCachedToken,
  }) : super(AuthenticationInitial());

  @override
  Stream<AuthenticationState> mapEventToState(
    AuthenticationEvent event,
  ) async* {
    if (event is GetCachedTokenEvent) {
      final failureOrToken = await getCachedToken(NoParams());
      yield* _handleAuthenticationState(failureOrToken);
    }
  }

  Stream<AuthenticationState> _handleAuthenticationState(
    Either<Failure, Token?> failureOrToken,
  ) async* {
    yield failureOrToken.fold((failure) {
      return _handleFailureEvent(failure);
    }, (token) {
      if (StringUtils().isNotEmpty(token?.accessToken)) {
        return AuthenticatedState();
      } else {
        return UnauthenticatedState();
      }
    });
  }

  AuthenticationError _handleFailureEvent(Failure failure) {
    AuthenticationError error;
    if (failure is ServerFailure) {
      error = AuthenticationError(message: failure.message);
    } else {
      error = AuthenticationError(message: "An error has occured");
    }

    return error;
  }
}
