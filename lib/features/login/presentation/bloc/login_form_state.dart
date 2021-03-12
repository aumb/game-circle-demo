part of 'login_form_bloc.dart';

class LoginFormState extends Equatable {
  final String? email;
  final String? password;
  final bool? obsecureText;

  const LoginFormState({
    this.email,
    this.password,
    this.obsecureText = true,
  });

  bool get canSubmitForm =>
      StringUtils().isNotEmpty(email) && StringUtils().isNotEmpty(password);

  LoginFormState copyWith({
    String? email,
    String? password,
    bool? obsecureText,
  }) {
    return LoginFormState(
      email: email ?? this.email,
      password: password ?? this.password,
      obsecureText: obsecureText ?? this.obsecureText,
    );
  }

  @override
  List<Object?> get props => [
        email,
        password,
        obsecureText,
      ];
}

class EmptyLoginFormState extends LoginFormState {}
