import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:gamecircle/core/errors/failure.dart';
import 'package:gamecircle/core/usecases/usecases.dart';
import 'package:gamecircle/features/login/domain/entities/token.dart';
import 'package:gamecircle/features/login/domain/usecases/post_email_login.dart';
import 'package:gamecircle/features/login/domain/usecases/post_facebook_login.dart';
import 'package:gamecircle/features/login/domain/usecases/post_google_login.dart';
import 'package:gamecircle/features/login/domain/usecases/post_social_login.dart';
import 'package:google_sign_in/google_sign_in.dart';

part 'login_event.dart';
part 'login_state.dart';

class LoginBloc extends Bloc<LoginEvent, LoginState> {
  final PostEmailLogin postEmailLogin;
  final PostSocialLogin postSocialLogin;
  final PostGoogleLogin postGoogleLogin;
  final PostFacebookLogin postFacebookLogin;

  LoginBloc({
    required this.postEmailLogin,
    required this.postSocialLogin,
    required this.postGoogleLogin,
    required this.postFacebookLogin,
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
    } else if (event is GoogleLoginEvent) {
      yield Empty();
      final googleFailureOrAccount = await postGoogleLogin(NoParams());
      yield* _handleGoogleLoginState(googleFailureOrAccount);
    } else if (event is FacebookLoginEvent) {
      yield Empty();
      final facebookFailureOrAccount = await postFacebookLogin(NoParams());
      yield* _handleFacebookLoginState(facebookFailureOrAccount);
    }
  }

  Stream<LoginState> _eitherLoadedOrErrorState(
    Either<Failure, Token?> failureOrToken,
  ) async* {
    yield failureOrToken.fold(
      (failure) {
        return _handleFailureEvent(failure);
      },
      (token) {
        return Loaded(token: token);
      },
    );
  }

  Stream<LoginState> _handleGoogleLoginState(
    Either<Failure, GoogleSignInAuthentication?> failureOrToken,
  ) async* {
    yield failureOrToken.fold((failure) {
      return _handleFailureEvent(failure);
    }, (token) {
      this.add(
        PostSocialLoginEvent(provider: 'google', token: token?.accessToken),
      );
      return Empty();
    });
  }

  Stream<LoginState> _handleFacebookLoginState(
    Either<Failure, AccessToken?> failureOrToken,
  ) async* {
    yield failureOrToken.fold((failure) {
      return _handleFailureEvent(failure);
    }, (accessToken) {
      this.add(
        PostSocialLoginEvent(provider: 'facebook', token: accessToken?.token),
      );
      return Empty();
    });
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
