import 'dart:convert';

class TruckCategoriesEntity {
  final int id;
  final String categoryName;
  final int maxLoad;
  final String description;
  final String imageUrl;
  final String estimatedLength;
  final String estimatedWidth;
  final String estimatedHeight;
  final String summarize;
  final int price;
  final int totalTrips;

  TruckCategoriesEntity({
    required this.id,
    required this.categoryName,
    required this.maxLoad,
    required this.description,
    required this.imageUrl,
    required this.estimatedLength,
    required this.estimatedWidth,
    required this.estimatedHeight,
    required this.summarize,
    required this.price,
    required this.totalTrips,
  });

  factory TruckCategoriesEntity.fromMap(Map<String, dynamic> map) {
    return TruckCategoriesEntity(
      id: map['id'] ?? 0,
      categoryName: map['categoryName'] ?? '',
      maxLoad: map['maxLoad'] ?? 0,
      description: map['description'] ?? '',
      imageUrl: map['imageUrl'] ?? '',
      estimatedLength: map['estimatedLength'] ?? '',
      estimatedWidth: map['estimatedWidth'] ?? '',
      estimatedHeight: map['estimatedHeight'] ?? '',
      summarize: map['summarize'] ?? '',
      price: map['price'] ?? 0,
      totalTrips: map['totalTrips'] ?? 0,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'categoryName': categoryName,
      'maxLoad': maxLoad,
      'description': description,
      'imageUrl': imageUrl,
      'estimatedLength': estimatedLength,
      'estimatedWidth': estimatedWidth,
      'estimatedHeight': estimatedHeight,
      'summarize': summarize,
      'price': price,
      'totalTrips': totalTrips,
    };
  }

  String toJson() => json.encode(toMap());
  @override
  String toString() {
    return 'TruckCategoriesEntity(id: $id, categoryName: $categoryName, maxLoad: $maxLoad, description: $description, imageUrl: $imageUrl, summarize: $summarize, estimatedLength: $estimatedLength, estimatedWidth: $estimatedWidth, estimatedHeight: $estimatedHeight, price: $price, totalTrips: $totalTrips)';
  }

  factory TruckCategoriesEntity.fromJson(String source) =>
      TruckCategoriesEntity.fromMap(json.decode(source));
}
