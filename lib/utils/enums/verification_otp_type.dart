enum VerificationOTPType {
  changepassword('changepassword'),
  forgotpassword('forgotpassword'),
  firsttimelog('firsttimelog');

  final String type;
  const VerificationOTPType(this.type);
}
