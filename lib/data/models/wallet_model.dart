import 'dart:convert';

class WalletModel {
  final int walletId;
  final int balance;
  final int totalDailyMoneyExchange;
  final int totalDailyShipperPayment;
  final int toTalOrderDaily;
  final int totalRevenueDaily;

  WalletModel({
    required this.walletId,
    required this.balance,
    required this.totalDailyMoneyExchange,
    required this.totalDailyShipperPayment,
    required this.toTalOrderDaily,
    required this.totalRevenueDaily,
  });

  Map<String, dynamic> toMap() {
    final result = <String, dynamic>{};

    result.addAll({'walletId': walletId});
    result.addAll({'balance': balance});
    result.addAll({'totalDailyMoneyExchange': totalDailyMoneyExchange});
    result.addAll({'totalDailyShipperPayment': totalDailyShipperPayment});
    result.addAll({'toTalOrderDaily': toTalOrderDaily});
    result.addAll({'totalRevenueDaily': totalRevenueDaily});

    return result;
  }

  factory WalletModel.fromMap(Map<String, dynamic> map) {
    return WalletModel(
      walletId: map['walletId']?.toInt() ?? 0,
      balance: map['balance']?.toInt() ?? 0,
      totalDailyMoneyExchange: map['totalDailyMoneyExchange']?.toInt() ?? 0,
      totalDailyShipperPayment: map['totalDailyShipperPayment']?.toInt() ?? 0,
      toTalOrderDaily: map['toTalOrderDaily']?.toInt() ?? 0,
      totalRevenueDaily: map['totalRevenueDaily']?.toInt() ?? 0,
    );
  }

  String toJson() => json.encode(toMap());

  factory WalletModel.fromJson(String source) =>
      WalletModel.fromMap(json.decode(source));
}
