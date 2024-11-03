// services_package_entity.dart

import 'dart:convert';
import 'package:movemate/features/booking/domain/entities/service_truck/inverse_parent_service_entity.dart';
import 'package:movemate/features/booking/domain/entities/truck_category_entity.dart';

class ServicesPackageTruckEntity {
  final int id;
  final String name;
  final String description;
  final bool isActived;
  final int tier;
  final String imageUrl;
  final int? quantity;
  final String? type;
  final double discountRate;
  final double amount;
  final int? parentServiceId;
  final int? truckCategoryId; // Thêm trường này
  final bool isQuantity; // Thêm trường này
  final int? quantityMax; // Thêm trường này
  final TruckCategoryEntity? truckCategory;
  final List<InverseParentServiceEntity> inverseParentService;

  ServicesPackageTruckEntity({
    required this.id,
    required this.name,
    required this.description,
    required this.isActived,
    required this.tier,
    required this.imageUrl,
    this.quantity,
    this.type,
    required this.discountRate,
    required this.amount,
    this.parentServiceId,
    this.truckCategoryId, // Thêm trường này
    required this.isQuantity, // Thêm trường này
    this.quantityMax, // Thêm trường này
    this.truckCategory,
    required this.inverseParentService,
  });

  // Added copyWith method
  ServicesPackageTruckEntity copyWith({
    int? id,
    String? name,
    String? description,
    bool? isActived,
    int? tier,
    String? imageUrl,
    int? quantity,
    String? type,
    double? discountRate,
    double? amount,
    int? parentServiceId,
    int? truckCategoryId, // Thêm trường này
    bool? isQuantity, // Thêm trường này
    int? quantityMax, // Thêm trường này
    TruckCategoryEntity? truckCategory,
    List<InverseParentServiceEntity>? inverseParentService,
  }) {
    return ServicesPackageTruckEntity(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
      isActived: isActived ?? this.isActived,
      tier: tier ?? this.tier,
      imageUrl: imageUrl ?? this.imageUrl,
      quantity: quantity ?? this.quantity,
      type: type ?? this.type,
      discountRate: discountRate ?? this.discountRate,
      amount: amount ?? this.amount,
      parentServiceId: parentServiceId ?? this.parentServiceId,
      truckCategoryId: truckCategoryId ?? this.truckCategoryId, // Thêm dòng này
      isQuantity: isQuantity ?? this.isQuantity, // Thêm dòng này
      quantityMax: quantityMax ?? this.quantityMax, // Thêm dòng này
      truckCategory: truckCategory ?? this.truckCategory,
      inverseParentService: inverseParentService ?? this.inverseParentService,
    );
  }

  factory ServicesPackageTruckEntity.fromMap(Map<String, dynamic> map) {
    return ServicesPackageTruckEntity(
      id: map['id'] ?? 0,
      name: map['name'] ?? '',
      description: map['description'] ?? '',
      isActived: map['isActived'] ?? false,
      tier: map['tier'] ?? 0,
      imageUrl: map['imageUrl'] ?? '',
      quantity: map['quantity'],
      type: map['type'],
      discountRate: (map['discountRate'] ?? 0).toDouble(),
      amount: (map['amount'] ?? 0).toDouble(),
      parentServiceId: map['parentServiceId'],
      truckCategoryId: map['truckCategoryId'], // Thêm dòng này
      isQuantity: map['isQuantity'] ?? false, // Thêm dòng này
      quantityMax: map['quantityMax'], // Thêm dòng này
      truckCategory: map['truckCategory'] != null
          ? TruckCategoryEntity.fromMap(map['truckCategory'])
          : null,
      inverseParentService: map['inverseParentService'] != null
          ? List<InverseParentServiceEntity>.from(map['inverseParentService']
              .map((x) => InverseParentServiceEntity.fromMap(x)))
          : [],
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
      'quantity': quantity,
      'type': type,
      'discountRate': discountRate,
      'amount': amount,
      'parentServiceId': parentServiceId,
      'truckCategoryId': truckCategoryId, // Thêm dòng này
      'isQuantity': isQuantity, // Thêm dòng này
      'quantityMax': quantityMax, // Thêm dòng này
      'truckCategory': truckCategory?.toMap(),
      'inverseParentService':
          inverseParentService.map((x) => x.toMap()).toList(),
    };
  }

  String toJson() => json.encode(toMap());

  factory ServicesPackageTruckEntity.fromJson(String source) =>
      ServicesPackageTruckEntity.fromMap(json.decode(source));

  @override
  String toString() {
    return 'ServicesPackageTruckEntity(id: $id, name: $name, description: $description, isActived: $isActived, tier: $tier, imageUrl: $imageUrl, quantity: $quantity, type: $type, discountRate: $discountRate, amount: $amount, parentServiceId: $parentServiceId, truckCategoryId: $truckCategoryId, isQuantity: $isQuantity, quantityMax: $quantityMax, truckCategory: $truckCategory, inverseParentService: $inverseParentService)';
  }
}
