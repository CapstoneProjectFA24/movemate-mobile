String formatPhoneNumber(String phone) {
// case :
  //+84
  // bắt đầu = 0 => +84
  // bắt đầu = 84 => +84
  // bắt đầu !=84  => +84
  // lenght > 11

  String digitsOnly = phone.replaceAll(RegExp(r'\D'), '');

  if (digitsOnly.startsWith('0')) {
    digitsOnly = '84${digitsOnly.substring(1)}';
  }

  if (!digitsOnly.startsWith('84')) {
    digitsOnly = '84$digitsOnly';
  }

  digitsOnly =
      digitsOnly.length > 15 ? digitsOnly.substring(0, 15) : digitsOnly;

  return '+$digitsOnly';
}
