import 'dart:convert';

class ServiceDetail {
  final int id;
  final bool isQuantity;
  final int quantity;

  ServiceDetail({
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

  factory ServiceDetail.fromMap(Map<String, dynamic> map) {
    return ServiceDetail(
      id: map['id'] ?? 0,
      isQuantity: map['isQuantity'] ?? false,
      quantity: map['quantity'] ?? 1,
    );
  }

  String toJson() => json.encode(toMap());

  factory ServiceDetail.fromJson(String source) =>
      ServiceDetail.fromMap(json.decode(source));
}
