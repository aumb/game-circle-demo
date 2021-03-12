part of 'login_form_bloc.dart';

abstract class LoginFormEvent extends Equatable {
  const LoginFormEvent();

  @override
  List<Object?> get props => [];
}

class ChangedEmailEvent extends LoginFormEvent {
  final String? email;

  ChangedEmailEvent({
    required this.email,
  });

  @override
  List<Object?> get props => [email];
}

class ChangedPasswordEvent extends LoginFormEvent {
  final String? password;

  ChangedPasswordEvent({
    required this.password,
  });

  @override
  List<Object?> get props => [password];
}

class ChangedObsecureTextEvent extends LoginFormEvent {
  final bool? obsecureText;

  ChangedObsecureTextEvent({
    required this.obsecureText,
  });

  @override
  List<Object?> get props => [obsecureText];
}
