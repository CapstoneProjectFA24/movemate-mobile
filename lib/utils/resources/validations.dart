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

mixin Validations {
  final StringValidator emailRegexValidator = RegexStringValidator(
      r'^[a-zA-Z0-9]+([._]?[a-zA-Z0-9]+)*@[a-zA-Z0-9-]+(\.[a-zA-Z]{2,})+$');

  final StringValidator passwordValidator = RegexStringValidator(
      r'^(?=.*[a-z])(?=.*[A-Z])(?=.*\d)(?=.*[!@#\$%\^&\*()\-_=+\[\]\{\}|;:,.<>?/~]).{8,32}$');

  final StringValidator phoneNumberValidator =
      RegexStringValidator(r'^[0-9]{10,15}$');

  final StringValidator usernameMaxLengthValidator =
      MaxLengthStringValidator(50);

  String emailRegexErrorText(String email) {
    final bool showErrorText = !emailRegexValidator.isValid(email);
    const String errorText = 'Không đúng dạng địa chỉ email';
    return showErrorText ? errorText : '';
  }

  String passwordErrorText(String password) {
    if (!passwordValidator.isValid(password)) {
      if (password.length < 8) {
        return 'Mật khẩu phải có tối thiểu 8 kí tự';
      } else if (password.length > 32) {
        return 'Mật khẩu phải có tối đa 32 kí tự';
      } else {
        return 'Mật khẩu phải bao gồm ít nhất một chữ hoa, một chữ thường, một số, và một ký tự đặc biệt';
      }
    }
    return '';
  }

  String phoneNumberErrorText(String phoneNumber) {
    final bool showErrorText = !phoneNumberValidator.isValid(phoneNumber);
    const String errorText = 'Không đúng định dạng số điện thoại';
    return showErrorText ? errorText : '';
  }

  String requiredFieldErrorText(String input) {
    final bool isEmpty = input.isEmpty;
    const String errorText = '[Bắt buộc]';
    return isEmpty ? errorText : '';
  }

  String usernameMaxLengthErrorText(String username) {
    final bool showErrorText = !usernameMaxLengthValidator.isValid(username);
    const String errorText = 'Tên đăng nhập không được vượt quá 50 kí tự';
    return showErrorText ? errorText : '';
  }
}
