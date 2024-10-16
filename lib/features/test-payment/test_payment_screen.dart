import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:auto_route/auto_route.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:url_launcher/url_launcher.dart';

final paymentMethodProvider = StateProvider<String>((ref) => 'Momo');
final paymentStatusProvider = StateProvider<String>((ref) => 'pending');

@RoutePage()
class TestPaymentScreen extends HookConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedMethod = ref.watch(paymentMethodProvider);
    final paymentStatus = ref.watch(paymentStatusProvider);

    Future<void> initiatePayment() async {
      final url = Uri.parse(
          'https://api.movemate.info/api/v1/payments/create-payment-url');
      final queryParameters = {
        'bookingId': "1",
        'returnUrl': 'movemate://payment-result',
        'selectedMethod': selectedMethod,
      };

       final accessToken ='eyJhbGciOiJIUzUxMiIsInR5cCI6IkpXVCJ9.eyJzdWIiOiJqb2huZG9lQGV4YW1wbGUuY29tIiwiZW1haWwiOiJqb2huZG9lQGV4YW1wbGUuY29tIiwic2lkIjoiMSIsInJvbGUiOiIxIiwianRpIjoiZjhmYmFjMDQtM2ExNy00ZjE3LTgzNDEtNTBjZjUwMzFiNzI3IiwibmJmIjoxNzI5MTAwMjE1LCJleHAiOjIzMjkxMDAyMTUsImlhdCI6MTcyOTEwMDIxNX0.5gooLDxSgnTLncTypeGR49vXrlK2d1UkGQghh9G7ht9tOr4GJItA188FTs-zyzwfogII76ep5LO76xvuLMUBRg';


      try {
        final response = await http.post(
          url.replace(queryParameters: queryParameters),
          headers: {
            'Authorization': 'Bearer $accessToken',
          },
        );
        if (response.statusCode == 200) {
          final data = json.decode(response.body);
          if (data['isError'] == false && data['payload'] != null) {
            await launchUrl(Uri.parse(data['payload']),
                mode: LaunchMode.externalApplication);
          } else {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                  content: Text('Cannot create payment link')),
            );
          }
        } else {
          throw Exception('Failed to load payment URL');
        }
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: $e')),
        );
      }
    }

    return Scaffold(
      appBar: AppBar(title: Text('Payment')),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Select payment method:',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            ListTile(
              title: Text('Momo'),
              leading: Radio<String>(
                value: 'Momo',
                groupValue: selectedMethod,
                onChanged: (value) =>
                    ref.read(paymentMethodProvider.notifier).state = value!,
              ),
            ),
            ListTile(
              title: Text('VnPay'),
              leading: Radio<String>(
                value: 'VnPay',
                groupValue: selectedMethod,
                onChanged: (value) =>
                    ref.read(paymentMethodProvider.notifier).state = value!,
              ),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: initiatePayment,
              child: Text('Proceed to Payment'),
            ),
          ],
        ),
      ),
    );
  }
}