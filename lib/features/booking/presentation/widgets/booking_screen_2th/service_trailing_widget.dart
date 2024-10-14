import 'package:flutter/material.dart';
import 'package:movemate/utils/commons/widgets/form_input/label_text.dart';
import 'package:movemate/utils/constants/asset_constant.dart';

class ServiceTrailingWidget extends StatelessWidget {
  final int quantity;
  final int? quantityMax;
  final bool addService;
  final ValueChanged<int> onQuantityChanged;

  const ServiceTrailingWidget({
    super.key,
    required this.quantity,
    this.quantityMax,
    required this.addService,
    required this.onQuantityChanged,
  });

  @override
  Widget build(BuildContext context) {
    Widget trailingWidget;

    if (addService == false) {
      // Hiển thị nút cộng và trừ với số lượng
      trailingWidget = SizedBox(
        width: 120,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            // Nút trừ
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
            // Hiển thị số lượng
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
            // Nút cộng
            IconButton(
              icon: Icon(
                Icons.add_circle,
                color: (quantityMax == null || quantity < quantityMax!)
                    ? AssetsConstants.primaryDark
                    : AssetsConstants.greyColor,
              ),
              onPressed: (quantityMax == null || quantity < quantityMax!)
                  ? () => onQuantityChanged(quantity + 1)
                  : null, // Vô hiệu hóa nếu đạt đến quantityMax
            ),
          ],
        ),
      );
    } else if (addService == true && (quantity == 0)) {
      // Chỉ hiển thị nút thêm ban đầu
      trailingWidget = IconButton(
        icon: const Icon(Icons.add_circle, color: AssetsConstants.primaryDark),
        onPressed: () => onQuantityChanged(1),
      );
    } else if (addService == true && quantity > 0) {
      // Thay nút thêm bằng nút xóa
      trailingWidget = IconButton(
        icon: const Icon(Icons.remove_circle, color: AssetsConstants.greyColor),
        onPressed: () => onQuantityChanged(0),
      );
    } else {
      trailingWidget = Container();
    }

    return trailingWidget;
  }
}
