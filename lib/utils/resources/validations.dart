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
  // Email validation
  final StringValidator emailRegexValidator = RegexStringValidator(
      r'^[a-zA-Z0-9]+([._]?[a-zA-Z0-9]+)*@[a-zA-Z0-9-]+(\.[a-zA-Z]{2,})+$'); // Regex for email validation

  // Password validation
  final StringValidator passwordMinLengthValidator =
      MinLengthStringValidator(8);
  final StringValidator passwordMaxLengthValidator =
      MaxLengthStringValidator(32);
  final StringValidator passwordSpecialCharacterValidator = RegexStringValidator(
      r'^(?=.*[a-z])(?=.*[A-Z])(?=.*\d)(?=.*[!@#\$%\^&\*()\-_=+\[\]\{\}|;:,.<>?/~]).{8,32}$'); // Regex to check for required password characters

  final StringValidator phoneNumberValidator = RegexStringValidator(
      r'^[0-9]{10,15}$'); // Validating phone numbers with 10-15 digits, no spaces or special chars

  // Username validation: Max 50 characters
  final StringValidator usernameMaxLengthValidator =
      MaxLengthStringValidator(50);

  // Email validation error message
  String emailRegexErrorText(String email) {
    final bool showErrorText = !emailRegexValidator.isValid(email);
    const String errorText = 'Không đúng dạng địa chỉ email';
    return showErrorText ? errorText : '';
  }

  // Password validation error messages
  String passwordMinErrorText(String password) {
    final bool showErrorText = !passwordMinLengthValidator.isValid(password);
    const String errorText = 'Mật khẩu phải có tối thiểu 8 kí tự';
    return showErrorText ? errorText : '';
  }

  String passwordMaxErrorText(String password) {
    final bool showErrorText = !passwordMaxLengthValidator.isValid(password);
    const String errorText = 'Mật khẩu phải có tối đa 32 kí tự';
    return showErrorText ? errorText : '';
  }

  String passwordComplexityErrorText(String password) {
    final bool showErrorText =
        !passwordSpecialCharacterValidator.isValid(password);
    const String errorText =
        'Mật khẩu phải từ 8-32 ký tự, bao gồm ít nhất một chữ hoa, một chữ thường, một số, và một ký tự đặc biệt';
    return showErrorText ? errorText : '';
  }

  // Phone number validation error message
  String phoneNumberErrorText(String phoneNumber) {
    final bool showErrorText = !phoneNumberValidator.isValid(phoneNumber);
    const String errorText = 'Không đúng định dạng số điện thoại';
    return showErrorText ? errorText : '';
  }

  // Check if required fields are empty
  String requiredFieldErrorText(String input) {
    final bool isEmpty = input.isEmpty;
    const String errorText = '[Bắt buộc]';
    return isEmpty ? errorText : '';
  }

  // Username validation error message
  String usernameMaxLengthErrorText(String username) {
    final bool showErrorText = !usernameMaxLengthValidator.isValid(username);
    const String errorText = 'Tên đăng nhập không được vượt quá 50 kí tự';
    return showErrorText ? errorText : '';
  }
}
