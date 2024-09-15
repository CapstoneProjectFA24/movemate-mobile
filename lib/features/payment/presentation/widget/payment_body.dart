import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:movemate/features/payment/data/data_resource/payment_shared_preferences.dart';
import 'package:movemate/features/payment/data/models/payment_models.dart';
import 'vehicle_info.dart';
import 'payment_deadline.dart';
import 'payment_method.dart';
import 'coupon_input.dart';
import 'total_price.dart';
import 'complete_payment_button.dart';

class PaymentBody extends HookConsumerWidget {
  const PaymentBody({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final paymentAmount = useState<double>(1.0);
    final paymentMethod = useState<String>("MoMo");
    final couponCode = useState<String>("");

    useEffect(() {
      // Truy xuất dữ liệu từ SharedPreferences
      Future<void> loadPaymentData() async {
        paymentAmount.value = await PaymentSharedPreferences.getPaymentAmount();
        paymentMethod.value = await PaymentSharedPreferences.getPaymentMethod();
        couponCode.value = await PaymentSharedPreferences.getCouponCode();
      }

      loadPaymentData();
      return null;
    }, []);

    // Hàm lưu trữ dữ liệu vào SharedPreferences
    void savePaymentData() async {
      await PaymentSharedPreferences.setPaymentAmount(paymentAmount.value);
      await PaymentSharedPreferences.setPaymentMethod(paymentMethod.value);
      await PaymentSharedPreferences.setCouponCode(couponCode.value);
    }

    final fakeVehicleInfo = PaymentModelsVehicleInfo(
      struckName: "xe tải nhỏ",
      quantity: "12",
      date: "31/07/2024",
    );

    final fakeDeadline = PaymentModelsDeadline(
      hours: "00",
      minutes: "39",
      seconds: "11",
    );

    // Danh sách các phương thức thanh toán
    final List<PaymentModelsMethod> paymentMethods = [
      PaymentModelsMethod(
        methodName: 'MoMo',
        imageAssetPath: 'assets/images/logo_wallets/MoMo_Logo.png',
      ),
      PaymentModelsMethod(
        methodName: 'ZaloPay',
        imageAssetPath: 'assets/images/logo_wallets/zaloPay.png',
      ),
      PaymentModelsMethod(
        methodName: 'Visa',
        imageAssetPath: 'assets/images/logo_wallets/new_Card.png',
      ),
    ];

    // Tìm phương thức thanh toán hiện tại
    final selectedPaymentMethod = paymentMethods.firstWhere(
      (method) => method.methodName == paymentMethod.value,
      orElse: () => paymentMethods[0],
    );
    final fakeCoupon = PaymentModelsCoupon(
      couponHint:
          couponCode.value.isEmpty ? "Bạn có 7 mã coupons" : couponCode.value,
    );

    final fakeTotalPrice = PaymentModelsTotalPrice(
      totalPrice: paymentAmount.value.toString(),
    );

    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          VehicleInfo(paymentModelsVehicleInfo: fakeVehicleInfo),
          const SizedBox(height: 16),
          PaymentDeadline(paymentModelsDeadline: fakeDeadline),
          const SizedBox(height: 16),
          PaymentMethod(
            paymentModelsMethod: selectedPaymentMethod,
            paymentMethods: paymentMethods,
            onMethodChanged: (newMethod) {
              paymentMethod.value = newMethod;
              // Lưu phương thức mới vào SharedPreferences hoặc xử lý logic khác
            },
            onSeeAll: () {
              // Handle 'Xem tất cả' click event
              Navigator.pushNamed(
                  context, '/all-payment-methods'); // Example navigation
            },
          ),
          const SizedBox(height: 16),
          CouponInput(paymentModelsCoupon: fakeCoupon),
          const SizedBox(height: 16),
          TotalPrice(paymentModelsTotalPrice: fakeTotalPrice),
          const SizedBox(height: 16),
          const CompletePaymentButton(),
        ],
      ),
    );
  }
}
