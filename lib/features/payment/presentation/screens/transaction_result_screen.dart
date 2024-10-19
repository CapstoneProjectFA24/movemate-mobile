import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:movemate/configs/routes/app_router.dart';

@RoutePage()
class TransactionResultScreen extends ConsumerWidget {
  const TransactionResultScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    double containerWidth = MediaQuery.of(context).size.width * 0.9;
    double containerHeight = MediaQuery.of(context).size.height * 0.5;

    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.orange.shade400, Colors.orange.shade500],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              Expanded(
                child: Center(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      // Container chính
                      Container(
                        width: containerWidth,
                        height: containerHeight,
                        margin: const EdgeInsets.all(24),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(16),
                          boxShadow: const [
                            BoxShadow(
                              color: Colors.black12,
                              blurRadius: 10,
                              spreadRadius: 2,
                            ),
                          ],
                        ),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const SizedBox(height: 24),
                            // Biểu tượng thành công
                            Container(
                              margin: const EdgeInsets.only(bottom: 16),
                              padding: const EdgeInsets.all(16),
                              decoration: BoxDecoration(
                                color: Colors.blue.shade100,
                                shape: BoxShape.circle,
                              ),
                              child: Icon(
                                Icons.check,
                                color: Colors.orange.shade500,
                                size: containerWidth *
                                    0.1, // Tăng kích thước icon dựa trên chiều rộng container
                              ),
                            ),
                            // Tiêu đề
                            Container(
                              margin: const EdgeInsets.only(bottom: 16),
                              child: Text(
                                'Đặt cọc thành công',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  color: Colors.orange.shade500,
                                  fontWeight: FontWeight.bold,
                                  fontSize: containerWidth *
                                      0.06, // Điều chỉnh kích thước phông chữ theo chiều rộng container
                                ),
                              ),
                            ),
                            // Thông tin giao dịch
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 24),
                              child: Column(
                                children: [
                                  buildTransactionDetailRow(
                                      'Số tiền', '420.000đ', containerWidth),
                                  const SizedBox(height: 8),
                                  buildTransactionDetailRow('Phí giao dịch',
                                      'Miễn phí', containerWidth),
                                ],
                              ),
                            ),
                            // Đường kẻ nét đứt
                            Container(
                              margin: const EdgeInsets.symmetric(vertical: 16),
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 24),
                              child: DashedLine(color: Colors.grey.shade300),
                            ),
                            // Chi tiết mã giao dịch
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 24),
                              child: Column(
                                children: [
                                  buildTransactionDetailRow('Mã giao dịch',
                                      '20201118181445', containerWidth),
                                  const SizedBox(height: 8),
                                  buildTransactionDetailRow('Nguồn tiền',
                                      'Sacombank', containerWidth),
                                  const SizedBox(height: 8),
                                  buildTransactionDetailRow(
                                      'Thời gian giao dịch',
                                      '21:15 - 18/05/2024',
                                      containerWidth),
                                ],
                              ),
                            ),
                            const SizedBox(height: 24),
                          ],
                        ),
                      ),
                      // Thông tin số dư ví - Đặt bên dưới container chính
                      Container(
                        width: containerWidth,
                        margin: const EdgeInsets.symmetric(horizontal: 24),
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: Colors.grey.shade100,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Row(
                          children: [
                            Container(
                              width: 40,
                              height: 40,
                              margin: const EdgeInsets.only(right: 8),
                              decoration: const BoxDecoration(
                                shape: BoxShape.circle,
                                image: DecorationImage(
                                  image: NetworkImage(
                                      'https://storage.googleapis.com/a1aa/image/EvKuteb1nL1qFy7sLmipOsj94j9pY7MX5RSo2xyLvNRJKfnTA.jpg'),
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Số dư ví Ontop Bank',
                                    style: TextStyle(
                                      fontSize: containerWidth * 0.045,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  Text(
                                    '958.000đ',
                                    style: TextStyle(
                                      fontSize: containerWidth * 0.045,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 24),
                    ],
                  ),
                ),
              ),
              // Buttons container at bottom
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.orange.shade500,
                ),
                child: SafeArea(
                  top: false,
                  child: Row(
                    children: [
                      Expanded(
                        child: SizedBox(
                          height: 48,
                          child: ElevatedButton(
                            onPressed: () {
                              context.router
                                  .replace(const TabViewScreenRoute());
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.white,
                              side: const BorderSide(color: Colors.white),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                            ),
                            child: Text(
                              'Màn hình chính',
                              style: TextStyle(
                                color: Colors.orange.shade500,
                                fontWeight: FontWeight.bold,
                                fontSize: containerWidth * 0.045,
                              ),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: SizedBox(
                          height: 48,
                          child: ElevatedButton(
                            onPressed: () {
                              // context.router.replace( OrderDetailsScreenRoute( orderId: "20201118181445"));
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.orange.shade800,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                            ),
                            child: Text(
                              'Chi tiết đơn hàng',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: containerWidth * 0.045,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildTransactionDetailRow(
      String title, String value, double containerWidth) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style: TextStyle(fontSize: containerWidth * 0.045),
        ),
        Text(
          value,
          style: TextStyle(
            fontSize: containerWidth * 0.045,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }
}

class DashedLine extends StatelessWidget {
  final Color color;

  const DashedLine({super.key, required this.color});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, constraints) {
      const dashWidth = 5.0;
      const dashSpace = 5.0;
      final dashCount =
          (constraints.constrainWidth() / (dashWidth + dashSpace)).floor();
      return Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: List.generate(dashCount, (_) {
          return SizedBox(
            width: dashWidth,
            height: 1,
            child: DecoratedBox(
              decoration: BoxDecoration(color: color),
            ),
          );
        }),
      );
    });
  }
}
