// sub_service_entity.dart

import 'dart:convert';
import 'package:movemate/features/booking/domain/entities/truck_category_entity.dart';

class InverseParentServiceEntity {
  final int id;
  final String name;
  final String description;
  final bool isActived;
  final int tier;
  final String imageUrl;
  final String type;
  final double discountRate;
  final double amount;
  final int? parentServiceId; // Thêm trường này
  final int? truckCategoryId; // Thêm trường này
  final int? quantity;
  final bool isQuantity;
  final int? quantityMax;
  final TruckCategoryEntity? truckCategory;

  InverseParentServiceEntity({
    required this.id,
    required this.name,
    required this.description,
    required this.isActived,
    required this.tier,
    required this.imageUrl,
    required this.type,
    required this.discountRate,
    required this.amount,
    this.parentServiceId, // Thêm trường này
    this.truckCategoryId, // Thêm trường này
    this.truckCategory,
    this.quantity,
    required this.isQuantity,
    this.quantityMax,
  });

  factory InverseParentServiceEntity.fromMap(Map<String, dynamic> map) {
    return InverseParentServiceEntity(
      id: map['id'] ?? 0,
      name: map['name'] ?? '',
      description: map['description'] ?? '',
      isActived: map['isActived'] ?? false,
      tier: map['tier'] ?? 0,
      imageUrl: map['imageUrl'] ?? '',
      type: map['type'] ?? '',
      discountRate: (map['discountRate'] ?? 0).toDouble(),
      amount: (map['amount'] ?? 0).toDouble(),
      parentServiceId: map['parentServiceId'], // Thêm dòng này
      truckCategoryId: map['truckCategoryId'], // Thêm dòng này
      truckCategory: map['truckCategory'] != null
          ? TruckCategoryEntity.fromMap(map['truckCategory'])
          : null,
      isQuantity: map['isQuantity'] ?? false,
      quantityMax: map['quantityMax'],
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
      'parentServiceId': parentServiceId, // Thêm dòng này
      'truckCategoryId': truckCategoryId, // Thêm dòng này
      'truckCategory': truckCategory?.toMap(),
      'isQuantity': isQuantity,
      'quantityMax': quantityMax,
    };
  }

  InverseParentServiceEntity copyWith({
    int? id,
    String? name,
    String? description,
    bool? isActived,
    int? tier,
    String? imageUrl,
    String? type,
    double? discountRate,
    double? amount,
    int? parentServiceId, // Thêm trường này
    int? truckCategoryId, // Thêm trường này
    TruckCategoryEntity? truckCategory,
    int? quantity,
    bool? isQuantity,
    int? quantityMax,
  }) {
    return InverseParentServiceEntity(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
      isActived: isActived ?? this.isActived,
      tier: tier ?? this.tier,
      imageUrl: imageUrl ?? this.imageUrl,
      type: type ?? this.type,
      discountRate: discountRate ?? this.discountRate,
      amount: amount ?? this.amount,
      parentServiceId: parentServiceId ?? this.parentServiceId, // Thêm dòng này
      truckCategoryId: truckCategoryId ?? this.truckCategoryId, // Thêm dòng này
      truckCategory: truckCategory ?? this.truckCategory,
      quantity: quantity ?? this.quantity,
      isQuantity: isQuantity ?? this.isQuantity,
      quantityMax: quantityMax ?? this.quantityMax,
    );
  }

  String toJson() => json.encode(toMap());

  factory InverseParentServiceEntity.fromJson(String source) =>
      InverseParentServiceEntity.fromMap(json.decode(source));
}
