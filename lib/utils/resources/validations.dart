import 'string_validators.dart';

mixin Validations {
  final StringValidator emailRegexValidator = EmailRegexValidator();
  final StringValidator passwordMinLengthValidator =
      MinLengthStringValidator(8);
  final StringValidator passwordMaxLengthValidator =
      MaxLengthStringValidator(50);
  final StringValidator usernamePartnerMaxLengthValidator =
      MaxLengthStringValidator(100);
  final StringValidator passwordBetweenLengthValidator =
      BetweenLengthStringValidator(8, 50);

  String emailRegexErrorText(String email) {
    final bool showErrorText = !emailRegexValidator.isValid(email);
    const String errorText = 'Email có đuôi là @gmail.com';
    return showErrorText ? errorText : '';
  }

  String passwordMinErrorText(String password) {
    final bool showErrorText = !passwordMinLengthValidator.isValid(password);
    const String errorText = 'Mật khẩu có tối thiểu 8 kí tự';
    return showErrorText ? errorText : '';
  }

  String passwordMaxErrorText(String password) {
    final bool showErrorText = !passwordMaxLengthValidator.isValid(password);
    const String errorText = 'Mật khẩu có tối đa 50 kí tự';
    return showErrorText ? errorText : '';
  }

  String passwordBetweenLengthErrorText(String password) {
    final bool showErrorText =
        !passwordBetweenLengthValidator.isValid(password);
    const String errorText = 'Mật khẩu có tối thiểu 8 kí tự và tối đa 50 kí tự';
    return showErrorText ? errorText : '';
  }

  String usernamePartnerMaxErrorText(String username) {
    final bool showErrorText =
        !usernamePartnerMaxLengthValidator.isValid(username);
    const String errorText = 'Tài khoản có tối đa 100 kí tự';
    return showErrorText ? errorText : '';
  }

  String passwordEqualErrorText(String newPassword, String confirmPassword) {
    final bool showErrorText = !(newPassword == confirmPassword);
    const String errorText =
        'Mật khẩu xác nhận không trùng khớp với mật khẩu bạn đã nhập';
    return showErrorText ? errorText : '';
  }
}
