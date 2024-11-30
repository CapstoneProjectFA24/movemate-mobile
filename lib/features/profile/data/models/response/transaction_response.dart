import 'dart:convert';

import 'package:movemate/features/profile/domain/entities/transaction_entity.dart';

class TransactionResponse {
  final List<TransactionEntity> payload;

  TransactionResponse({
    required this.payload,
  });

  Map<String, dynamic> toMap() {
    return {
      'payload': payload.map((x) => x.toMap()).toList(),
    };
  }

  factory TransactionResponse.fromMap(Map<String, dynamic> map) {
    return TransactionResponse(
      payload: List<TransactionEntity>.from(
          map['payload']?.map((x) => TransactionEntity.fromMap(x))),
    );
  }

  String toJson() => json.encode(toMap());

  factory TransactionResponse.fromJson(String source) =>
      TransactionResponse.fromMap(json.decode(source));

  @override
  String toString() {
    return 'TransactionResponse(payload: $payload)';
  }
}
