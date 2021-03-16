import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:gamecircle/core/utils/string_utils.dart';

part 'registration_form_event.dart';
part 'registration_form_state.dart';

class RegistrationFormBloc
    extends Bloc<RegistrationFormEvent, RegistrationFormState> {
  RegistrationFormBloc() : super(RegistrationFormInitial());

  @override
  Stream<RegistrationFormState> mapEventToState(
    RegistrationFormEvent event,
  ) async* {
    if (event is ChangedEmailEvent) {
      yield state.copyWith(email: event.email);
    } else if (event is ChangedNameEvent) {
      yield state.copyWith(name: event.name);
    } else if (event is ChangedPasswordEvent) {
      yield state.copyWith(password: event.password);
    } else if (event is ChangedConfirmPasswordEvent) {
      yield state.copyWith(confirmPassword: event.confirmPassword);
    } else if (event is ChangedObsecureTextEvent) {
      yield state.copyWith(obsecureText: event.obsecureText);
    }
  }
}
