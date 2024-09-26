class Service {
  final String name;
  final String price;
  final int quantity;
  final String? icon;

  Service({
    required this.name,
    required this.price,
    this.quantity = 0,
    this.icon,
  });

  factory Service.fromJson(Map<String, dynamic> json) {
    return Service(
      name: json['subServicerName'] ?? json['serviceTitle'] ?? '',
      price: json['subServicerPrice'] ?? json['priceService'] ?? '0',
      quantity: json['quantity'] ?? 0,
      icon: json['icon'] ?? '',
    );
  }

  Service copyWith({
    String? name,
    String? price,
    int? quantity,
    String? icon,
  }) {
    return Service(
      name: name ?? this.name,
      price: price ?? this.price,
      quantity: quantity ?? this.quantity,
      icon: icon ?? this.icon,
    );
  }
}
