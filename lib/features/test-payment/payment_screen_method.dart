import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';

@RoutePage()
class PaymentScreenMethod extends StatelessWidget {
  const PaymentScreenMethod({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Container(
            constraints: const BoxConstraints(maxWidth: 400),
            margin: const EdgeInsets.symmetric(horizontal: 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Header
                Container(
                  padding: const EdgeInsets.symmetric(vertical: 15),
                  decoration: const BoxDecoration(
                    color: Color(0xFFFF7F00),
                  ),
                  child: const Text(
                    'Đặt cọc',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),

                // Details
                Container(
                  margin: const EdgeInsets.symmetric(vertical: 10),
                  child: const Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Xe tải nhỏ',
                        style: TextStyle(fontSize: 16, color: Colors.black87),
                      ),
                      Text(
                        'số lượng 1',
                        style: TextStyle(fontSize: 16, color: Colors.black87),
                      ),
                    ],
                  ),
                ),

                // Date
                Container(
                  margin: const EdgeInsets.only(bottom: 10),
                  child: const Text(
                    '31/07/2024',
                    style: TextStyle(fontSize: 16, color: Colors.black87),
                  ),
                ),

                // Payment Method Section
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Phương thức thanh toán',
                      style: TextStyle(fontSize: 16, color: Colors.black87),
                    ),
                    TextButton(
                      onPressed: () {},
                      child: const Text(
                        'Xem tất cả',
                        style: TextStyle(
                          color: Color(0xFFFF7F00),
                          fontSize: 14,
                        ),
                      ),
                    ),
                  ],
                ),

                // Payment Option
                Container(
                  margin: const EdgeInsets.symmetric(vertical: 10),
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey.shade300),
                    borderRadius: BorderRadius.circular(5),
                  ),
                  child: Row(
                    children: [
                      Image.network(
                        'https://storage.googleapis.com/a1aa/image/EvKuteb1nL1qFy7sLmipOsj94j9pY7MX5RSo2xyLvNRJKfnTA.jpg',
                        width: 40,
                        height: 40,
                      ),
                      const SizedBox(width: 10),
                      const Text(
                        'MoMo E-Wallet',
                        style: TextStyle(fontSize: 16),
                      ),
                      const Spacer(),
                      Radio(
                        value: true,
                        groupValue: true,
                        onChanged: (value) {},
                        activeColor: const Color(0xFFFF7F00),
                      ),
                    ],
                  ),
                ),

                // Coupon Section
                Row(
                  children: [
                    Expanded(
                      child: TextField(
                        decoration: InputDecoration(
                          hintText: 'Bạn có 7 mã coupons',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(5),
                          ),
                          contentPadding: const EdgeInsets.symmetric(
                            horizontal: 10,
                            vertical: 10,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 10),
                    OutlinedButton(
                      onPressed: () {},
                      style: OutlinedButton.styleFrom(
                        side: const BorderSide(color: Color(0xFFFF7F00)),
                        padding: const EdgeInsets.symmetric(
                          horizontal: 20,
                          vertical: 10,
                        ),
                      ),
                      child: const Text(
                        'Thêm',
                        style: TextStyle(color: Color(0xFFFF7F00)),
                      ),
                    ),
                  ],
                ),

                // Note
                Container(
                  margin: const EdgeInsets.symmetric(vertical: 10),
                  child: const Text(
                    'Để đảm bảo quá trình chuyển nhà được thực hiện, chúng tôi sẽ lấy phí đặt cọc dựa trên xe mà bạn chọn để sắp xếp xe đúng lịch hẹn và người review sẽ đến',
                    style: TextStyle(fontSize: 14, color: Colors.black87),
                  ),
                ),

                // Total
                Container(
                  padding: const EdgeInsets.symmetric(vertical: 10),
                  decoration: BoxDecoration(
                    border: Border(
                      top: BorderSide(
                          color: Colors.grey.shade300,
                          style: BorderStyle.solid),
                      bottom: BorderSide(
                          color: Colors.grey.shade300,
                          style: BorderStyle.solid),
                    ),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Tổng giá tiền',
                        style: TextStyle(fontSize: 16, color: Colors.black87),
                      ),
                      Row(
                        children: [
                          const Text(
                            '1.451.172 VND',
                            style:
                                TextStyle(fontSize: 16, color: Colors.black87),
                          ),
                          TextButton(
                            onPressed: () {},
                            child: const Text(
                              '▼',
                              style: TextStyle(color: Color(0xFFFF7F00)),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),

                // Complete Button
                Container(
                  margin: const EdgeInsets.only(top: 20),
                  child: ElevatedButton(
                    onPressed: () {},
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFFFF7F00),
                      padding: const EdgeInsets.symmetric(vertical: 15),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(5),
                      ),
                    ),
                    child: const Text(
                      'Hoàn tất thanh toán bằng MoMo E-Wallet',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
