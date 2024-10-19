import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:auto_route/auto_route.dart';
import 'package:movemate/services/payment_services/controllers/payment_controller.dart';
import 'package:movemate/utils/commons/widgets/loading_overlay.dart';
import 'package:movemate/utils/enums/enums_export.dart';

final paymentMethodProvider =
    StateProvider<PaymentMethodType>((ref) => PaymentMethodType.momo);

// List of available payment methods
final paymentList = [
  PaymentMethodType.momo,
  PaymentMethodType.vnpay,
  PaymentMethodType.payos,
];

@RoutePage()
class TestPaymentScreen extends HookConsumerWidget {
  const TestPaymentScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedMethod = ref.watch(paymentMethodProvider);
    final paymentController = ref.watch(paymentControllerProvider.notifier);
    final state = ref.watch(paymentControllerProvider);

    print('list Payment Methods: ${paymentList.map((method) => method.type).toList()}');
    print('Selected Payment Method: ${selectedMethod.type}');

    Future<void> handlePayment() async {
      await paymentController.createPaymentBooking(
        context: context,
        selectedMethod: selectedMethod.type,
        bookingId: "52", // replace with actual bookingId
      );
    }

    return LoadingOverlay(
      isLoading: state.isLoading,
      child: Scaffold(
        appBar: AppBar(title: const Text('Payment')),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Select payment method:',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              // Dynamically generate payment method list using map
              ...paymentList.map((method) => ListTile(
                    title: Text(method.type),
                    leading: Radio<PaymentMethodType>(
                      value: method,
                      groupValue: selectedMethod,
                      onChanged: (value) => ref
                          .read(paymentMethodProvider.notifier)
                          .state = value!,
                    ),
                  )),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: handlePayment,
                child: const Text('Proceed to Payment'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
