import 'package:flutter/material.dart';
import 'package:movemate/utils/constants/asset_constant.dart';

class LocationPermissionDialog extends StatelessWidget {
  const LocationPermissionDialog({super.key});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Image.asset(
            'assets/location.png', // Đường dẫn đến hình ảnh của bạn
            width: 100,
            height: 100,
          ),
          const SizedBox(height: 16),
          const Text(
            'Chia sẻ vị trí của bạn',
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
          ),
          const SizedBox(height: 8),
          const Text(
            'Để tìm kiếm tài xế gần nhất, chúng tôi muốn biết vị trí hiện tại của bạn',
            textAlign: TextAlign.center,
            style: TextStyle(color: AssetsConstants.greyColor),
          ),
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: () {
              Navigator.of(context).pop(); // Đóng dialog khi nhấn
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AssetsConstants.red1,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            child: const Text(
              'Sử dụng vị trí hiện tại',
              style: TextStyle(color: AssetsConstants.whiteColor),
            ),
          ),
          const SizedBox(height: 8),
          TextButton(
            onPressed: () {
              Navigator.of(context).pop(); // Đóng dialog khi nhấn
            },
            child: const Text('Bỏ qua'),
          ),
        ],
      ),
    );
  }
}
