import 'dart:convert';

import 'package:movemate/features/booking/domain/entities/truck_category_entity.dart';

class ServiceEntity {
  final int id;
  final String name;
  final String description;
  final bool isActived;
  final int tier;
  final String imageUrl;
  final String type;
  final double discountRate;
  final double amount;
  final TruckCategoryEntity? truckCategory; 

  ServiceEntity({
    required this.id,
    required this.name,
    required this.description,
    required this.isActived,
    required this.tier,
    required this.imageUrl,
    required this.type,
    required this.discountRate,
    required this.amount,
    this.truckCategory, 
  });

  factory ServiceEntity.fromMap(Map<String, dynamic> map) {
    return ServiceEntity(
      id: map['id'] ?? 0,
      name: map['name'] ?? '',
      description: map['description'] ?? '',
      isActived: map['isActived'] ?? false,
      tier: map['tier'] ?? 0,
      imageUrl: map['imageUrl'] ?? '',
      type: map['type'] ?? '',
      discountRate: (map['discountRate'] ?? 0).toDouble(),
      amount: (map['amount'] ?? 0).toDouble(),
      truckCategory: map['truckCategory'], 
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
      'truckCategory': truckCategory,
    };
  }

  String toJson() => json.encode(toMap());

  factory ServiceEntity.fromJson(String source) =>
      ServiceEntity.fromMap(json.decode(source));
}
