class StringUtils {
  /// Returns [true] if [s] is either null or empty.
  bool isEmpty(String? s) => s == null || s.isEmpty || s == 'null';

  /// Returns [true] if [s] is a not null or empty string.
  bool isNotEmpty(String? s) => s != null && s.isNotEmpty && s != 'null';

  bool validateEmail(String email) {
    if (isEmpty(email)) return false;
    String pattern =
        r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
    RegExp regExp = new RegExp(pattern);
    return regExp.hasMatch(email);
  }

  bool validatePassword(String password) {
    if (isEmpty(password)) return false;
    String pattern = r'^(?=.*\d)(?=.*[a-z])(?=.*[A-Z])';
    RegExp regex = new RegExp(pattern);
    return regex.hasMatch(password) && password.length >= 8;
  }

  bool validateConfirmPassword(String password, String confirmPassword) {
    if (isEmpty(confirmPassword) || isEmpty(password)) return false;
    return confirmPassword == password;
  }

  bool validateName(String name) {
    if (isEmpty(name)) return false;
    String pattern = r"^[a-zA-Z]+ [a-zA-Z]+$";
    RegExp regex = new RegExp(pattern);
    return regex.hasMatch(name);
  }

  String replaceVariable(String? message, String? variable, String? value) {
    if (isEmpty(message)) return '';
    return message!.replaceFirst('{$variable}', value ?? '');
  }
}
