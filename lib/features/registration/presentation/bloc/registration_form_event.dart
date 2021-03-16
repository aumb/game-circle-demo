part of 'registration_form_bloc.dart';

abstract class RegistrationFormEvent extends Equatable {
  const RegistrationFormEvent();

  @override
  List<Object?> get props => [];
}

class ChangedEmailEvent extends RegistrationFormEvent {
  final String? email;

  ChangedEmailEvent({
    required this.email,
  });

  @override
  List<Object?> get props => [email];
}

class ChangedNameEvent extends RegistrationFormEvent {
  final String? name;

  ChangedNameEvent({
    required this.name,
  });

  @override
  List<Object?> get props => [name];
}

class ChangedConfirmPasswordEvent extends RegistrationFormEvent {
  final String? confirmPassword;

  ChangedConfirmPasswordEvent({
    required this.confirmPassword,
  });

  @override
  List<Object?> get props => [confirmPassword];
}

class ChangedPasswordEvent extends RegistrationFormEvent {
  final String? password;

  ChangedPasswordEvent({
    required this.password,
  });

  @override
  List<Object?> get props => [password];
}

class ChangedObsecureTextEvent extends RegistrationFormEvent {
  final bool? obsecureText;

  ChangedObsecureTextEvent({
    required this.obsecureText,
  });

  @override
  List<Object?> get props => [obsecureText];
}
