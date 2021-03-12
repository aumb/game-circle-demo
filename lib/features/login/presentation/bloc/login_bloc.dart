import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:gamecircle/core/errors/failure.dart';
import 'package:gamecircle/features/login/domain/entities/token.dart';
import 'package:gamecircle/features/login/domain/usecases/post_email_login.dart';
import 'package:gamecircle/features/login/domain/usecases/post_social_login.dart';

part 'login_event.dart';
part 'login_state.dart';

class LoginBloc extends Bloc<LoginEvent, LoginState> {
  final PostEmailLogin postEmailLogin;
  final PostSocialLogin postSocialLogin;

  LoginBloc({
    required this.postEmailLogin,
    required this.postSocialLogin,
  }) : super(Empty());

  @override
  Stream<LoginState> mapEventToState(
    LoginEvent event,
  ) async* {
    if (event is PostEmailLoginEvent) {
      yield Loading();
      final failureOrToken = await postEmailLogin(
        PostEmailLoginParams(
          email: event.email,
          password: event.password,
        ),
      );
      yield* _eitherLoadedOrErrorState(failureOrToken);
    } else if (event is PostSocialLoginEvent) {
      yield Loading();
      final failureOrToken = await postSocialLogin(
        PostSocialLoginParams(
          provider: event.provider,
          token: event.token,
        ),
      );
      yield* _eitherLoadedOrErrorState(failureOrToken);
    }
  }

  Stream<LoginState> _eitherLoadedOrErrorState(
    Either<Failure, Token?> failureOrTrivia,
  ) async* {
    yield failureOrTrivia.fold(
      (failure) {
        if (failure is ServerFailure) {
          return Error(message: failure.message);
        } else {
          return Error(message: "An error has occured");
        }
      },
      (token) => Loaded(token: token),
    );
  }
}
