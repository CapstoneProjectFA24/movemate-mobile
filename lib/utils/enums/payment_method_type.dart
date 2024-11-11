// enums_export.dart

enum PaymentMethodType {
  momo('Momo'),
  vnpay('VnPay'),
  payos('PayOS'),
  wallet('Wallet');

  final String type;
  const PaymentMethodType(this.type);
}

// Extension to get image URL and display name
extension PaymentMethodTypeExtension on PaymentMethodType {
  String get imageUrl {
    switch (this) {
      case PaymentMethodType.momo:
        return 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQvgKuQKWNXtGtsM0RQ-mt_-Rjl0W8gZJ5Kkw&s';
      case PaymentMethodType.vnpay:
        return 'https://vnpay.vn/s1/statics.vnpay.vn/2023/6/0cb6rjka67v1685959226087.jpg'; // Replace with actual URL
      case PaymentMethodType.payos:
        return 'https://res.cloudinary.com/dietfw7lr/image/upload/v1729283227/tk9d9gzthqg62slzhnaf.png'; // Replace with actual URL
      case PaymentMethodType.wallet:
        return ''; // Replace with actual URL
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
      case PaymentMethodType.wallet:
        return 'Wallet';
    }
  }
}
