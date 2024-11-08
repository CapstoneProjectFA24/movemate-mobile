import 'dart:convert';

import 'package:movemate/features/booking/domain/entities/valuation_booking/valuation_entity.dart';

class ValuationResponse {
  final ValuationEntity payload;

  ValuationResponse({
    required this.payload,
  });

  Map<String, dynamic> toMap() {
    final result = <String, dynamic>{};

    result.addAll({'payload': payload.toMap()});

    return result;
  }

  factory ValuationResponse.fromMap(Map<String, dynamic> map) {
    return ValuationResponse(
      payload: ValuationEntity.fromJson(
          map['payload']?.map((x) => ValuationEntity.fromJson(x))),
    );
  }

  String toJson() => json.encode(toMap());

  factory ValuationResponse.fromJson(String source) =>
      ValuationResponse.fromMap(json.decode(source));
}
