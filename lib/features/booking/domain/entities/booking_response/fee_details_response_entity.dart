class FeeDetailsResponseEntity {
  final int id;
  final int bookingId;
  final int feeSettingId;
  final String name;
  final String description;
  final int amount;
  final String? quantity;

  FeeDetailsResponseEntity({
    required this.id,
    required this.bookingId,
    required this.feeSettingId,
    required this.name,
    required this.description,
    required this.amount,
    this.quantity,
  });

  factory FeeDetailsResponseEntity.fromMap(Map<String, dynamic> json) {
    return FeeDetailsResponseEntity(
      id: json['id'] ?? 0,
      bookingId: json['bookingId'] ?? 0,
      feeSettingId: json['feeSettingId'] ?? 0,
      name: json['name'] ?? '',
      description: json['description'] ?? '',
      amount: json['amount'] ?? 0,
      quantity: json['quantity']?.toString(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'bookingId': bookingId,
      'feeSettingId': feeSettingId,
      'name': name,
      'description': description,
      'amount': amount,
      'quantity': quantity,
    };
  }

  Map<String, dynamic> toJson() {
    return toMap();
  }
}
