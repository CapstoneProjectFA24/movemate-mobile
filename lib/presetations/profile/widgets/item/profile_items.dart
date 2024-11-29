import 'package:flutter/material.dart';

class ProfileItem {
  final IconData icon;
  final String title;
  final Color color;

  ProfileItem({
    required this.icon,
    required this.title,
    this.color = Colors.black, // Mặc định là màu đen
  });
}
