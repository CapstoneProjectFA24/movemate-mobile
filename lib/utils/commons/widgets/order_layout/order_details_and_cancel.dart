import 'package:flutter/material.dart';
import 'package:movemate/features/order/domain/models/order_models.dart';
import 'package:movemate/utils/constants/asset_constant.dart';

class OrderDetailsAndCancel extends StatelessWidget {
  final bool onCancelOrder;

  const OrderDetailsAndCancel({
    super.key,
    required this.onCancelOrder,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      color: AssetsConstants.whiteColor,
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          children: [
            if (onCancelOrder)
              ElevatedButton(
                onPressed: () => {},
                style: ElevatedButton.styleFrom(
                  backgroundColor: AssetsConstants.warningColor,
                ),
                child: const Text('Hủy đặt xe'),
              ),
          ],
        ),
      ),
    );
  }
}
