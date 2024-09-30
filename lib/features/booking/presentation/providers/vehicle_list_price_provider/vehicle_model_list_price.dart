import 'package:flutter/material.dart';

class VehicleModel {
  final String title;
  final String size;
  final String volume;
  final String basePrice;
  final String additionalPrice;
  final String longDistancePrice;
  final String imagePath;
  final Color bgColor;

  VehicleModel({
    required this.title,
    required this.size,
    required this.volume,
    required this.basePrice,
    required this.additionalPrice,
    required this.longDistancePrice,
    required this.imagePath,
    required this.bgColor,
  });
}
