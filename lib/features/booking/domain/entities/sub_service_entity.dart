// sub_service_entity.dart

import 'dart:convert';
import 'package:movemate/features/booking/domain/entities/truck_category_entity.dart';

class SubServiceEntity {
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
  final int? quantity; // Add this field

  SubServiceEntity({
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
    this.quantity,
  });

  factory SubServiceEntity.fromMap(Map<String, dynamic> map) {
    return SubServiceEntity(
      id: map['id'] ?? 0,
      name: map['name'] ?? '',
      description: map['description'] ?? '',
      isActived: map['isActived'] ?? false,
      tier: map['tier'] ?? 0,
      imageUrl: map['imageUrl'] ?? '',
      type: map['type'] ?? '',
      discountRate: (map['discountRate'] ?? 0).toDouble(),
      amount: (map['amount'] ?? 0).toDouble(),
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
      'truckCategory': truckCategory?.toMap(),
    };
  }

  copyWith({
    int? id,
    String? name,
    String? description,
    String? type,
    double? amount,
    int? quantity,
  }) {
    return SubServiceEntity(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
      type: type ?? this.type,
      amount: amount ?? this.amount,
      quantity: quantity ?? this.quantity,
      isActived: isActived ?? isActived,
      tier: tier ?? tier,
      imageUrl: '',
      discountRate: discountRate ?? discountRate,
    );
  }

  String toJson() => json.encode(toMap());
  // @override
  // String toString() {
  //   return 'SubServiceEntity(id: $id, name: $name, description: $description, isActived: $isActived, tier: $tier, imageUrl: $imageUrl, type: $type, discountRate: $discountRate, amount: $amount, truckCategory: $truckCategory)';
  // }

  factory SubServiceEntity.fromJson(String source) =>
      SubServiceEntity.fromMap(json.decode(source));
}
