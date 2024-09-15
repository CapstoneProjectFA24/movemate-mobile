import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:movemate/features/payment/presentation/widget/custom_app_bar.dart';
import 'package:movemate/features/payment/presentation/widget/payment_body.dart';

// Import các component

@RoutePage()
class PaymentScreen extends HookConsumerWidget {
  const PaymentScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return const Scaffold(
      appBar: CustomAppBarPayment(),
      body: PaymentBody(),
    );
  }
}
