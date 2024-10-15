import 'dart:convert';

import 'package:movemate/features/booking/domain/entities/vinh/truck_category_entity.dart';

class InverseParentServiceEntity {
  final int id;
  final String name;
  final String description;
  final bool isActived;
  final String imgUrl;
  final String tier;
  final String type;
  final String discountRate;
  final int amount;
  final TruckCategoryEntity? truckCategory;

  InverseParentServiceEntity({
    required this.id,
    required this.name,
    required this.description,
    required this.imgUrl,
    required this.tier,
    required this.type,
    required this.discountRate,
    required this.amount,
    required this.isActived,
    this.truckCategory,
  });

  factory InverseParentServiceEntity.fromMap(Map<String, dynamic> map) {
    return InverseParentServiceEntity(
      id: map['id'] ?? 0,
      name: map['name'] ?? '',
      description: map['description'] ?? '',
      imgUrl: map['imgUrl'] ?? '',
      tier: map['tier'] ?? '',
      type: map['type'] ?? '',
      discountRate: map['discountRate'] ?? '',
      amount: map['amount'] ?? 0,
      isActived: map['isActived'] ?? false,
      truckCategory: map['truckCategory'] != null
          ? TruckCategoryEntity.fromMap(map['truckCategory'])
          : null,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'imgUrl': imgUrl,
      'tier': tier,
      'type': type,
      'discountRate': discountRate,
      'amount': amount,
      'isActived': isActived,
      'truckCategory': truckCategory!.toMap()
    };
  }

  String toJson() => json.encode(toMap());

  factory InverseParentServiceEntity.fromJson(String source) =>
      InverseParentServiceEntity.fromMap(json.decode(source));
}
