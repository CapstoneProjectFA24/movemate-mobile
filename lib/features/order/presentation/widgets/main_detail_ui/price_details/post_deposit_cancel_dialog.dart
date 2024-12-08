import 'package:flutter/material.dart';

class PostDepositCancelDialog extends StatelessWidget {
  final VoidCallback onConfirm;
  final VoidCallback onCancel;

  const PostDepositCancelDialog({
    super.key,
    required this.onConfirm,
    required this.onCancel,
  });

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: Colors.white,
      title: const Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            'Hủy đơn hàng',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.orange,
            ),
          ),
        ],
      ),
      content: const Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(height: 10),
          Text(
            'Vui lòng đọc kỹ thông tin cảnh báo bên dưới ',
          ),
          SizedBox(height: 20),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ListTile(
                subtitle: Text(
                  'Sau khi hủy, bạn không thể tiếp tục thanh toán cho đơn hàng nầy.Các thanh toán tương ứng cũng sẽ không còn hiệu lực.',
                  style: TextStyle(color: Colors.black),
                ),
              ),
              ListTile(
                subtitle: Text(
                  'Mã giảm giá đã áp dụng cho đơn hàng này sẽ tự động được thu hồi.',
                  style: TextStyle(color: Colors.black),
                ),
              ),
              ListTile(
                subtitle: Text(
                  'Bất kỳ khoản thanh toán nào chúng tôi nhận được cho đơn hàng này sẽ được hoàn trả dựa theo thời gian dọn nhà ',
                  style: TextStyle(color: Colors.black),
                ),
              ),
            ],
          ),
          SizedBox(height: 10),
          Text(
            'Bạn vẫn muốn hủy?',
            style: TextStyle(
              fontWeight: FontWeight.w300,
              color: Colors.black,
            ),
          ),
        ],
      ),
      actions: [
        FittedBox(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              TextButton(
                onPressed: onCancel,
                child: const Text(
                  'Không',
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.orange,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              TextButton(
                onPressed: onConfirm,
                style: TextButton.styleFrom(
                  side: BorderSide(
                    color: Colors.orangeAccent.shade200, // Light orange border
                    width: 1.5,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                ),
                child: const Text(
                  'Có, hủy đơn hàng',
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.orange,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
