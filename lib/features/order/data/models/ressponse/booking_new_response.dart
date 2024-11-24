import 'dart:convert';
import 'package:movemate/features/order/domain/entites/order_entity.dart';

class BookingNewResponse {
  final OrderEntity payload;

  BookingNewResponse({
    required this.payload,
  });

  Map<String, dynamic> toMap() {
    final result = <String, dynamic>{};
    result.addAll({'payload': payload.toMap()});  

    return result;
  }

  factory BookingNewResponse.fromMap(Map<String, dynamic> map) {
    return BookingNewResponse(
      payload: OrderEntity.fromMap(map['payload']),  
    );
  }

  String toJson() => json.encode(toMap());

  factory BookingNewResponse.fromJson(String source) =>
      BookingNewResponse.fromMap(json.decode(source));
}