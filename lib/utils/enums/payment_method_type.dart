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
        return 'https://res.cloudinary.com/dietfw7lr/image/upload/v1731512036/images_aniobl.png';
      case PaymentMethodType.vnpay:
        return 'https://res.cloudinary.com/dietfw7lr/image/upload/v1731512036/0cb6rjka67v1685959226087_tywkmh.jpg'; // Replace with actual URL
      case PaymentMethodType.payos:
        return 'https://res.cloudinary.com/dietfw7lr/image/upload/v1729283227/tk9d9gzthqg62slzhnaf.png'; // Replace with actual URL
      case PaymentMethodType.wallet:
        return 'https://res.cloudinary.com/dkpnkjnxs/image/upload/v1731511719/movemate_logo_e6f1lk.png'; // Replace with actual URL
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
        return 'Ví MoveMate';
    }
  }
}
