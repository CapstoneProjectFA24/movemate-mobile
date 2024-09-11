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
    return Row(
      children: [
        Checkbox(
          value: isRoundTrip,
          onChanged: onChanged,
        ),
        const Text('Vận chuyển 2 chiều'),
        const Spacer(),
        const Text('+70%'),
      ],
    );
  }
}
