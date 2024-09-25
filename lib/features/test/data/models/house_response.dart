import 'dart:convert';

import 'package:movemate/features/test/data/models/house_model.dart';

class HouseResponse {
    final List<HouseModel> payload;


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
       payload: List<HouseModel>.from(
          map['houses']?.map((x) => HouseModel.fromMap(x))),
    );
  }

  String toJson() => json.encode(toMap());

  factory HouseResponse.fromJson(String source) =>
      HouseResponse.fromMap(json.decode(source));
}
