// lib/widgets/detail_column.dart

import 'package:flutter/material.dart';

Widget buildItem(
    {required String imageUrl,
    required String title,
    required String description}) {
  return Container(
    margin: const EdgeInsets.symmetric(vertical: 10),
    constraints: const BoxConstraints(maxWidth: 250),
    child: Row(
      children: [
        Flexible(
          child: Image.network(imageUrl, width: 60, height: 60),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
              const SizedBox(height: 4),
              Text(
                description,
                style: const TextStyle(color: Colors.grey),
                overflow: TextOverflow.ellipsis,
                maxLines: 2,
              ),
            ],
          ),
        ),
      ],
    ),
  );
}
