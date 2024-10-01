import 'package:flutter/material.dart';
import 'package:movemate/utils/constants/asset_constant.dart';

class SelectionModal extends StatelessWidget {
  final String title;
  final List<String> items;
  final ValueChanged<String> onItemSelected;

  const SelectionModal({
    super.key,
    required this.title,
    required this.items,
    required this.onItemSelected,
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
                itemCount: items.length,
                itemBuilder: (context, index) {
                  return ListTile(
                    title: Text(
                      items[index],
                      style: const TextStyle(color: AssetsConstants.blackColor),
                    ),
                    onTap: () {
                      onItemSelected(items[index]);
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
