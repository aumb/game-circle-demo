import 'package:gamecircle/core/utils/string_utils.dart';
import 'package:rxdart/rxdart.dart';
import 'package:rxdart/subjects.dart';

class LoginController {
  late BehaviorSubject<String?> _email;
  late BehaviorSubject<String?> _password;
  late BehaviorSubject<bool?> _obscurePassword;

  LoginController() {
    _email = BehaviorSubject<String?>.seeded('');
    _password = BehaviorSubject<String?>.seeded('');
    _obscurePassword = BehaviorSubject<bool?>.seeded(true);
  }

  //Stream getters
  Stream<String?> get emailStream => _email.stream;
  Stream<String?> get passwordStream => _password.stream;
  Stream<bool?> get obscurePasswordStream => _obscurePassword.stream;

  //Stream combiners
  Stream<bool> get canSubmitPageStream => Rx.combineLatest3(
        emailStream,
        passwordStream,
        obscurePasswordStream,
        (a, b, c) => canSubmitPage,
      );

  //Combiner values
  bool get canSubmitPage =>
      StringUtils().isNotEmpty(email) && StringUtils().isNotEmpty(password);

  //Value getters
  String? get email => _email.value;
  String? get password => _password.value;
  bool? get obscurePassword => _obscurePassword.value;

  //Value setters
  set email(String? value) {
    if (!_email.isClosed) _email.add(value?.trim());
  }

  set password(String? value) {
    if (!_password.isClosed) _password.add(value?.trim());
  }

  set obscurePassword(bool? value) {
    if (!_obscurePassword.isClosed) _obscurePassword.add(value);
  }

  void dispose() {
    if (!_email.isClosed) _email.close();
    if (!_password.isClosed) _password.close();
    if (!_obscurePassword.isClosed) _obscurePassword.close();
  }
}
