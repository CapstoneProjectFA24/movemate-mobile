// vehicle_model.dart

class Vehicle {
  final String categoryName;
  final int maxLoad;
  final String description;
  final String imgUrl;
  final String estimatedLength;
  final String estimatedWidth;
  final String estimatedHeight;
  final String summarize;
  final double price;

  Vehicle({
    required this.categoryName,
    required this.maxLoad,
    required this.description,
    required this.imgUrl,
    required this.estimatedLength,
    required this.estimatedWidth,
    required this.estimatedHeight,
    required this.summarize,
    required this.price,
  });

  factory Vehicle.fromJson(Map<String, dynamic> json) {
    return Vehicle(
      categoryName: json['categoryName'],
      maxLoad: json['maxLoad'],
      description: json['description'],
      imgUrl: json['imgUrl'],
      estimatedLength: json['estimatedLength'],
      estimatedWidth: json['estimatedWidth'],
      estimatedHeight: json['estimatedHeight'],
      summarize: json['summarize'],
      price: (json['price'] as num).toDouble(),
    );
  }
}
