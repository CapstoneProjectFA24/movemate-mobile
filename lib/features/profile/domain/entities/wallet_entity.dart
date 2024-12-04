// "id": 3,
// "userId": 3,
// "balance": 135664240,
// "bankNumber": "string",
// "bankName": "string",
// "isLocked": false,
// "createdAt": "2024-10-25T23:46:49.703",
// "updatedAt": "2024-12-05T03:19:16.947"

import 'dart:convert';

class WalletEntity {
  final int id;
  final int userId;
  final double balance;
  final String? createdAt;
  final String? updatedAt;
  final String? bankNumber;
  final String? bankName;
  final bool? isLocked;

  WalletEntity({
    required this.id,
    required this.userId,
    required this.balance,
    this.createdAt,
    this.updatedAt,
    this.bankNumber,
    this.bankName,
    this.isLocked,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'userId': userId,
      'balance': balance,
      'createdAt': createdAt,
      'updatedAt': updatedAt,
      'bankNumber': bankNumber,
      'bankName': bankName,
      'isLocked': isLocked,
    };
  }

  factory WalletEntity.fromMap(Map<String, dynamic> map) {
    return WalletEntity(
      id: map['id']?.toInt() ?? 0,
      userId: map['userId']?.toInt() ?? 0,
      balance: map['balance']?.toDouble() ?? 0.0,
      createdAt: map['createdAt'],
      updatedAt: map['updatedAt'],
      bankNumber: map['bankNumber'] ?? '',
      bankName: map['bankName'] ?? '',
      isLocked: map['isLocked'] ?? false,
    );
  }

  String toJson() => json.encode(toMap());
  @override
  String toString() {
    return 'WalletEntity(id: $id, userId: $userId, balance: $balance, createdAt: $createdAt, updatedAt: $updatedAt , bankNumber: $bankNumber,  bankName: $bankName,  isLocked: $isLocked,)';
  }

  factory WalletEntity.fromJson(String source) =>
      WalletEntity.fromMap(json.decode(source));
}
