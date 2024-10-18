// enums_export.dart

enum PaymentMethodType {
  momo('Momo'),
  vnpay('VnPay'),
  payos('PayOS');

  final String type;
  const PaymentMethodType(this.type);
}

// Extension to get image URL and display name
extension PaymentMethodTypeExtension on PaymentMethodType {
  String get imageUrl {
    switch (this) {
      case PaymentMethodType.momo:
        return 'https://storage.googleapis.com/a1aa/image/EvKuteb1nL1qFy7sLmipOsj94j9pY7MX5RSo2xyLvNRJKfnTA.jpg';
      case PaymentMethodType.vnpay:
        return 'https://vnpay.vn/s1/statics.vnpay.vn/2023/6/0cb6rjka67v1685959226087.jpg'; // Replace with actual URL
      case PaymentMethodType.payos:
        return 'https://res.cloudinary.com/dietfw7lr/image/upload/v1729283227/tk9d9gzthqg62slzhnaf.png'; // Replace with actual URL
    }
  }

  String get displayName {
    switch (this) {
      case PaymentMethodType.momo:
        return 'MoMo E-Wallet';
      case PaymentMethodType.vnpay:
        return 'VNPAY';
      case PaymentMethodType.payos:
        return 'PayOS';
    }
  }
}
