import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:movemate/utils/constants/asset_constant.dart';

// AppBar tùy chỉnh
class CustomAppBarPayment extends HookConsumerWidget
    implements PreferredSizeWidget {
  const CustomAppBarPayment({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return AppBar(
      centerTitle: true,
      title: const Text(
        'Thanh toán',
        style: TextStyle(color: AssetsConstants.whiteColor),
      ),
      backgroundColor: AssetsConstants.primaryMain,
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
