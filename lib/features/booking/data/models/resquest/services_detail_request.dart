
class ServicesDetailRequest {
  final int id;
  final bool isQuantity;
  final int quantity;

  ServicesDetailRequest({
    required this.id,
    required this.isQuantity,
    required this.quantity,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'isQuantity': isQuantity,
      'quantity': quantity,
    };
  }

  factory ServicesDetailRequest.fromMap(Map<String, dynamic> map) {
    return ServicesDetailRequest(
      id: map['id']?.toInt() ?? 0,
      isQuantity: map['isQuantity'] ?? false,
      quantity: map['quantity']?.toInt() ?? 0,
    );
  }
}
