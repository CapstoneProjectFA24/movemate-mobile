import 'dart:convert';

class PaymentRequest {
  final String?
      bookingId; // cần bookingId khi tạo booking -> đặt cọc hoặc thanh toán
  final double? amount; // cần amount khi nạp tiền
  final String returnUrl;
  final String selectedMethod;

  PaymentRequest({
    this.bookingId,
    this.amount,
    // required this.returnUrl,
    this.returnUrl = "movemate://payment-result",
    required this.selectedMethod,
  });

  Map<String, dynamic> toMap() {
    final result = <String, dynamic>{};

    if (bookingId != null) {
      result.addAll({'bookingId': bookingId});
    }
    if (amount != null) {
      result.addAll({'amount': amount});
    }
    result.addAll({'returnUrl': returnUrl});
    result.addAll({'selectedMethod': selectedMethod});

    return result;
  }

  factory PaymentRequest.fromMap(Map<String, dynamic> map) {
    return PaymentRequest(
      bookingId: map['bookingId'],
      amount: map['amount']?.toDouble(),
      returnUrl: map['returnUrl'] ?? '',
      selectedMethod: map['selectedMethod'] ?? '',
    );
  }

  String toJson() => json.encode(toMap());
  @override
  String toString() {
    return 'PaymentRequest(bookingId: $bookingId, amount: $amount, returnUrl: $returnUrl, selectedMethod: $selectedMethod)';
  }

  factory PaymentRequest.fromJson(String source) =>
      PaymentRequest.fromMap(json.decode(source));
}
