import 'dart:convert';

import 'package:movemate/features/order/domain/entites/order_entity.dart';

class OrderReponse {
  final List<OrderEntity> payload;

  OrderReponse({
    required this.payload,
  });

  Map<String, dynamic> toMap() {
    final result = <String, dynamic>{};
result.addAll({'payload': payload.map((x) => x.toMap()).toList()});

    return result;
  }

  factory OrderReponse.fromMap(Map<String, dynamic> map) {
    return OrderReponse(
       payload: List<OrderEntity>.from(
          map['payload']?.map((x) => OrderEntity.fromMap(x))),
    );
  }

  String toJson() => json.encode(toMap());

  factory OrderReponse.fromJson(String source) =>
      OrderReponse.fromMap(json.decode(source));
}
