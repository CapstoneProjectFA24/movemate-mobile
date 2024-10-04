import 'package:movemate/features/booking/domain/entities/service_entities.dart';

class Package {
  final String title;
  final double packagePrice;
  final List<Service> services;

  Package({
    required this.title,
    required this.packagePrice,
    required this.services,
  });

  factory Package.fromJson(Map<String, dynamic> json) {
    List<Service> services = [];

    if (json.containsKey('subServices')) {
      services = (json['subServices'] as List<dynamic>)
          .map((e) => Service.fromJson(e))
          .toList();
    } else {
      services.add(Service.fromJson(json));
    }

    return Package(
      title: json['serviceTitle'] as String? ?? '',
      packagePrice:
          double.tryParse(json['packagePrice']?.toString() ?? '') ?? 0.0,
      services: services,
    );
  }

  Package copyWith({
    String? title,
    double? packagePrice,
    List<Service>? services,
  }) {
    return Package(
      title: title ?? this.title,
      packagePrice: packagePrice ?? this.packagePrice,
      services: services ?? this.services,
    );
  }
}
