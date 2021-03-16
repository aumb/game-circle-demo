import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:gamecircle/core/entities/token.dart';
import 'package:gamecircle/core/errors/failure.dart';
import 'package:gamecircle/features/authentication/presentation/bloc/authentication_bloc.dart';
import 'package:gamecircle/features/registration/domain/usecases/post_email_registration.dart';

part 'registration_event.dart';
part 'registration_state.dart';

class RegistrationBloc extends Bloc<RegistrationEvent, RegistrationState> {
  final AuthenticationBloc authenticationBloc;
  final PostEmailRegistration postEmailRegistration;

  RegistrationBloc({
    required this.postEmailRegistration,
    required this.authenticationBloc,
  }) : super(RegistrationInitial());

  @override
  Stream<RegistrationState> mapEventToState(
    RegistrationEvent event,
  ) async* {
    if (event is PostEmailRegistrationEvent) {
      yield Loading();
      final failureOrToken = await postEmailRegistration(
        PostEmailRegistrationParams(
          email: event.email,
          name: event.name,
          password: event.password,
          confirmPassword: event.confirmPassword,
        ),
      );
      yield* _eitherLoadedOrErrorState(failureOrToken);
    }
  }

  Stream<RegistrationState> _eitherLoadedOrErrorState(
    Either<Failure, Token?> failureOrToken,
  ) async* {
    yield failureOrToken.fold(
      (failure) {
        return _handleFailureEvent(failure);
      },
      (token) {
        authenticationBloc.add(GetCachedTokenEvent());
        return Loaded(token: token);
      },
    );
  }

  Error _handleFailureEvent(Failure failure) {
    Error error;
    if (failure is ServerFailure) {
      error = Error(message: failure.message);
    } else {
      error = Error(message: "An error has occured");
    }

    return error;
  }
}
