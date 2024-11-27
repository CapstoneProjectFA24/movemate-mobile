import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:movemate/configs/routes/app_router.dart';

import 'package:movemate/features/profile/domain/entities/wallet_entity.dart';
import 'package:movemate/features/profile/presentation/controllers/profile_controller/profile_controller.dart';
import 'package:movemate/hooks/use_fetch_obj.dart';
import 'package:movemate/utils/commons/widgets/loading_overlay.dart';
import 'package:movemate/utils/enums/payment_method_type.dart';

// Hàm hỗ trợ để định dạng giá
String formatPrice(int price) {
  final formatter = NumberFormat('#,###', 'vi_VN');
  return '${formatter.format(price)} đ';
}

// Hàm hỗ trợ để định dạng ngày tháng
String formatDate(DateTime date) {
  final formatter =
      DateFormat('dd-MM-yyyy'); // Định dạng ngày theo 'ngày-tháng-năm'
  return formatter.format(date);
}

// Hàm hỗ trợ để định dạng giờ
String formatTime(DateTime date) {
  final formatter =
      DateFormat('hh:mm:ss'); // Định dạng ngày theo 'ngày-tháng-năm'
  return formatter.format(date);
}

@RoutePage()
class TransactionResultScreenRechargeWallet extends HookConsumerWidget {
  final String allUri;
  final bool isSuccess;
  const TransactionResultScreenRechargeWallet({
    super.key,
    @PathParam('isSuccess') required this.isSuccess,
    @PathParam('') required this.allUri,
  });

  // Hàm phân tích allUri
  Map<String, dynamic> parseAllUri(String allUri) {
    String trimmed = allUri.trim();
    if (trimmed.startsWith('{') && trimmed.endsWith('}')) {
      trimmed = trimmed.substring(1, trimmed.length - 1);
    } else {
      throw const FormatException('Invalid format for allUri');
    }

    List<String> keyValuePairs = trimmed.split(', ');
    Map<String, dynamic> resultMap = {};

    for (String pair in keyValuePairs) {
      List<String> kv = pair.split(': ');
      if (kv.length != 2) continue;

      String key = kv[0].trim();
      String value = kv[1].trim();

      if (value.toLowerCase() == 'true') {
        resultMap[key] = true;
      } else if (value.toLowerCase() == 'false') {
        resultMap[key] = false;
      } else if (int.tryParse(value) != null) {
        resultMap[key] = int.parse(value);
      } else if (double.tryParse(value) != null) {
        resultMap[key] = double.parse(value);
      } else {
        resultMap[key] = value;
      }
    }

    return resultMap;
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    double containerWidth = MediaQuery.of(context).size.width * 0.9;
    double containerHeight = MediaQuery.of(context).size.height * 0.5;
    // print('allUri: $allUri');

//---//
    final stateWallet = ref.watch(profileControllerProvider);
    final useFetchResultWallet = useFetchObject<WalletEntity>(
      function: (context) async {
        print('check screen');
        return ref.read(profileControllerProvider.notifier).getWallet(context);
      },
      context: context,
    );
    final walletUser = useFetchResultWallet.isFetchingData
        ? 0
        : useFetchResultWallet.data?.balance ?? 0;
    final resultWallet = useFetchResultWallet.refresh;

// Phân tích allUri thành Map
    Map<String, dynamic> allUriMap;
    try {
      allUriMap = parseAllUri(allUri);
    } catch (e) {
      // Xử lý lỗi nếu định dạng allUri không hợp lệ
      allUriMap = {};
      print('Error parsing allUri: $e');
    }

    // Trích xuất các giá trị từ Map
    bool isSuccessParsed = allUriMap['isSuccess'] ?? false;
    int amount = allUriMap['amount'] ?? 0;
    String payDateStr = allUriMap['payDate'] ?? '';
    String bookingIdParsed = allUriMap['bookingId']?.toString() ?? '';
    String transactionCode = allUriMap['transactionCode']?.toString() ?? '';
    int userId = allUriMap['userId'] ?? 0;
    String paymentMethod = allUriMap['paymentMethod'] ?? '';

    // Phân tích và định dạng lại payDate
    DateTime payDate;
    try {
      payDate = DateFormat('MM/dd/yyyy HH:mm:ss').parse(payDateStr);
    } catch (e) {
      // Xử lý lỗi nếu định dạng payDate không hợp lệ
      payDate = DateTime.now(); // Giá trị mặc định
      print('Error parsing payDate: $e');
    }

    // Định dạng lại ngày và giờ
    String formattedDate = DateFormat('dd/MM/yyyy').format(payDate);
    String formattedTime = DateFormat('HH:mm:ss').format(payDate);

    // Chuyển đổi paymentMethod string thành enum
    PaymentMethodType? paymentMethodType =
        PaymentMethodType.fromString(paymentMethod);

    // Lấy imageUrl từ enum hoặc sử dụng hình ảnh mặc định
    String paymentImageUrl = paymentMethodType?.imageUrl ??
        'https://storage.googleapis.com/a1aa/image/EvKuteb1nL1qFy7sLmipOsj94j9pY7MX5RSo2xyLvNRJKfnTA.jpg'; // Hình ảnh mặc định

    // Lấy displayName từ enum hoặc sử dụng tên mặc định
    String paymentDisplayName = paymentMethodType?.displayName ?? paymentMethod;

    return LoadingOverlay(
      isLoading: stateWallet.isLoading,
      child: Scaffold(
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
                                  "Nạp tiền thành công",
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
                                        'Số tiền',
                                        formatPrice((amount).toInt()),
                                        containerWidth),
                                    const SizedBox(height: 8),
                                    buildTransactionDetailRow('Phí giao dịch',
                                        'Miễn phí', containerWidth),
                                  ],
                                ),
                              ),
                              // Đường kẻ nét đứt
                              Container(
                                margin:
                                    const EdgeInsets.symmetric(vertical: 16),
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
                                        transactionCode, containerWidth),
                                    const SizedBox(height: 8),
                                    buildTransactionDetailRow('Nguồn tiền',
                                        paymentDisplayName, containerWidth),
                                    const SizedBox(height: 8),
                                    buildTransactionDetailRow(
                                        'Thời gian giao dịch',
                                        formattedDate,
                                        containerWidth),
                                    buildTransactionDetailRow('', formattedTime,
                                        containerWidth * 0.89),
                                  ],
                                ),
                              ),
                              // const SizedBox(height: 24),
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
                                        'https://res.cloudinary.com/dkpnkjnxs/image/upload/v1731511719/movemate_logo_e6f1lk.png'),
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              ),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'Số dư ví MoveMate',
                                      style: TextStyle(
                                        fontSize: containerWidth * 0.045,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    Text(
                                      formatPrice(walletUser.toInt()),
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
                                resultWallet();

                                final tabsRouter = context.router.root
                                    .innerRouterOf<TabsRouter>(
                                        TabViewScreenRoute.name);
                                if (tabsRouter != null) {
                                  tabsRouter.setActiveIndex(0);
                                  context.router.popUntilRouteWithName(
                                      TabViewScreenRoute.name);
                                } else {
                                  context.router.pushAndPopUntil(
                                    const TabViewScreenRoute(children: [
                                      HomeScreenRoute(),
                                    ]),
                                    predicate: (route) => false,
                                  );
                                }
                              },
                              // Example of a button to navigate to the Home tab
                              // Navigating to Home screen within TabViewScreen

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
                                  fontSize: containerWidth * 0.040,
                                ),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 16),
                      ],
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
