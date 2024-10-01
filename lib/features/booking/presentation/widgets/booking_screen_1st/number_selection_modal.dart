import 'package:flutter/material.dart';
import 'package:movemate/utils/constants/asset_constant.dart';

class NumberSelectionModal extends StatelessWidget {
  final String title;
  final int maxNumber;
  final ValueChanged<int> onNumberSelected;

  const NumberSelectionModal({
    super.key,
    required this.title,
    required this.maxNumber,
    required this.onNumberSelected,
  });

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      child: Container(
        height: 300,
        padding: const EdgeInsets.all(16.0),
        decoration: BoxDecoration(
          color: AssetsConstants.whiteColor,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const Divider(),
            Expanded(
              child: ListView.builder(
                itemCount: maxNumber,
                itemBuilder: (context, index) {
                  return ListTile(
                    title: Text(
                      (index + 1).toString(),
                      style: const TextStyle(color: AssetsConstants.blackColor),
                      textAlign: TextAlign.center,
                    ),
                    onTap: () {
                      onNumberSelected(index + 1);
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
