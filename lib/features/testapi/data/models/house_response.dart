import 'dart:convert';

import 'package:movemate/features/testapi/data/models/house_model.dart';

class HouseResponse {
  final List<HouseModel> houses;

  HouseResponse({required this.houses});

  Map<String, dynamic> toMap() {
    final result = <String, dynamic>{};

    result.addAll({'houses': houses.map((x) => x.toMap()).toList()});

    return result;
  }

  factory HouseResponse.fromMap(Map<String, dynamic> map) {
    return HouseResponse(
      houses: List<HouseModel>.from(
        map['houses']?.map(
          (x) => HouseModel.fromMap(x),
        ),
      ),
    );
  }
  @override
  String toString() => json.encode(toMap());

  //
  factory HouseResponse.fromJson(String source) => HouseResponse.fromMap(
        json.decode(source),
      );
}
