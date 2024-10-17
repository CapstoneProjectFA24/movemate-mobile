import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:auto_route/auto_route.dart';
import 'package:http/http.dart' as http;
import 'package:movemate/services/payment_services/controllers/payment_controller.dart';
import 'package:movemate/utils/commons/widgets/loading_overlay.dart';
import 'dart:convert';
import 'package:url_launcher/url_launcher.dart';

final paymentMethodProvider = StateProvider<String>((ref) => 'Momo');

@RoutePage()
class TestPaymentScreen extends HookConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedMethod = ref.watch(paymentMethodProvider);
    final paymentController = ref.watch(paymentControllerProvider.notifier);
    final state = ref.watch(paymentControllerProvider);

    Future<void> handlePayment() async {
      await paymentController.createPaymentBooking(
        context: context,
        selectedMethod: selectedMethod,
        bookingId: "1", // replace with actual bookingId
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
              ListTile(
                title: const Text('Momo'),
                leading: Radio<String>(
                  value: 'Momo',
                  groupValue: selectedMethod,
                  onChanged: (value) =>
                      ref.read(paymentMethodProvider.notifier).state = value!,
                ),
              ),
              ListTile(
                title: const Text('VnPay'),
                leading: Radio<String>(
                  value: 'VnPay',
                  groupValue: selectedMethod,
                  onChanged: (value) =>
                      ref.read(paymentMethodProvider.notifier).state = value!,
                ),
              ),
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
