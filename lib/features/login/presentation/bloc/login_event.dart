part of 'login_bloc.dart';

abstract class LoginEvent extends Equatable {
  const LoginEvent();

  @override
  List<Object?> get props => [];
}

class PostEmailLoginEvent extends LoginEvent {
  final String? email;
  final String? password;

  PostEmailLoginEvent({
    required this.email,
    required this.password,
  });

  @override
  List<Object?> get props => [email, password];
}

class PostSocialLoginEvent extends LoginEvent {
  final String? provider;
  final String? token;

  PostSocialLoginEvent({
    required this.provider,
    required this.token,
  });

  @override
  List<Object?> get props => [provider, token];
}

class GoogleLoginEvent extends LoginEvent {}

class FacebookLoginEvent extends LoginEvent {}
