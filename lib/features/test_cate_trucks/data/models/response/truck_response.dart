import 'dart:convert';

import 'package:movemate/features/test_cate_trucks/domain/entities/truck_entities.dart';

class TruckResponse {
  final List<TruckEntities> payload;

  TruckResponse({
    required this.payload,
  });

  Map<String, dynamic> toMap() {
    final result = <String, dynamic>{};

    result.addAll({'payload': payload.map((x) => x.toMap()).toList()});

    print("call in response $result");
    return result;
  }


  factory TruckResponse.fromMap(Map<String, dynamic> map) {
    return TruckResponse(
      payload: List<TruckEntities>.from(
          map['payload']?.map((x) => TruckEntities.fromMap(x))),
    );
  }

  String toJson() => json.encode(toMap());

  factory TruckResponse.fromJson(String source) =>
      TruckResponse.fromMap(json.decode(source));
}



