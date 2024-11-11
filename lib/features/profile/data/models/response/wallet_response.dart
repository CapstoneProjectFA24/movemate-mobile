import 'dart:convert';

import 'package:movemate/features/profile/domain/entities/profile_entity.dart';
import 'package:movemate/features/profile/domain/entities/wallet_entity.dart';

class WalletResponse {
  final WalletEntity payload;

  WalletResponse({
    required this.payload,
  });

  Map<String, dynamic> toMap() {
    final result = <String, dynamic>{};

    result.addAll({'payload': payload.toMap()});

    return result;
  }

  factory WalletResponse.fromMap(Map<String, dynamic> map) {
    return WalletResponse(
      payload: WalletEntity.fromMap(map['payload']),
    );
  }

  String toJson() => json.encode(toMap());

  factory WalletResponse.fromJson(String source) =>
      WalletResponse.fromMap(json.decode(source));
}
