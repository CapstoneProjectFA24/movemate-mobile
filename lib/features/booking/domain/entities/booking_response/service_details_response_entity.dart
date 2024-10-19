class ServiceDetailsResponseEntity {
  final int id;
  final int serviceId;
  final int bookingId;
  final int quantity;
  final String? price;
  final String? isQuantity;
  final String? description;

  ServiceDetailsResponseEntity({
    required this.id,
    required this.serviceId,
    required this.bookingId,
    required this.quantity,
    this.price,
    this.isQuantity,
    this.description,
  });

  factory ServiceDetailsResponseEntity.fromMap(Map<String, dynamic> json) {
    return ServiceDetailsResponseEntity(
      id: json['id'] ?? 0,
      serviceId: json['serviceId'] ?? 0,
      bookingId: json['bookingId'] ?? 0,
      quantity: json['quantity'] ?? 0,
      price: json['price']?.toString(),
      isQuantity: json['isQuantity']?.toString(),
      description: json['description'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'serviceId': serviceId,
      'bookingId': bookingId,
      'quantity': quantity,
      'price': price,
      'isQuantity': isQuantity,
      'description': description,
    };
  }

  Map<String, dynamic> toJson() {
    return toMap();
  }
}
