import 'dart:convert';

class ServiceDetail {
  final int serviceId;
  final int quantity;

  ServiceDetail({
    required this.serviceId,
    required this.quantity,
  });

  Map<String, dynamic> toMap() {
    return {
      'serviceId': serviceId,
      'quantity': quantity,
    };
  }

  factory ServiceDetail.fromMap(Map<String, dynamic> map) {
    return ServiceDetail(
      serviceId: map['serviceId'] ?? 0,
      quantity: map['quantity'] ?? 1,
    );
  }

  String toJson() => json.encode(toMap());

  factory ServiceDetail.fromJson(String source) =>
      ServiceDetail.fromMap(json.decode(source));
}
