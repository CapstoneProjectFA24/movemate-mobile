import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:uni_links2/uni_links.dart';
import 'dart:async';

// Providers
final paymentProvider = StateNotifierProvider<PaymentNotifier, AsyncValue<void>>((ref) {
  return PaymentNotifier();
});

// Notifier
class PaymentNotifier extends StateNotifier<AsyncValue<void>> {
  PaymentNotifier() : super(const AsyncValue.data(null));

  Future<void> processPayment(String method, String orderId) async {
    state = const AsyncValue.loading();
    try {
      final response = await ApiService.postData(
        '/payment',
        {
          'method': method,
          'orderId': orderId,
        },
        queryParams: {'returnUrl': 'yourapp://paymentStatus'},
      );

      final url = response['paymentUrl'];
      if (await canLaunchUrl(Uri.parse(url))) {
        await launchUrl(Uri.parse(url));
        state = const AsyncValue.data(null);
      } else {
        throw 'Could not launch URL';
      }
    } catch (e, stack) {
      state = AsyncValue.error(e, stack);
    }
  }
}

// Screen
class PaymentScreen extends HookConsumerWidget {
  static const String routeName = '/payment';
  
  final String orderId;

  const PaymentScreen({required this.orderId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedMethod = useState('momo');
    final paymentState = ref.watch(paymentProvider);

    // Deep linking effect
    useEffect(() {
      StreamSubscription? subscription;
      
      Future<void> initUniLinks() async {
        subscription = uriLinkStream.listen((Uri? uri) {
          if (uri?.path.contains('paymentStatus') == true) {
            _checkPaymentStatus(context, orderId);
          }
        });
      }

      initUniLinks();
      return () => subscription?.cancel();
    }, []);

    // Payment status checking effect
    useEffect(() {
      Timer? timer;
      
      void startStatusCheck() {
        timer = Timer.periodic(
          const Duration(seconds: 3),
          (_) => _checkPaymentStatus(context, orderId),
        );
      }

      if (paymentState.isLoading) {
        startStatusCheck();
      }

      return () => timer?.cancel();
    }, [paymentState.isLoading]);

    return Scaffold(
      appBar: AppBar(title: const Text('Thanh toán')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _buildPaymentMethods(selectedMethod),
            const SizedBox(height: 24),
            _buildPaymentButton(context, ref, selectedMethod.value, paymentState),
          ],
        ),
      ),
    );
  }

  Widget _buildPaymentMethods(ValueNotifier<String> selectedMethod) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Chọn phương thức thanh toán:',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 16),
        _PaymentMethodCard(
          name: 'Momo',
          assetPath: 'assets/momo.png',
          isSelected: selectedMethod.value == 'momo',
          onTap: () => selectedMethod.value = 'momo',
        ),
        const SizedBox(height: 8),
        _PaymentMethodCard(
          name: 'VnPay',
          assetPath: 'assets/vnpay.png',
          isSelected: selectedMethod.value == 'vnpay',
          onTap: () => selectedMethod.value = 'vnpay',
        ),
      ],
    );
  }

  Widget _buildPaymentButton(
    BuildContext context,
    WidgetRef ref,
    String method,
    AsyncValue<void> paymentState,
  ) {
    return paymentState.when(
      data: (_) => ElevatedButton(
        onPressed: () => ref.read(paymentProvider.notifier).processPayment(method, orderId),
        child: const Text('Thanh toán'),
      ),
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (error, _) => Column(
        children: [
          Text('Lỗi: ${_getErrorMessage(error)}'),
          ElevatedButton(
            onPressed: () => ref.read(paymentProvider.notifier).processPayment(method, orderId),
            child: const Text('Thử lại'),
          ),
        ],
      ),
    );
  }
}

// Helper Widget
class _PaymentMethodCard extends StatelessWidget {
  final String name;
  final String assetPath;
  final bool isSelected;
  final VoidCallback onTap;

  const _PaymentMethodCard({
    required this.name,
    required this.assetPath,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: isSelected ? 4 : 1,
      child: InkWell(
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            border: isSelected ? Border.all(color: Colors.blue, width: 2) : null,
            borderRadius: BorderRadius.circular(4),
          ),
          child: Row(
            children: [
              Image.asset(assetPath, height: 40),
              const SizedBox(width: 16),
              Text(name, style: const TextStyle(fontSize: 16)),
              const Spacer(),
              if (isSelected) const Icon(Icons.check_circle, color: Colors.blue),
            ],
          ),
        ),
      ),
    );
  }
}

// Helper functions
void _checkPaymentStatus(BuildContext context, String orderId) async {
  try {
    final status = await ApiService.getData('/payment/$orderId/status');
    if (status['isPaid']) {
      Navigator.pushReplacementNamed(context, '/paymentSuccess', arguments: orderId);
    } else if (status['isFailed']) {
      Navigator.pushReplacementNamed(context, '/paymentFailure', arguments: orderId);
    }
  } catch (e) {
    debugPrint('Error checking payment status: $e');
  }
}

String _getErrorMessage(dynamic error) {
  if (error is ApiException) {
    switch (error.statusCode) {
      case 609:
      case 610:
      case 611:
        return 'Dịch vụ đã được đăng ký';
      case 614:
        return 'Dịch vụ đã hết lượt đăng ký';
      case 615:
        return 'Dịch vụ đã hết hạn đăng ký';
      default:
        return 'Lỗi không xác định';
    }
  }
  return 'Đã có lỗi xảy ra';
}

// Mock API Service
class ApiService {
  static Future<Map<String, dynamic>> postData(
    String endpoint,
    Map<String, dynamic> data, {
    Map<String, String>? queryParams,
  }) async {
    // Giả lập API call
    await Future.delayed(const Duration(seconds: 1));
    return {
      'paymentUrl': 'https://payment-gateway.com/pay',
      'message': 'Success',
    };
  }

  static Future<Map<String, dynamic>> getData(String endpoint) async {
    // Giả lập API call
    await Future.delayed(const Duration(seconds: 1));
    return {
      'isPaid': false,
      'isFailed': false,
    };
  }
}

class ApiException implements Exception {
  final int statusCode;
  final String message;

  ApiException(this.statusCode, this.message);
}