import 'package:flutter/material.dart';

class Promotion {
  final String title;
  final String discount;
  final String description;
  final String code;
  final String imagePath;
  final Color bgcolor;
  final String promoPeriod;
  final String minTransaction;
  final String type;
  final String destination;

  Promotion({
    required this.title,
    required this.discount,
    required this.description,
    required this.code,
    required this.imagePath,
    required this.bgcolor,
    required this.promoPeriod,
    required this.minTransaction,
    required this.type,
    required this.destination,
  });
}
