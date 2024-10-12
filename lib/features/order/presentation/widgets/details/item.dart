// lib/widgets/detail_column.dart

import 'package:flutter/material.dart';

Widget buildItem(
    {required String imageUrl,
    required String title,
    required String description}) {
  return Container(
    margin: const EdgeInsets.symmetric(vertical: 10),
    child: Row(
      children: [
        Image.network(imageUrl, width: 80, height: 80),
        const SizedBox(width: 10),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
              Text(description, style: const TextStyle(color: Colors.grey)),
            ],
          ),
        ),
      ],
    ),
  );
}
