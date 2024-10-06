import 'package:movemate/features/booking/domain/entities/service_entities_tuan.dart';

class Package {
  final String title;
  final double packagePrice;
  final List<ServiceTest> services;

  Package({
    required this.title,
    required this.packagePrice,
    required this.services,
  });

  factory Package.fromJson(Map<String, dynamic> json) {
    List<ServiceTest> services = [];

    if (json.containsKey('subServices')) {
      services = (json['subServices'] as List<dynamic>)
          .map((e) => ServiceTest.fromJson(e))
          .toList();
    } else {
      services.add(ServiceTest.fromJson(json));
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
    List<ServiceTest>? services,
  }) {
    return Package(
      title: title ?? this.title,
      packagePrice: packagePrice ?? this.packagePrice,
      services: services ?? this.services,
    );
  }
}
