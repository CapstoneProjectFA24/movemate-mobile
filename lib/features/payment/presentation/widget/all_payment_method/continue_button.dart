import 'package:flutter/material.dart';
import 'package:movemate/utils/constants/asset_constant.dart';

class ContinueButton extends StatelessWidget {
  const ContinueButton({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: SizedBox(
        width: double.infinity,
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(
            padding: const EdgeInsets.all(16),
            backgroundColor: AssetsConstants.primaryLight,
          ),
          onPressed: () {
            Navigator.pop(context); // Close the modal when pressed
          },
          child: const Text(
            'Tiếp tục',
            style: TextStyle(
              fontSize: 16,
              color: AssetsConstants.whiteColor,
            ),
          ),
        ),
      ),
    );
  }
}
