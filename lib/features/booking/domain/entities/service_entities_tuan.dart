class ServiceTest {
  final String name;
  final String price;
  final int quantity;
  final String? icon;

  ServiceTest({
    required this.name,
    required this.price,
    this.quantity = 0,
    this.icon,
  });

  factory ServiceTest.fromJson(Map<String, dynamic> json) {
    return ServiceTest(
      name: json['subServicerName'] ?? json['serviceTitle'] ?? '',
      price: json['subServicerPrice'] ?? json['priceService'] ?? '0',
      quantity: json['quantity'] ?? 0,
      icon: json['icon'] ?? '',
    );
  }

  ServiceTest copyWith({
    String? name,
    String? price,
    int? quantity,
    String? icon,
  }) {
    return ServiceTest(
      name: name ?? this.name,
      price: price ?? this.price,
      quantity: quantity ?? this.quantity,
      icon: icon ?? this.icon,
    );
  }
}
