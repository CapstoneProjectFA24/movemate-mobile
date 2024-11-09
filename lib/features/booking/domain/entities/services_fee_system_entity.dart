import 'dart:convert';

class ServicesFeeSystemEntity {
  final int id;
  final String name;
  final String? description;
  final double amount;
  final int? quantity;

  ServicesFeeSystemEntity({
    required this.id,
    required this.name,
    this.description,
    required this.amount,
    this.quantity,
  });

  // Factory method to create a ServicesFeeSystemEntity from a map
  factory ServicesFeeSystemEntity.fromMap(Map<String, dynamic> map) {
    return ServicesFeeSystemEntity(
      id: map['id'] ?? 0,
      name: map['name'] ?? '',
      description: map['description'], // Nullable field
      // amount: map['amount'] ?? 0,
      amount: (map['amount'] as num).toDouble(),
    );
  }

  // Convert an instance of ServicesFeeSystemEntity to a map
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'amount': amount,
    };
  }

  ServicesFeeSystemEntity copyWith({
    int? id,
    String? name,
    String? description,
    double? amount,
    int? quantity,
  }) {
    return ServicesFeeSystemEntity(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
      amount: amount ?? this.amount,
      quantity: quantity ?? this.quantity,
    );
  }

  // Serialize to JSON
  String toJson() => json.encode(toMap());

  // Deserialize from JSON
  factory ServicesFeeSystemEntity.fromJson(String source) =>
      ServicesFeeSystemEntity.fromMap(json.decode(source));
}
