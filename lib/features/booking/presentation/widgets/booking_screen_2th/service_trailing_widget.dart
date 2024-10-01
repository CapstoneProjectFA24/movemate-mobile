import 'package:flutter/material.dart';
import 'package:movemate/utils/commons/widgets/form_input/label_text.dart';
import 'package:movemate/utils/constants/asset_constant.dart';

class ServiceTrailingWidget extends StatelessWidget {
  final int quantity;
  final bool addService;
  final ValueChanged<int> onQuantityChanged;

  const ServiceTrailingWidget({
    super.key,
    required this.quantity,
    required this.addService,
    required this.onQuantityChanged,
  });

  @override
  Widget build(BuildContext context) {
    Widget trailingWidget;

    if (addService == false) {
      // **Condition 1**: Display plus and minus buttons with quantity
      trailingWidget = SizedBox(
        width: 120, // Adjust as needed
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            // Minus button
            Visibility(
              visible: quantity > 0,
              maintainSize: true,
              maintainAnimation: true,
              maintainState: true,
              child: IconButton(
                icon: const Icon(Icons.remove_circle,
                    color: AssetsConstants.greyColor),
                onPressed: () => onQuantityChanged(quantity - 1),
              ),
            ),
            // Quantity Text
            Visibility(
              visible: quantity > 0,
              maintainSize: true,
              maintainAnimation: true,
              maintainState: true,
              child: LabelText(
                content: quantity.toString(),
                size: 16,
                fontWeight: FontWeight.w500,
              ),
            ),
            // Plus button
            IconButton(
              icon: const Icon(Icons.add_circle,
                  color: AssetsConstants.primaryDark),
              onPressed: () => onQuantityChanged(quantity + 1),
            ),
          ],
        ),
      );
    } else if (addService == true && (quantity == 0)) {
      // **Condition 2**: Only show plus button initially
      trailingWidget = IconButton(
        icon: const Icon(Icons.add_circle, color: AssetsConstants.primaryDark),
        onPressed: () => onQuantityChanged(1),
      );
    } else if (addService == true && quantity > 0) {
      // **Condition 2 Continued**: Replace plus with minus button
      trailingWidget = IconButton(
        icon: const Icon(Icons.remove_circle, color: AssetsConstants.greyColor),
        onPressed: () => onQuantityChanged(0),
      );
    } else {
      // Default case: show nothing
      trailingWidget = Container();
    }

    return trailingWidget;
  }
}
