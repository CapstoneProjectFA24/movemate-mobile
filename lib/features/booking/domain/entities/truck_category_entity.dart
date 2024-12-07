import 'dart:convert';

class TruckCategoryEntity {
  final int id;
  final String categoryName;
  final double maxLoad;
  final String description;
  final String imageUrl;
  final String? estimatedLenght; // Optional because it can be null
  final String estimatedWidth;
  final String estimatedHeight;
  final double price;
  final int? totalTrips; // Optional because it can be null

  TruckCategoryEntity({
    required this.id,
    required this.categoryName,
    required this.maxLoad,
    required this.description,
    required this.imageUrl,
    this.estimatedLenght,
    required this.estimatedWidth,
    required this.estimatedHeight,
    required this.price,
    this.totalTrips,
  });

  factory TruckCategoryEntity.fromMap(Map<String, dynamic> map) {
    return TruckCategoryEntity(
      id: map['id'] ?? 0, // Default to 0 if null
      categoryName:
          map['categoryName'] ?? '', // Default to empty string if null
      maxLoad: (map['maxLoad'] as num?)?.toDouble() ??
          0.0, // Ensure maxLoad is treated as double
      description: map['description'] ?? '', // Default to empty string if null
      imageUrl: map['imageUrl'] ?? '', // Default to empty string if null
      estimatedLenght:
          map['estimatedLenght'], // Nullable, leave it as is if null
      estimatedWidth:
          map['estimatedWidth'] ?? '', // Default to empty string if null
      estimatedHeight:
          map['estimatedHeight'] ?? '', // Default to empty string if null
      price: (map['price'] as num?)?.toDouble() ??
          0.0, // Ensure price is treated as double
      totalTrips: map['totalTrips'], // Handle null value explicitly
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'categoryName': categoryName,
      'maxLoad': maxLoad,
      'description': description,
      'imageUrl': imageUrl,
      'estimatedLenght': estimatedLenght,
      'estimatedWidth': estimatedWidth,
      'estimatedHeight': estimatedHeight,
      'price': price,
      'totalTrips': totalTrips,
    };
  }

  String toJson() => json.encode(toMap());

  @override
  String toString() {
    return 'TruckCategoryEntity(id: $id, categoryName: $categoryName, maxLoad: $maxLoad, description: $description, imageUrl: $imageUrl, estimatedLenght: $estimatedLenght, estimatedWidth: $estimatedWidth, estimatedHeight: $estimatedHeight, price: $price, totalTrips: $totalTrips)';
  }

  factory TruckCategoryEntity.fromJson(String source) =>
      TruckCategoryEntity.fromMap(json.decode(source));
}
