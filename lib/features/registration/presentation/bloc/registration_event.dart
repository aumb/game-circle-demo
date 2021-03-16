part of 'registration_bloc.dart';

abstract class RegistrationEvent extends Equatable {
  const RegistrationEvent();

  @override
  List<Object?> get props => [];
}

class PostEmailRegistrationEvent extends RegistrationEvent {
  final String? email;
  final String? password;
  final String? name;
  final String? confirmPassword;

  PostEmailRegistrationEvent({
    required this.email,
    required this.name,
    required this.password,
    required this.confirmPassword,
  });

  @override
  List<Object?> get props => [email, password];
}
