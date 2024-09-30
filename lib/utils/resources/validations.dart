import 'string_validators.dart';

class RegexStringValidator implements StringValidator {
  final String regex;

  RegexStringValidator(this.regex);

  @override
  bool isValid(String value) {
    final RegExp regExp = RegExp(regex);
    return regExp.hasMatch(value);
  }
}

class ValidationRule {
  final bool Function() isValid;
  final String errorMessage;

  ValidationRule(this.isValid, this.errorMessage);
}

class ErrorMsg {
  static const String empty = "Mục này không được bỏ trống";
  static const String invalidEmail = "Không đúng dạng địa chỉ email";
  static const String emailTooLong = "Email không được quá 100 ký tự";
  static const String passwordTooShort = "Mật khẩu phải có tối thiểu 8 kí tự";
  static const String passwordTooLong = "Mật khẩu phải có tối đa 32 kí tự";
  static const String passwordComplexity =
      "Mật khẩu phải bao gồm ít nhất một chữ hoa, một chữ thường, một số, và một ký tự đặc biệt";
  static const String phoneNumberFormat = "Không đúng định dạng số điện thoại";
  static const String phoneNumberSpaces =
      "Số điện thoại không được chứa dấu cách";
  static const String usernameTooLong =
      "Tên đăng nhập không được vượt quá 50 kí tự";
}



mixin Validations {
  final StringValidator emailRegexValidator = RegexStringValidator(
      r'^[a-zA-Z0-9]+(?:\.[a-zA-Z0-9]+)*@[a-zA-Z0-9]+(?:[a-zA-Z0-9-]*[a-zA-Z0-9])*(?:\.[a-zA-Z]{2,})+$');

  final StringValidator passwordValidator = RegexStringValidator(
      r'^(?=.*[a-z])(?=.*[A-Z])(?=.*\d)(?=.*[!@#\$%\^&\*()\-_=+\[\]\{\}|;:,.<>?/~]).{8,32}$');

  final StringValidator phoneNumberValidator = RegexStringValidator(r'^0[0-9]{9,14}$');

  final StringValidator usernameMaxLengthValidator = MaxLengthStringValidator(50);

  String validateField(String value, List<ValidationRule> rules) {
    for (var rule in rules) {
      if (!rule.isValid()) {
        return rule.errorMessage;
      }
    }
    return '';
  }

  String emailErrorText(String email) {
    return validateField(email, [
      ValidationRule(() => email.isNotEmpty, ErrorMsg.empty),
      ValidationRule(() => emailRegexValidator.isValid(email), ErrorMsg.invalidEmail),
      ValidationRule(() => email.length <= 100, ErrorMsg.emailTooLong),
    ]);
  }

  String passwordErrorText(String password) {
    return validateField(password, [
      ValidationRule(() => password.isNotEmpty, ErrorMsg.empty),
      ValidationRule(() => password.length >= 8, ErrorMsg.passwordTooShort),
      ValidationRule(() => password.length <= 32, ErrorMsg.passwordTooLong),
      ValidationRule(() => passwordValidator.isValid(password), ErrorMsg.passwordComplexity),
    ]);
  }

  String phoneNumberErrorText(String phoneNumber) {
    return validateField(phoneNumber, [
      ValidationRule(() => phoneNumber.isNotEmpty, ErrorMsg.empty),
      ValidationRule(() => !phoneNumber.contains(' '), ErrorMsg.phoneNumberSpaces),
      ValidationRule(() => phoneNumberValidator.isValid(phoneNumber), ErrorMsg.phoneNumberFormat),
    ]);
  }

  String usernameMaxLengthErrorText(String username) {
    return validateField(username, [
      ValidationRule(() => username.isNotEmpty,  ErrorMsg.empty),
      ValidationRule(() => usernameMaxLengthValidator.isValid(username), ErrorMsg.usernameTooLong),
    ]);
  }
}

