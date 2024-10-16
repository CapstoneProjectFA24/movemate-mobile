import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:auto_route/auto_route.dart';

@RoutePage()
class PaymentResultScreen extends HookConsumerWidget {
  final bool isSuccess;

  const PaymentResultScreen(
      {Key? key, @PathParam('isSuccess') required this.isSuccess})
      : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        title: Text(isSuccess ? 'Payment Successful' : 'Payment Failed'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              isSuccess ? Icons.check_circle : Icons.error,
              size: 100,
              color: isSuccess ? Colors.green : Colors.red,
            ),
            SizedBox(height: 20),
            Text(
              isSuccess ? 'Thanh toán thành công!' : 'Thanh toán thất bại',
              style: TextStyle(fontSize: 18),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () => context.router.popUntilRoot(),
              child: Text('Trở về trang chủ'),
            ),
          ],
        ),
      ),
    );
  }
}
