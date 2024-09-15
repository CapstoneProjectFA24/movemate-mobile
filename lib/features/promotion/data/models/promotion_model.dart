import 'package:flutter/material.dart';

class PromotionModel {
  final String title;
  final String discount;
  final String description;
  final String code;
  final String imagePath;
  final Color bgcolor;

  final String? propromoPeriod;
  final String? minTransaction;
  final String? type;
  final String? destination;

  PromotionModel({
    required this.title,
    required this.discount,
    required this.description,
    required this.code,
    required this.imagePath,
    required this.bgcolor,
    required this.propromoPeriod,
    required this.minTransaction,
    required this.type,
    required this.destination,
  });
}
