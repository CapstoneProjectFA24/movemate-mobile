// form_group.dart
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class FormGroup extends StatelessWidget {
  final String label;
  final Widget child;
  final IconData icon;

  const FormGroup({
    Key? key,
    required this.label,
    required this.child,
    required this.icon,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            color: Colors.grey,
            fontSize: 14,
          ),
        ),
        const SizedBox(height: 5),
        Stack(
          children: [
            child,
            Positioned(
              right: 10,
              top: 15,
              child: FaIcon(
                icon,
                color: Colors.grey,
                size: 16,
              ),
            ),
          ],
        ),
      ],
    );
  }
}
