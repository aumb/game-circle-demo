import 'package:flutter_test/flutter_test.dart';
import 'package:gamecircle/features/login/presentation/bloc/login_form_bloc.dart';

void main() {
  late LoginFormBloc bloc;

  setUp(() {
    bloc = LoginFormBloc();
  });

  test("Should change email state value when [ChangedEmailEvent] is called",
      () {
    final email = "mathiew95@gmail.com";

    final expected = [LoginFormState(email: email)];

    bloc.add(ChangedEmailEvent(email: email));

    expectLater(bloc, emitsInOrder(expected));
  });

  test(
      "Should change password state value when [ChangedPasswordEvent] is called",
      () {
    final password = "123456";

    final expected = [LoginFormState(password: password)];

    bloc.add(ChangedPasswordEvent(password: password));

    expectLater(bloc, emitsInOrder(expected));
  });

  test(
      "Should change password state value when [ChangedObsecureTextEvent] is called",
      () {
    final obscureText = false;

    final expected = [LoginFormState(obsecureText: obscureText)];

    bloc.add(ChangedObsecureTextEvent(obsecureText: obscureText));

    expectLater(bloc, emitsInOrder(expected));
  });
}
