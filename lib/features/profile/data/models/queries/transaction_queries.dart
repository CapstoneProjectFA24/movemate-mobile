import 'dart:convert';

class TransactionQueries {
  final bool? isWallet;
  final int? userId;

  TransactionQueries({
    this.userId,
    this.isWallet,
  });

  Map<String, dynamic> toMap() {
    final result = <String, dynamic>{};

    if (userId != null) {
      result['UserId'] = userId;
    }

    if (isWallet != null) {
      result['IsWallet'] = isWallet;
    }

    return result;
  }

  factory TransactionQueries.fromMap(Map<String, dynamic> map) {
    return TransactionQueries(
      userId: map['UserId']?.toInt(),
      isWallet: map['IsWallet']?.boolValue, 
    );
  }

  String toJson() => json.encode(toMap());

  factory TransactionQueries.fromJson(String source) =>
      TransactionQueries.fromMap(json.decode(source));
}
