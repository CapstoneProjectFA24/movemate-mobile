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
  final int? quantity;
  final bool isQuantity; // Thêm trường này
  final int? quantityMax; // Thêm trường này

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
    required this.isQuantity, // Khởi tạo trường này
    this.quantityMax,
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
      isQuantity: map['isQuantity'] ?? false, // Thêm dòng này
      quantityMax: map['quantityMax'], // Thêm dòng này
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
      'isQuantity': isQuantity, // Thêm dòng này
      'quantityMax': quantityMax, // Thêm dòng này
    };
  }

  SubServiceEntity copyWith({
    int? id,
    String? name,
    String? description,
    bool? isActived,
    int? tier,
    String? imageUrl,
    String? type,
    double? discountRate,
    double? amount,
    TruckCategoryEntity? truckCategory,
    int? quantity,
    bool? isQuantity,
    int? quantityMax,
  }) {
    return SubServiceEntity(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
      isActived: isActived ?? this.isActived,
      tier: tier ?? this.tier,
      imageUrl: imageUrl ?? this.imageUrl,
      type: type ?? this.type,
      discountRate: discountRate ?? this.discountRate,
      amount: amount ?? this.amount,
      truckCategory: truckCategory ?? this.truckCategory,
      quantity: quantity ?? this.quantity,
      isQuantity: isQuantity ?? this.isQuantity,
      quantityMax: quantityMax ?? this.quantityMax,
    );
  }

  String toJson() => json.encode(toMap());

  factory SubServiceEntity.fromJson(String source) =>
      SubServiceEntity.fromMap(json.decode(source));
}
