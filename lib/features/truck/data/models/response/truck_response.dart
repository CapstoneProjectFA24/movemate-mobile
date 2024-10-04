import 'dart:convert';
import 'package:movemate/features/truck/domain/entities/truck_entity.dart';

class TruckResponse {
  final List<TruckEntity> payload;

  TruckResponse({
    required this.payload,
  });

    Map<String, dynamic> toMap() {
    final result = <String, dynamic>{};

    result.addAll({'payload': payload.map((x) => x.toMap()).toList()});

    return result;
  }

    factory TruckResponse.fromMap(Map<String, dynamic> map) {
    return TruckResponse(
       payload: List<TruckEntity>.from(
          map['payload']?.map((x) => TruckEntity.fromMap(x))),
    );
  }

   String toJson() => json.encode(toMap());
   

  factory TruckResponse.fromJson(String source) =>
      TruckResponse.fromMap(json.decode(source));

}
