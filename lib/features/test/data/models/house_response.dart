import 'dart:convert';

import 'package:movemate/features/test/domain/entities/house_entities.dart';

class HouseResponse {
    final List<HouseEntities> payload;


  HouseResponse({
    required this.payload,
   
  });

  Map<String, dynamic> toMap() {
    final result = <String, dynamic>{};

    result.addAll({'payload': payload.map((x) => x.toMap()).toList()});

    return result;
  }

  factory HouseResponse.fromMap(Map<String, dynamic> map) {
    return HouseResponse(
       payload: List<HouseEntities>.from(
          map['houses']?.map((x) => HouseEntities.fromMap(x))),
    );
  }

  String toJson() => json.encode(toMap());

  factory HouseResponse.fromJson(String source) =>
      HouseResponse.fromMap(json.decode(source));
}
