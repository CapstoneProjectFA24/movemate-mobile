import 'package:flutter/material.dart';
import 'package:auto_route/auto_route.dart';
import 'package:movemate/utils/constants/asset_constant.dart';
import '../../../utils/commons/widgets/order_layout/order_layout.dart';

@RoutePage()
class OrderScreen extends StatelessWidget {
  const OrderScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildAppBar(),
      body: const OrderLayout(),
    );
  }

  // AppBar
  AppBar _buildAppBar() {
    return AppBar(
      title: const Text(
        'Thông tin đặt hàng',
        style: TextStyle(
          color: AssetsConstants.whiteColor,
          fontWeight: FontWeight.bold,
        ),
      ),
      backgroundColor: AssetsConstants.mainColor,
      elevation: 0,
      centerTitle: true,
    );
  }
}
