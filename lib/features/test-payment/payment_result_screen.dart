import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:auto_route/auto_route.dart';

@RoutePage()
class PaymentResultScreen extends HookConsumerWidget {
  final bool isSuccess;

  const PaymentResultScreen({
    super.key,
    @PathParam('isSuccess') required this.isSuccess,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final content = isSuccess
        ? {
            'title': 'Thanh toán thành công',
            'heading': 'Cảm ơn bạn!',
            'message':
                'Thanh toán của bạn đã được xác nhận. Vui lòng quay lại ứng dụng để tiếp tục.',
            'gifPath': 'assets/images/payment_status/payment_success.gif',
          }
        : {
            'title': 'Thanh toán thất bại',
            'heading': 'Đã xảy ra lỗi!',
            'message':
                'Rất tiếc, thanh toán của bạn không thành công. Vui lòng thử lại hoặc quay lại ứng dụng.',
            'gifPath': 'assets/images/payment_status/payment_fail.gif',
          };

    return Scaffold(
      appBar: AppBar(
        title: Text(content['title']!),
      ),
      body: Center(
        child: Card(
          margin: const EdgeInsets.all(16),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                SizedBox(
                  width: 120,
                  height: 120,
                  child: Image.asset(
                    content['gifPath']!,
                    fit: BoxFit.contain,
                  ),
                ),
                const SizedBox(height: 24),
                Text(
                  content['heading']!,
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: isSuccess ? Colors.green : Colors.red,
                      ),
                ),
                const SizedBox(height: 16),
                Text(
                  content['message']!,
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.bodyLarge,
                ),
                const SizedBox(height: 24),
                ElevatedButton(
                  onPressed: () => context.router.popUntilRoot(),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: isSuccess ? Colors.green : Colors.red,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 24,
                      vertical: 12,
                    ),
                  ),
                  child: const Text('Quay lại trang chủ'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
