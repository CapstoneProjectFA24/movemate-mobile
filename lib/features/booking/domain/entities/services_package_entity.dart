// services_package_entity.dart

import 'dart:convert';
import 'package:movemate/features/booking/domain/entities/truck_category_entity.dart';
import 'package:movemate/features/booking/domain/entities/sub_service_entity.dart';

class ServicesPackageEntity {
  final int id;
  final String name;
  final String description;
  final bool isActived;
  final int tier;
  final String imageUrl;
  final int? quantity; // Added quantity field
  final String? type;
  final double discountRate;
  final double amount;
  final int? parentServiceId;
  final bool isQuantity; // Thêm trường này
  final int? quantityMax; // Thêm trường này
  final TruckCategoryEntity? truckCategory;
  final List<SubServiceEntity> inverseParentService;

  ServicesPackageEntity({
    required this.id,
    required this.name,
    required this.description,
    required this.isActived,
    required this.tier,
    required this.imageUrl,
    this.quantity, // Include in constructor
    this.type,
    required this.discountRate,
    required this.amount,
    this.parentServiceId,
    this.truckCategory,
    required this.inverseParentService,
    required this.isQuantity, // Khởi tạo trường này
    this.quantityMax,
  });

  // Added copyWith method
  ServicesPackageEntity copyWith({
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
    TruckCategoryEntity? truckCategory,
    List<SubServiceEntity>? inverseParentService,
    bool? isQuantity,
    int? quantityMax,
  }) {
    return ServicesPackageEntity(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
      isActived: isActived ?? this.isActived,
      tier: tier ?? this.tier,
      imageUrl: imageUrl ?? this.imageUrl,
      quantity: quantity ?? this.quantity, // Handle quantity
      type: type ?? this.type,
      discountRate: discountRate ?? this.discountRate,
      amount: amount ?? this.amount,
      parentServiceId: parentServiceId ?? this.parentServiceId,
      truckCategory: truckCategory ?? this.truckCategory,
      inverseParentService: inverseParentService ?? this.inverseParentService,
      isQuantity: isQuantity ?? this.isQuantity,
      quantityMax: quantityMax ?? this.quantityMax,
    );
  }

  factory ServicesPackageEntity.fromMap(Map<String, dynamic> map) {
    return ServicesPackageEntity(
      id: map['id'] ?? 0,
      name: map['name'] ?? '',
      description: map['description'] ?? '',
      isActived: map['isActived'] ?? false, // Ensure non-null value
      tier: map['tier'] ?? 0,
      imageUrl: map['imageUrl'] ?? '',
      quantity: map['quantity'], // Parse quantity
      type: map['type'],
      discountRate: (map['discountRate'] ?? 0).toDouble(),
      amount: (map['amount'] ?? 0).toDouble(),
      parentServiceId: map['parentServiceId'],
      truckCategory: map['truckCategory'] != null
          ? TruckCategoryEntity.fromMap(map['truckCategory'])
          : null,
      inverseParentService: map['inverseParentService'] != null
          ? List<SubServiceEntity>.from(map['inverseParentService']
              .map((x) => SubServiceEntity.fromMap(x)))
          : [],
      isQuantity: map['isQuantity'] ?? false, // Ensure non-null value
      quantityMax: map['quantityMax'], // Handle quantityMax
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
      'quantity': quantity, // Include in map
      'type': type,
      'discountRate': discountRate,
      'amount': amount,
      'parentServiceId': parentServiceId,
      'truckCategory': truckCategory?.toMap(),
      'inverseParentService':
          inverseParentService.map((x) => x.toMap()).toList(),
      'isQuantity': isQuantity, // Thêm dòng này
      'quantityMax': quantityMax, // Thêm dòng này
    };
  }

  String toJson() => json.encode(toMap());

  factory ServicesPackageEntity.fromJson(String source) =>
      ServicesPackageEntity.fromMap(json.decode(source));

  @override
  String toString() {
    return 'ServicesPackageEntity(id: $id, name: $name, description: $description, isActived: $isActived, tier: $tier, imageUrl: $imageUrl, quantity: $quantity, type: $type, discountRate: $discountRate, amount: $amount, parentServiceId: $parentServiceId, truckCategory: $truckCategory, inverseParentService: $inverseParentService, isQuantity: $isQuantity, quantityMax: $quantityMax)';
  }
}
