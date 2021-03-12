part of 'login_bloc.dart';

abstract class LoginState extends Equatable {
  const LoginState();

  @override
  List<Object?> get props => [];
}

class Empty extends LoginState {}

class Loading extends LoginState {}

class Loaded extends LoginState {
  final Token? token;

  Loaded({required this.token});

  @override
  List<Object?> get props => [token];
}

class Error extends LoginState {
  final String message;

  Error({required this.message});

  @override
  List<Object?> get props => [message];
}
