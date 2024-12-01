import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:movemate/configs/routes/app_router.dart';
import 'package:intl/intl.dart';
import 'package:movemate/features/booking/domain/entities/booking_response/booking_detail_response_entity.dart';
import 'package:movemate/features/booking/presentation/screens/controller/booking_controller.dart';
import 'package:movemate/features/order/domain/entites/order_entity.dart';
import 'package:movemate/hooks/use_fetch_obj.dart';
import 'package:movemate/utils/enums/enums_export.dart';
import 'package:movemate/utils/providers/common_provider.dart';

// Hàm hỗ trợ để định dạng giá
String formatPrice(int price) {
  final formatter = NumberFormat('#,###', 'vi_VN');
  return '${formatter.format(price)} đ';
}

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

final paymentList = [
  PaymentMethodType.momo,
  PaymentMethodType.vnpay,
  PaymentMethodType.payos,
];

@RoutePage()
class LastTransactionResultScreen extends HookConsumerWidget {
  final String bookingId;
  final bool isSuccess;
  final String allUri;

  const LastTransactionResultScreen({
    super.key,
    @PathParam('isSuccess') required this.isSuccess,
    @PathParam('bookingId') required this.bookingId,
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

    print('allUri: $allUri');

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
    final state = ref.watch(bookingControllerProvider);
    final useFetchResultOrder = useFetchObject<OrderEntity>(
      function: (context) async {
        return ref
            .read(bookingControllerProvider.notifier)
            .getOrderEntityById(int.parse(bookingId));
      },
      context: context,
    );
    final result = useFetchResultOrder.data;

    final user = ref.read(authProvider);

    List<BookingDetailResponseEntity> getListSerVices(OrderEntity? order) {
      try {
        final listServicesDetails =
            order!.bookingDetails.where((e) => e.quantity > 0).toList();
        return listServicesDetails;
      } catch (e) {
        print('Error: $e');
        return [];
      }
    }

    final listServices = getListSerVices(result);
    double containerHeight =
        MediaQuery.of(context).size.height * (listServices.length * 0.120);
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
                                    0.1, // Tăng kích thước icon
                              ),
                            ),
                            // Tiêu đề
                            Container(
                              margin: const EdgeInsets.only(bottom: 16),
                              child: Text(
                                'Thanh toán thành công',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  color: Colors.orange.shade500,
                                  fontWeight: FontWeight.bold,
                                  fontSize: containerWidth * 0.06,
                                ),
                              ),
                            ),
                            // Thông tin giao dịch
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 24),
                              child: Column(
                                children: [
                                  buildTransactionDetailRow('Mã đơn hàng',
                                      '${result?.id}', containerWidth * 0.89),
                                  const SizedBox(height: 4),
                                  buildTransactionDetailRow('Nguồn tiền',
                                      paymentMethod, containerWidth * 0.89),
                                  const SizedBox(height: 4),
                                  buildTransactionDetailRow(
                                      'Thời gian giao dịch',
                                      formattedDate,
                                      containerWidth * 0.89),
                                  const SizedBox(height: 2),
                                  buildTransactionDetailRow(
                                    '',
                                    formattedTime,
                                    containerWidth * 0.89,
                                  ),
                                ],
                              ),
                            ),
                            // Đường kẻ nét đứt
                            Container(
                              margin: const EdgeInsets.symmetric(vertical: 12),
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
                                  // Đường kẻ nét đứt

                                  ListView.builder(
                                      shrinkWrap: true,
                                      physics:
                                          const AlwaysScrollableScrollPhysics(),
                                      itemCount: listServices.length,
                                      itemBuilder: (context, index) {
                                        final serviceDetails =
                                            listServices[index];
                                        return buildListService(
                                          serviceDetails.name,
                                          formatPrice(
                                              (serviceDetails.price ?? 0)
                                                  .toInt()),
                                          containerWidth * 0.80,
                                        );
                                      }),
                                ],
                              ),
                            ),
                            // const SizedBox(height: 24),
                            Container(
                              margin: const EdgeInsets.symmetric(vertical: 12),
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 24),
                              child: DashedLine(color: Colors.grey.shade300),
                            ),

                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 24),
                              child: Column(
                                children: [
                                  buildTransactionDetailPriceRow(
                                      'Tổng tiền',
                                      formatPrice(
                                          ((result?.total ?? 0)).toInt()),
                                      containerWidth,
                                      false),
                                  const SizedBox(height: 2),
                                  buildTransactionDetailPriceRow(
                                      'Tiền đã đặt cọc',
                                      formatPrice(
                                          (result?.deposit ?? 0).toInt()),
                                      containerWidth,
                                      false),
                                  const SizedBox(height: 2),
                                  buildTransactionDetailPriceRow(
                                      'Số tiền còn lại đã thanh toán',
                                      formatPrice(((result?.total ?? 0) -
                                              (result?.deposit ?? 0))
                                          .toInt()),
                                      containerWidth,
                                      true),
                                ],
                              ),
                            ),
                            // const SizedBox(height: 4),
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
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                image: DecorationImage(
                                  image: NetworkImage(paymentImageUrl),
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Thanh toán ví điện tử',
                                    style: TextStyle(
                                      fontSize: containerWidth * 0.045,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  // Bạn có thể thêm các thông tin khác ở đây nếu cần
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
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 0.1),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: const TextStyle(
              fontSize: 12,
              color: Colors.black,
              fontWeight: FontWeight.w300,
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(right: 16.0),
            child: Text(
              value,
              style: TextStyle(
                fontSize: 12,
                color: Colors.grey.shade500,
                fontWeight: FontWeight.w300,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget buildTransactionDetailPriceRow(
      String title, String value, double containerWidth, bool isBold) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: TextStyle(
              fontSize: 12,
              color: Colors.black,
              fontWeight: isBold ? FontWeight.bold : FontWeight.w300,
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(right: 16.0),
            child: Text(
              value,
              style: TextStyle(
                fontSize: 12,
                color: isBold ? Colors.black : Colors.grey.shade500,
                fontWeight: isBold ? FontWeight.bold : FontWeight.w300,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget buildListService(String title, String value, double containerWidth) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start, // Align to the top

        children: [
          Expanded(
            flex: 5, // Allocate space for the title
            child: Text(
              title,
              style: TextStyle(
                fontSize: 12,
                color: Colors.grey[700],
              ),
              softWrap: true, // Allow wrapping
              overflow: TextOverflow.visible, // Ensure text is not clipped
            ),
          ),
          const SizedBox(width: 10), // Add spacing between title and value
          Expanded(
            flex: 2, // Allocate space for the value
            child: Text(
              value,
              style: const TextStyle(
                fontSize: 12,
                color: Color.fromARGB(255, 174, 178, 183),
              ),
              softWrap: true, // Allow wrapping
              overflow: TextOverflow.visible, // Ensure text is not clipped
            ),
          ),
        ],
      ),
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
