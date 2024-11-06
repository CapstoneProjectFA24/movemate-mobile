import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';

class RoundTripCheckbox extends StatelessWidget {
  final bool isRoundTrip;
  final ValueChanged<bool?> onChanged;

  const RoundTripCheckbox({
    super.key,
    required this.isRoundTrip,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(right: 30),
      child: Row(
        children: [
          FadeInLeft(
            child: Checkbox(
              value: isRoundTrip,
              onChanged: onChanged,
            ),
          ),
          FadeInLeft(child: const Text('Vận chuyển 2 chiều')),
          const Spacer(),
          FadeInRight(child: const Text('+70%')),
        ],
      ),
    );
  }
}