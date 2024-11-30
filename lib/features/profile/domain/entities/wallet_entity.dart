

import 'dart:convert';

class WalletEntity {
  final int id;
  final int userId;
  final double balance;
  final String? createdAt;
  final String? updatedAt;

  WalletEntity({
    required this.id,
    required this.userId,
    required this.balance,
    this.createdAt,
    this.updatedAt,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'userId': userId,
      'balance': balance,
      'createdAt': createdAt,
      'updatedAt': updatedAt,
    };
  }

  factory WalletEntity.fromMap(Map<String, dynamic> map) {
    return WalletEntity(
      id: map['id']?.toInt() ?? 0,
      userId: map['userId']?.toInt() ?? 0,
      balance: map['balance']?.toDouble() ?? 0.0,
      createdAt: map['createdAt'],
      updatedAt: map['updatedAt'],
    );
  }

  String toJson() => json.encode(toMap());
  @override
  String toString() {
    return 'WalletEntity(id: $id, userId: $userId, balance: $balance, createdAt: $createdAt, updatedAt: $updatedAt)';
  }

  factory WalletEntity.fromJson(String source) =>
      WalletEntity.fromMap(json.decode(source));
}
