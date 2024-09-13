import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:movemate/features/order/domain/models/order_models.dart';
import 'package:movemate/utils/commons/widgets/order_layout/driver_arrived_section.dart';
import 'package:movemate/utils/commons/widgets/order_layout/finding_driver_section.dart';
import 'package:movemate/utils/commons/widgets/order_layout/order_and_delivery_info.dart';
import 'package:movemate/utils/commons/widgets/order_layout/order_details_and_cancel.dart';
import 'package:movemate/utils/commons/widgets/order_layout/payment_info.dart';

class OrderScreen extends HookConsumerWidget {
  const OrderScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final animationController = useAnimationController(
      duration: const Duration(seconds: 3),
    )..repeat(reverse: true);

    const int count = 2;

    final fakeDriverInfo = OrderDriverArrivedSectionModels(
      driverImage: "assets/images/profile/Image.png",
      driverLicensePlate: "61-N1 162.32",
      driverName: "Hoàng Văn Huy",
      driverRating: "5.0",
    );

    final fakeOrderInfo = OrderAndDeliveryInfoModel(
      orderDetails: 'Đồ ăn | Bún Đậu Mắm Tôm Cu Tí - Ăn Vặt',
      deliveryAddress:
          '306 Huỳnh Văn Lũy, P. Phú Lợi, Thị xã Thủ Dầu Một, Bình Dương',
      receiverDetails: '236 Đường DX027, Phú Mỹ, Thủ Dầu Một, Bình Dương',
      userName: 'phương',
      numberPhone: '2369423874',
    );

    final fakePaymentInfo = PaymentInfoModel(
      paymentMethod: 'Trả qua tiền mặt',
      paymentAmount: '78.000 - 90.000đ',
      orderId: '544455',
      orderTime: '22/08/2024 | 15:15',
      distance: '10,2 km',
      vehicleType: 'Xe tải 1000kg',
    );

    final fakebuttoncancel = OrderDetailsAndCancelModel(
      isFindingDriver: true,
    );

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Chi tiết đơn hàng',
          style: TextStyle(color: Colors.black),
        ),
      ),
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(0.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (count == 1)
              FindingDriverSection(controller: animationController)
            else if (count == 2)
              DriverArrivedSection(driverArrive: fakeDriverInfo),
            const SizedBox(height: 16),
            OrderAndDeliveryInfo(infoModel: fakeOrderInfo),
            const SizedBox(height: 16),
            PaymentInfo(paymentInfo: fakePaymentInfo),
            const SizedBox(height: 16),
            if (count == 1)
              const OrderDetailsAndCancel(
                onCancelOrder: true, // Cancel order action
              ),
            if (count == 2)
              const OrderDetailsAndCancel(
                onCancelOrder: false, // Cancel order action
              ),
          ],
        ),
      ),
    );
  }
}
