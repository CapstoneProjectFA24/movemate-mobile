import 'dart:convert';

class TruckEntities {
  final String categoryName;

  final int maxLoad;
  final String description;
  final String estimatedLength;
  final String estimatedWidth;
  final String estimatedHeight;
  final String summarize;

  TruckEntities({
    required this.categoryName,
    required this.maxLoad,
    required this.description,
    required this.estimatedLength,
    required this.estimatedWidth,
    required this.estimatedHeight,
    required this.summarize,
  });

  Map<String, dynamic> toMap() {
    final result = <String, dynamic>{};
    result.addAll({
      'categoryName': categoryName,
    });
    result.addAll({
      'maxLoad': maxLoad,
    });
    result.addAll({
      'description': description,
    });
    result.addAll({
      'estimatedLength': estimatedLength,
    });
    result.addAll({
      'estimatedWidth': estimatedWidth,
    });
    result.addAll({
      'estimatedHeight': estimatedHeight,
    });
    result.addAll({
      'summarize': summarize,
    });
    return result;
  }

  factory TruckEntities.fromMap(Map<String, dynamic> map) {
    return TruckEntities(
      categoryName: map['categoryName'] ?? '',
      maxLoad: map['maxLoad']?.toInt() ?? 0,
      description: map['description'] ?? '',
      estimatedLength: map['estimatedLength'] ?? '',
      estimatedWidth: map['estimatedWidth'] ?? '',
      estimatedHeight: map['estimatedHeight'] ?? '',
      summarize: map['summarize'] ?? '',
    );
  }
  String toJson() => json.encode(toMap());
  factory TruckEntities.fromJson(String source) => TruckEntities.fromMap(
        json.decode(source),
      );
}
