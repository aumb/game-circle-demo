import 'package:flutter_test/flutter_test.dart';
import 'package:gamecircle/features/registration/presentation/bloc/registration_form_bloc.dart';

void main() {
  late RegistrationFormBloc bloc;

  setUp(() {
    bloc = RegistrationFormBloc();
  });

  test("Should change email state value when [ChangedEmailEvent] is called",
      () {
    final email = "mathiew95@gmail.com";

    final expected = [RegistrationFormState(email: email)];

    bloc.add(ChangedEmailEvent(email: email));

    expectLater(bloc.stream, emitsInOrder(expected));
  });

  test("Should change name state value when [ChangedNameEvent] is called", () {
    final name = "Mathiew Abbas";

    final expected = [RegistrationFormState(name: name)];

    bloc.add(ChangedNameEvent(name: name));

    expectLater(bloc.stream, emitsInOrder(expected));
  });

  test(
      "Should change password state value when [ChangedPasswordEvent] is called",
      () {
    final password = "123456";

    final expected = [RegistrationFormState(password: password)];

    bloc.add(ChangedPasswordEvent(password: password));

    expectLater(bloc.stream, emitsInOrder(expected));
  });

  test(
      "Should change confirm password state value when [ChangedConfirmPasswordEvent] is called",
      () {
    final confirmPassword = "123456";

    final expected = [RegistrationFormState(confirmPassword: confirmPassword)];

    bloc.add(ChangedConfirmPasswordEvent(confirmPassword: confirmPassword));

    expectLater(bloc.stream, emitsInOrder(expected));
  });

  test(
      "Should change password state value when [ChangedObsecureTextEvent] is called",
      () {
    final obscureText = false;

    final expected = [RegistrationFormState(obsecureText: obscureText)];

    bloc.add(ChangedObsecureTextEvent(obsecureText: obscureText));

    expectLater(bloc.stream, emitsInOrder(expected));
  });
}
