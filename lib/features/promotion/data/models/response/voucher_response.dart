import 'dart:convert';

import 'package:movemate/features/promotion/domain/entities/voucher_entity.dart';

class VoucherResponse {
  final VoucherEntity payload;

  VoucherResponse({
    required this.payload,
  });

  Map<String, dynamic> toMap() {
    final result = <String, dynamic>{};

    result.addAll({'payload': payload.toMap()});

    return result;
  }

  factory VoucherResponse.fromMap(Map<String, dynamic> map) {
    return VoucherResponse(
      payload: VoucherEntity.fromMap(map['payload']),
    );
  }

  String toJson() => json.encode(toMap());

  factory VoucherResponse.fromJson(String source) =>
      VoucherResponse.fromMap(json.decode(source));
}
