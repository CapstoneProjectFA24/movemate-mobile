import 'dart:convert';

class WithDrawQueries {
  // final bool? isWallet;
  final double? amount;

  WithDrawQueries({
    this.amount,
    // this.isWallet,
  });

  Map<String, dynamic> toMap() {
    final result = <String, dynamic>{};

    if (amount != null) {
      result['amount'] = amount;
    }

    // if (isWallet != null) {
    //   result['IsWallet'] = isWallet;
    // }

    return result;
  }

  factory WithDrawQueries.fromMap(Map<String, dynamic> map) {
    return WithDrawQueries(
      amount: map['amount']?.toDouble(),
      // isWallet: map['IsWallet']?.boolValue,
    );
  }

  String toJson() => json.encode(toMap());

  factory WithDrawQueries.fromJson(String source) =>
      WithDrawQueries.fromMap(json.decode(source));
}
