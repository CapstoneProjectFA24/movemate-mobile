// service_entity.dart

import 'dart:convert';

import 'package:movemate/features/booking/domain/entities/truck_category_entity.dart';

class ServicesPackageEntity {
  final int id;
  final String name;
  final String description;
  final bool isActived;
  final int tier;
  final String imageUrl;
  final String? type;
  final double discountRate;
  final double amount;
  final int? parentServiceId;
  final TruckCategoryEntity? truckCategory;

  ServicesPackageEntity({
    required this.id,
    required this.name,
    required this.description,
    required this.isActived,
    required this.tier,
    required this.imageUrl,
    this.type,
    required this.discountRate,
    required this.amount,
    this.parentServiceId,
    this.truckCategory,
  });

  factory ServicesPackageEntity.fromMap(Map<String, dynamic> map) {
    return ServicesPackageEntity(
      id: map['id'] ?? 0,
      name: map['name'] ?? '',
      description: map['description'] ?? '',
      isActived: map['isActived'] ?? false,
      tier: map['tier'] ?? 0,
      imageUrl: map['imageUrl'] ?? '',
      type: map['type'],
      discountRate: (map['discountRate'] ?? 0).toDouble(),
      amount: (map['amount'] ?? 0).toDouble(),
      parentServiceId: map['parentServiceId'],
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
      'isActived': isActived,
      'tier': tier,
      'imageUrl': imageUrl,
      'type': type,
      'discountRate': discountRate,
      'amount': amount,
      'parentServiceId': parentServiceId,
      'truckCategory': truckCategory?.toMap(),
    };
  }

  String toJson() => json.encode(toMap());

  factory ServicesPackageEntity.fromJson(String source) =>
      ServicesPackageEntity.fromMap(json.decode(source));
}
