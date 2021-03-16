part of 'registration_bloc.dart';

abstract class RegistrationState extends Equatable {
  const RegistrationState();

  @override
  List<Object?> get props => [];
}

class RegistrationInitial extends RegistrationState {}

class Empty extends RegistrationState {}

class Loading extends RegistrationState {}

class Error extends RegistrationState {
  final String? message;

  Error({required this.message});

  @override
  List<Object?> get props => [message];
}

class Loaded extends RegistrationState {
  final Token? token;

  Loaded({required this.token});

  @override
  List<Object?> get props => [token];
}
