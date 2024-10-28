import 'dart:convert';
import 'package:movemate/features/booking/domain/entities/house_type_entity.dart';

class HouseTypeObjResponse {
  final HouseTypeEntity payload; 

  HouseTypeObjResponse({
    required this.payload,
  });

  Map<String, dynamic> toMap() {
    final result = <String, dynamic>{};

    result.addAll({'payload': payload.toMap()}); 

    return result;
  }

  factory HouseTypeObjResponse.fromMap(Map<String, dynamic> map) {
    return HouseTypeObjResponse(
      payload: HouseTypeEntity.fromMap(map['payload']), 
    );
  }

  String toJson() => json.encode(toMap());

  factory HouseTypeObjResponse.fromJson(String source) =>
      HouseTypeObjResponse.fromMap(json.decode(source));
}
