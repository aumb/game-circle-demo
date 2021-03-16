part of 'registration_form_bloc.dart';

class RegistrationFormState extends Equatable {
  final String? email;
  final String? name;
  final String? password;
  final String? confirmPassword;
  final bool? obsecureText;

  const RegistrationFormState({
    this.email,
    this.name,
    this.password,
    this.confirmPassword,
    this.obsecureText = true,
  });

  bool get canSubmitForm =>
      StringUtils().isNotEmpty(email) &&
      StringUtils().isNotEmpty(name) &&
      StringUtils().isNotEmpty(password) &&
      StringUtils().isNotEmpty(confirmPassword);

  bool get isEmailValid => StringUtils().validateEmail(email ?? '');

  bool get isPasswordValid => StringUtils().validatePassword(password ?? '');

  bool get isConfirmPasswordValid => StringUtils()
      .validateConfirmPassword(password ?? '', confirmPassword ?? '');

  bool get isNameValid => StringUtils().validateName(name ?? '');

  RegistrationFormState copyWith({
    String? email,
    String? name,
    String? password,
    String? confirmPassword,
    bool? obsecureText,
  }) {
    return RegistrationFormState(
      email: email ?? this.email,
      name: name ?? this.name,
      password: password ?? this.password,
      confirmPassword: confirmPassword ?? this.confirmPassword,
      obsecureText: obsecureText ?? this.obsecureText,
    );
  }

  @override
  List<Object?> get props => [
        email,
        name,
        password,
        confirmPassword,
        obsecureText,
      ];
}

class RegistrationFormInitial extends RegistrationFormState {}
