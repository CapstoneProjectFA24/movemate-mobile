import 'package:flutter/material.dart';

class IncomeItem {
  final String title;
  final double amount;
  final double percentage;
  final Color color;

  const IncomeItem({
    required this.title,
    required this.amount,
    required this.percentage,
    required this.color,
  });
}
