import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:gamecircle/core/utils/string_utils.dart';

part 'login_form_event.dart';
part 'login_form_state.dart';

class LoginFormBloc extends Bloc<LoginFormEvent, LoginFormState> {
  LoginFormBloc() : super(EmptyLoginFormState());

  @override
  Stream<LoginFormState> mapEventToState(
    LoginFormEvent event,
  ) async* {
    if (event is ChangedEmailEvent) {
      yield state.copyWith(email: event.email);
    } else if (event is ChangedPasswordEvent) {
      yield state.copyWith(password: event.password);
    } else if (event is ChangedObsecureTextEvent) {
      yield state.copyWith(obsecureText: event.obsecureText);
    }
  }
}
