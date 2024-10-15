import 'dart:convert';

import 'package:movemate/features/booking/domain/entities/vinh/house_type_entity.dart';



class HouseTypeResponse {
  final List<HouseTypeEntity> payload;

  HouseTypeResponse({
    required this.payload,
  });

  Map<String, dynamic> toMap() {
    final result = <String, dynamic>{};

    result.addAll({'payload': payload.map((x) => x.toMap()).toList()});

    return result;
  }

  factory HouseTypeResponse.fromMap(Map<String, dynamic> map) {
  return HouseTypeResponse(
    payload: List<HouseTypeEntity>.from(
        map['payload']?.map((x) => HouseTypeEntity.fromMap(x))),
  );
}


  String toJson() => json.encode(toMap());

  factory HouseTypeResponse.fromJson(String source) =>
      HouseTypeResponse.fromMap(json.decode(source));
}
