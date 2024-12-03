import 'dart:convert';

class TransactionEntity {
  final int id;
  final int paymentId;
  final int walletId;
  final String? resource;
  final double amount;
  final String? status;
  final String? substance;
  final String paymentMethod;
  final String transactionCode;
  final String transactionType;
  final bool isCredit;
  final String? createdAt;
  final String? updatedAt;

  TransactionEntity({
    required this.id,
    required this.paymentId,
    required this.walletId,
    this.resource,
    required this.amount,
    this.status,
    this.substance,
    required this.paymentMethod,
    required this.transactionCode,
    required this.transactionType,
    required this.isCredit,
    this.createdAt,
    this.updatedAt,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'paymentId': paymentId,
      'walletId': walletId,
      'resource': resource,
      'amount': amount,
      'status': status,
      'substance': substance,
      'paymentMethod': paymentMethod,
      'transactionCode': transactionCode,
      'transactionType': transactionType,
      'isCredit': isCredit,
      'createdAt': createdAt,
      'updatedAt': updatedAt,
    };
  }

  factory TransactionEntity.fromMap(Map<String, dynamic> map) {
    return TransactionEntity(
      id: map['id']?.toInt() ?? 0,
      paymentId: map['paymentId']?.toInt() ?? 0,
      walletId: map['walletId']?.toInt() ?? 0,
      resource: map['resource'],
      amount: map['amount']?.toDouble() ?? 0.0,
      status: map['status'],
      substance: map['substance'],
      paymentMethod: map['paymentMethod'] ?? '',
      transactionCode: map['transactionCode'] ?? '',
      transactionType: map['transactionType'] ?? '',
      isCredit: map['isCredit'] ?? false,
      createdAt: map['createdAt'],
      updatedAt: map['updatedAt'],
    );
  }

  String toJson() => json.encode(toMap());

  @override
  String toString() {
    return 'TransactionEntity(id: $id, paymentId: $paymentId, walletId: $walletId, resource: $resource, amount: $amount, status: $status, substance: $substance, paymentMethod: $paymentMethod, transactionCode: $transactionCode, transactionType: $transactionType, isCredit: $isCredit, createdAt: $createdAt, updatedAt: $updatedAt)';
  }

  factory TransactionEntity.fromJson(String source) =>
      TransactionEntity.fromMap(json.decode(source));
}
