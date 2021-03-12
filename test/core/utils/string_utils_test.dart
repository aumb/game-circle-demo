import 'package:flutter_test/flutter_test.dart';
import 'package:gamecircle/core/utils/string_utils.dart';

void main() {
  late StringUtils stringUtils;

  setUp(() {
    stringUtils = StringUtils();
  });

  group("isNotEmpty", () {
    final tText = "test";
    final tEmptyText = "";
    final tNullText = null;
    final tNullTypedText = "null";

    test('Should return true from a variable containing a value', () {
      //act
      final result = stringUtils.isNotEmpty(tText);
      //assert
      expect(true, equals(result));
    });

    test('Should return false from an empty variable', () {
      //act
      final result = stringUtils.isNotEmpty(tEmptyText);
      //assert
      expect(false, equals(result));
    });

    test('Should return false from a null variable', () {
      //act
      final result = stringUtils.isNotEmpty(tNullText);
      //assert
      expect(false, equals(result));
    });

    test('Should return false from a tText null variable', () {
      //act
      final result = stringUtils.isNotEmpty(tNullTypedText);
      //assert
      expect(false, equals(result));
    });
  });

  group("isEmpty", () {
    final tText = "test";
    final tEmptyText = "";
    final tNullText = null;
    final tNullTypedText = "null";

    test('Should return false from a variable containing a value', () {
      //act
      final result = stringUtils.isEmpty(tText);
      //assert
      expect(false, equals(result));
    });

    test('Should return true from an empty variable', () {
      //act
      final result = stringUtils.isEmpty(tEmptyText);
      //assert
      expect(true, equals(result));
    });

    test('Should return true from a null variable', () {
      //act
      final result = stringUtils.isEmpty(tNullText);
      //assert
      expect(true, equals(result));
    });

    test('Should return true from a text null variable', () {
      //act
      final result = stringUtils.isEmpty(tNullTypedText);
      //assert
      expect(true, equals(result));
    });
  });

  group("validatePassword", () {
    final tInvalidPasswordLength = "123456";
    final tInvalidPasswordAlphaNeumeric = "12345678";
    final tInvalidPasswordNoCapital = "123456ma";
    final tEmptyPassword = "";
    final tCorrectPassword = "123456Ma";

    test('Should return false if password is empty', () {
      final result = stringUtils.validatePassword(tEmptyPassword);
      //assert
      expect(false, equals(result));
    });
    test('Should return false if password is less than 8 chars', () {
      final result = stringUtils.validatePassword(tInvalidPasswordLength);
      //assert
      expect(false, equals(result));
    });

    test('Should return false if password is not alphaneumeric', () {
      final result =
          stringUtils.validatePassword(tInvalidPasswordAlphaNeumeric);
      //assert
      expect(false, equals(result));
    });

    test('Should return false if password does not contain a capital letter',
        () {
      final result = stringUtils.validatePassword(tInvalidPasswordNoCapital);
      //assert
      expect(false, equals(result));
    });

    test(
        'Should return true if password is not empty, is alphaneumeric,  > 8 chars, and has a capital letter',
        () {
      final result = stringUtils.validatePassword(tCorrectPassword);
      //assert
      expect(true, equals(result));
    });
  });

  group("validateEmail", () {
    final tEmptyEmail = "";
    final tWrongEmail = "com.mathiew@mathiew";
    final tCorrectEmail = "mathiew@mathiew.com";

    test('Should return false if email is empty', () {
      final result = stringUtils.validateEmail(tEmptyEmail);
      //assert
      expect(false, equals(result));
    });
    test('Should return false if email does not match regex', () {
      final result = stringUtils.validateEmail(tWrongEmail);
      //assert
      expect(false, equals(result));
    });
    test('Should return true if email is not empty and matches the regex', () {
      final result = stringUtils.validateEmail(tCorrectEmail);
      //assert
      expect(true, equals(result));
    });
  });

  group("validateName", () {
    final tEmptyName = "";
    final tWrongName = "Mathiew";
    final tCorrectName = "Mathiew Abbas";

    test('Should return false if name is empty', () {
      final result = stringUtils.validateName(tEmptyName);
      //assert
      expect(false, equals(result));
    });
    test('Should return false if email does not match regex', () {
      final result = stringUtils.validateName(tWrongName);
      //assert
      expect(false, equals(result));
    });
    test('Should return true if email is not empty and matches the regex', () {
      final result = stringUtils.validateName(tCorrectName);
      //assert
      expect(true, equals(result));
    });
  });
}
