import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';

@RoutePage()
class OrderInformation extends StatelessWidget {
  final Function(String) onOptionSelected;

  const OrderInformation({super.key, required this.onOptionSelected});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Text(
            'Loại review',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 20),
          ListTile(
            title: const Text('Đánh giá tại nhà'),
            trailing: const Text(
              'khuyến dùng',
              style: TextStyle(color: Colors.orange),
            ),
            onTap: () {
              onOptionSelected('Đánh giá tại nhà');
              Navigator.of(context).pop(); // Close modal
            },
          ),
          ListTile(
            title: const Text('Đánh giá online'),
            onTap: () {
              onOptionSelected('Đánh giá online');
              Navigator.of(context).pop(); // Close modal
            },
          ),
        ],
      ),
    );
  }
}

class OptionCard extends StatelessWidget {
  final String text;
  final String? highlightText;

  const OptionCard({super.key, required this.text, this.highlightText});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: Colors.white, // Set the background to white
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
            color:
                Colors.black.withOpacity(0.1), // Add a subtle shadow if needed
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            text,
            style: const TextStyle(fontSize: 16),
          ),
          if (highlightText != null)
            Text(
              highlightText!,
              style: const TextStyle(fontSize: 16, color: Colors.orange),
            ),
        ],
      ),
    );
  }
}
