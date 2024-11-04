import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:movemate/features/order/domain/entites/order_entity.dart';
import '../../../../../configs/routes/app_router.dart';
import '../../../../../utils/commons/widgets/widgets_common_export.dart';
import '../../../../../utils/constants/asset_constant.dart';
import 'package:movemate/services/realtime_service/booking_status_realtime/booking_status_stream_provider.dart';
import 'package:movemate/utils/enums/booking_status_type.dart';
import 'package:movemate/utils/commons/functions/string_utils.dart';

//
class OrderItem extends HookConsumerWidget {
  const OrderItem({
    super.key,
    required this.order,
    required this.onCallback,
  });

  final OrderEntity order;
  final VoidCallback onCallback;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final size = MediaQuery.sizeOf(context);

    // Listen to the real-time status from Firestore
    final statusAsync =
        ref.watch(orderStatusStreamProvider(order.id.toString()));

    return GestureDetector(
      onTap: () {
        context.router.push(OrderDetailsScreenRoute(order: order));
      },
      child: Container(
        // width: 380,
        // height: 170,
        width: double.infinity,
        padding: const EdgeInsets.all(AssetsConstants.defaultPadding - 12.0),
        margin: const EdgeInsets.only(bottom: AssetsConstants.defaultMargin),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 5,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          children: [
            // Image
            // Padding(
            //   padding: const EdgeInsets.only(left: 10.0),
            //   child: ClipRRect(
            //     borderRadius: BorderRadius.circular(10),
            //     child: Image.network(
            //       'https://storage.googleapis.com/a1aa/image/fpR5CaQW2ny0CCt8MBn1ufzjTBuLAgHXz4yQMiYIxzaWDIlTA.jpg',
            //       width: 100,
            //       height: 100,
            //       fit: BoxFit.cover,
            //     ),
            //   ),
            // ),
            const SizedBox(width: 15),
            // Card Content
            Expanded(
              child: Padding(
                padding: const EdgeInsets.only(top: 18.0),
                child: statusAsync.when(
                  data: (status) {
                    // Calculate displayTotal based on real-time status

                    String formattedTotal =
                        NumberFormat('#,###').format(order.totalReal);

                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        LabelText(
                          content: 'Mã đơn hàng : #${order.id}',
                          size: AssetsConstants.defaultFontSize - 12.0,
                          fontWeight: FontWeight.w600,
                        ),
                        const SizedBox(height: 5),
                        const Row(
                          children: [
                            LabelText(
                              content: 'Loại nhà: ',
                              size: AssetsConstants.defaultFontSize - 12.0,
                              fontWeight: FontWeight.w600,
                            ),
                            Text(
                              'Nhà riêng',
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                        const SizedBox(height: 5),
                        Row(
                          children: [
                            Icon(
                              order.isReviewOnline
                                  ? Icons.computer
                                  : Icons.home,
                              size: 16,
                              color: const Color(0xFF555555),
                            ),
                            const SizedBox(width: 5),
                            Text(
                              order.isReviewOnline
                                  ? 'Đánh giá trực tuyến'
                                  : 'Đánh giá tại nhà',
                              style: const TextStyle(
                                fontSize: 14,
                                color: Color(0xFF555555),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 5),
                        // Display real-time status
                        Row(
                          children: [
                            Container(
                              height: 10,
                              width: 10,
                              decoration: BoxDecoration(
                                color: getStatusColor(status),
                                shape: BoxShape.circle,
                              ),
                            ),
                            const SizedBox(width: 5),
                            Text(getBookingStatusText(status).statusText),
                          ],
                        ),
                        const SizedBox(height: 5),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Text(
                              '$formattedTotal ₫',
                              style: const TextStyle(
                                color: AssetsConstants.primaryMain,
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(width: 10),
                            Text(
                              ' •  ${order.roomNumber} phòng - ${order.floorsNumber} tầng ',
                              style: const TextStyle(
                                fontSize: 14,
                                color: Color(0xFF555555),
                              ),
                            ),
                          ],
                        ),
                      ],
                    );
                  },
                  loading: () => buildLoadingState(order),
                  error: (error, stack) => buildErrorState(order),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildLoadingState(OrderEntity order) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        LabelText(
          content: 'Mã đơn hàng : #${order.id}',
          size: AssetsConstants.defaultFontSize - 12.0,
          fontWeight: FontWeight.w600,
        ),
        const SizedBox(height: 5),
        const Row(
          children: [
            LabelText(
              content: 'Loại nhà: ',
              size: AssetsConstants.defaultFontSize - 12.0,
              fontWeight: FontWeight.w600,
            ),
            Text(
              'Nhà riêng',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
          ],
        ),
        const SizedBox(height: 5),
        // Review Type
        Row(
          children: [
            Icon(
              order.isReviewOnline ? Icons.computer : Icons.home,
              size: 16,
              color: const Color(0xFF555555),
            ),
            const SizedBox(width: 5),
            Text(
              order.isReviewOnline
                  ? 'Đánh giá trực tuyến'
                  : 'Đánh giá tại nhà',
              style: const TextStyle(
                fontSize: 14,
                color: Color(0xFF555555),
              ),
            ),
          ],
        ),
        const SizedBox(height: 5),
        // Loading status
        Row(
          children: [
            Transform.scale(
              scale: 0.5, // Điều chỉnh kích thước của CircularProgressIndicator
              child: const CircularProgressIndicator(
                strokeWidth: 2,
                valueColor: AlwaysStoppedAnimation<Color>(Colors.grey),
              ),
            ),
            const SizedBox(width: 5),
            const Text('Đang tải...'),
          ],
        ),
        const SizedBox(height: 5),
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            const Text(
              '... ₫',
              style: TextStyle(
                color: Color(0xFF007BFF),
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(width: 10),
            Text(
              '• ${order.roomNumber} - ${order.floorsNumber} tầng ',
              style: const TextStyle(
                fontSize: 14,
                color: Color(0xFF555555),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget buildErrorState(OrderEntity order) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        LabelText(
          content: 'Mã đơn hàng : #${order.id}',
          size: AssetsConstants.defaultFontSize - 12.0,
          fontWeight: FontWeight.w600,
        ),
        const SizedBox(height: 5),
        const Row(
          children: [
            LabelText(
              content: 'Loại nhà: ',
              size: AssetsConstants.defaultFontSize - 12.0,
              fontWeight: FontWeight.w600,
            ),
            Text(
              'Nhà riêng',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
          ],
        ),
        const SizedBox(height: 5),
        // Review Type
        Row(
          children: [
            Icon(
              order.isReviewOnline ? Icons.computer : Icons.home,
              size: 16,
              color: const Color(0xFF555555),
            ),
            const SizedBox(width: 5),
            Text(
              order.isReviewOnline
                  ? 'Đánh giá trực tuyến'
                  : 'Đánh giá tại nhà',
              style: const TextStyle(
                fontSize: 14,
                color: Color(0xFF555555),
              ),
            ),
          ],
        ),
        const SizedBox(height: 5),
        // Error status
        const Row(
          children: [
            Icon(
              Icons.error_outline,
              size: 16,
              color: Colors.red,
            ),
            SizedBox(width: 5),
            Text(
              'Error loading status',
              style: TextStyle(color: Colors.red),
            ),
          ],
        ),
        const SizedBox(height: 5),
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            const Text(
              '... ₫',
              style: TextStyle(
                color: Color(0xFF007BFF),
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(width: 10),
            Text(
              '• ${order.roomNumber} - ${order.floorsNumber} tầng ',
              style: const TextStyle(
                fontSize: 14,
                color: Color(0xFF555555),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
