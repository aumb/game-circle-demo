part of 'authentication_bloc.dart';

abstract class AuthenticationState extends Equatable {
  const AuthenticationState();

  @override
  List<Object?> get props => [];
}

class AuthenticationInitial extends AuthenticationState {}

class AuthenticatedState extends AuthenticationState {}

class UnauthenticatedState extends AuthenticationState {}

class UnknownAuthenticationState extends AuthenticationState {}

class AuthenticationError extends AuthenticationState {
  final String? message;

  AuthenticationError({required this.message});

  @override
  List<Object?> get props => [message];
}
