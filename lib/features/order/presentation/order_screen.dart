
import 'package:flutter/material.dart';

import 'package:auto_route/auto_route.dart';

@RoutePage()
class OrderScreen extends StatelessWidget {
  const OrderScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('OrderScreen Screen'),
      ),
      body: const Center(
        child: Text('Welcome to Order Screen!'),
      ),
    );
  }
}
