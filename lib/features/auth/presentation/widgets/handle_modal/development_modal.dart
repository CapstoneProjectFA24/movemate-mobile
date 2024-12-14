// development_modal.dart
import 'package:flutter/material.dart';
import 'package:icons_plus/icons_plus.dart';

class DevelopmentModal extends StatelessWidget {
  final String description;

  const DevelopmentModal({super.key, required this.description});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      // Tùy chỉnh giao diện modal
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.0)),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(
            Icons.construction, // Bạn có thể thay đổi icon tùy ý
            size: 60,
            color: Colors.orange,
          ),
          const SizedBox(height: 20),
          const Text(
            'Phương thức đang phát triển',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 10),
          Text(
            description,
            style: const TextStyle(
              fontSize: 16,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.of(context).pop(); // Đóng modal
          },
          child: const Text('Xác nhận'),
        ),
      ],
    );
  }
}
