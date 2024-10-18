enum PaymentMethodType {
  momo('Momo'),
  vnpay('VnPay'),
  payos('PayOS');

  final String type;
  const PaymentMethodType(this.type);
}

extension ConvertPaymentMethodType on String {
  PaymentMethodType toPaymentMethodTypeEnum() {
    switch (this) {
      case 'Momo':
        return PaymentMethodType.momo;
      case 'VnPay':
        return PaymentMethodType.vnpay;
      case 'PayOS':
        return PaymentMethodType.payos;
      default:
        return PaymentMethodType.momo;
    }
  }
}
