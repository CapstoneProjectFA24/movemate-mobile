import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:movemate/features/booking/domain/entities/house_type_entity.dart';
import 'package:movemate/features/booking/presentation/screens/controller/service_package_controller.dart';
import 'package:movemate/features/order/domain/entites/order_entity.dart';
import 'package:movemate/hooks/use_booking_status.dart';
import 'package:movemate/hooks/use_fetch_obj.dart';
import 'package:movemate/services/realtime_service/booking_realtime_entity/order_stream_manager.dart';
import 'package:movemate/services/realtime_service/booking_status_realtime/booking_status_stream_provider.dart';
import '../../../../../configs/routes/app_router.dart';
import '../../../../../utils/commons/widgets/widgets_common_export.dart';
import '../../../../../utils/constants/asset_constant.dart';

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
    // Hàm hỗ trợ để định dạng giá
    String formatPrice(int price) {
      final formatter = NumberFormat('#,###', 'vi_VN');
      return '${formatter.format(price)} đ';
    }

    final bookingAsync = ref.watch(bookingStreamProvider(order.id.toString()));

    final useFetchResult = useFetchObject<HouseTypeEntity>(
      function: (context) => ref
          .read(servicePackageControllerProvider.notifier)
          .getHouseTypeById(order.houseTypeId, context),
      context: context,
    );
    final houseTypeData = useFetchResult.data;

    useEffect(() {
      OrderStreamManager().updateJob(order);
      return null;
    }, [bookingAsync.value]);

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
            const SizedBox(width: 15),
            // Card Content
            Expanded(
              child: Padding(
                padding: const EdgeInsets.only(top: 18.0),
                child: bookingAsync.when(
                  data: (data) {
                    final bookingStatus = useBookingStatus(
                        bookingAsync.value, order.isReviewOnline);
                    // Extract necessary flags from bookingStatus
                    final bool isCancelled = bookingStatus.isCancelled;
                    final bool instructionIconFollowStatus =
                        bookingStatus.canMakePayment ||
                            bookingStatus.canAcceptSchedule ||
                            bookingStatus.canReviewSuggestion;

                    final bool isComplete = bookingStatus.isCompleted;
                    final bool isRefunding = bookingStatus.isRefunding;

                    String statusTextDetails = bookingStatus.statusMessage;

                    if (isComplete) {
                      if (order.isCancel) {
                        if (order.isRefunded) {
                          statusTextDetails = 'Đã hoàn lại tiền';
                        } else {
                          statusTextDetails = 'Đơn hàng đã bị hủy';
                        }
                      } else if (order.isRefunded) {
                        statusTextDetails = 'Đã hoàn lại tiền';
                      } else if (isComplete) {
                        statusTextDetails = 'Đơn hàng đã hoàn thành';
                      } else
                        statusTextDetails = bookingStatus.statusMessage;
                    } else if (isRefunding) {
                      statusTextDetails = 'Đang xử lý yêu cầu hoàn tiền';
                    } else if (isCancelled) {
                      statusTextDetails = 'Đơn hàng đã bị hủy';
                    } else {
                      statusTextDetails = bookingStatus.statusMessage;
                    }

                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        LabelText(
                          content: 'Mã đơn hàng : BOK${order.id}',
                          size: AssetsConstants.defaultFontSize - 12.0,
                          fontWeight: FontWeight.w600,
                        ),
                        const SizedBox(height: 5),
                        Row(
                          children: [
                            const LabelText(
                              content: 'Loại nhà: ',
                              size: AssetsConstants.defaultFontSize - 12.0,
                              fontWeight: FontWeight.w600,
                            ),
                            LabelText(
                              content: houseTypeData?.name ?? ' ',
                              size: 14,
                              fontWeight: FontWeight.w500,
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
                                color: getStatusColor(bookingStatus, order),
                                shape: BoxShape.circle,
                              ),
                            ),
                            const SizedBox(width: 5),
                            LabelText(
                              // content: getBookingStatusText(status).statusText,
                              content: statusTextDetails,
                              color: getStatusColor(bookingStatus, order),
                              size: 12,
                              fontWeight: FontWeight.w500,
                            ),
                          ],
                        ),
                        const SizedBox(height: 5),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            LabelText(
                              content: formatPrice(order.total.toInt()),
                              size: 18,
                              color: AssetsConstants.primaryMain,
                              fontWeight: FontWeight.bold,
                            ),
                            const SizedBox(width: 10),
                            LabelText(
                              content:
                                  ' •  ${order.roomNumber} phòng - ${order.floorsNumber} tầng ',
                              size: 14,
                              color: const Color(0xFF555555),
                              fontWeight: FontWeight.w500,
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
            LabelText(
              content: 'Nhà riêng',
              size: 14,
              fontWeight: FontWeight.w500,
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
            LabelText(
              content: order.isReviewOnline
                  ? 'Đánh giá trực tuyến'
                  : 'Đánh giá tại nhà',
              size: 14,
              color: const Color(0xFF555555),
              fontWeight: FontWeight.w600,
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
            const LabelText(
              content: 'Đang tải...',
              size: 14,
              fontWeight: FontWeight.w600,
            ),
          ],
        ),
        const SizedBox(height: 5),
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            const LabelText(
              content: '... ₫',
              color: Color(0xFF007BFF),
              size: 18,
              fontWeight: FontWeight.bold,
            ),
            const SizedBox(width: 10),
            LabelText(
              content: '• ${order.roomNumber} - ${order.floorsNumber} tầng ',
              size: 14,
              color: const Color(0xFF555555),
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
              order.isReviewOnline ? 'Đánh giá trực tuyến' : 'Đánh giá tại nhà',
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

Color getStatusColor(
  BookingStatusResult status,
  OrderEntity order,
) {
  // New Conditions
  if (status.isCompleted) {
    if (order.isRefunded) {
      return Colors.blue; // Example color for "Đã hoàn tiền"
    } else if (order.isCancel) {
      return Colors.red; // Example color for "Đã hủy"
    } else {
      return const Color(0xFF673AB7); // Existing color for "Hoàn thành"
    }
  }

  // Các trạng thái chờ xác nhận từ khách hàng (Màu xanh dương)
  if (status.canAcceptSchedule) {
    return const Color(0xFF2196F3); // Xanh dương đậm
  }

  if (status.isOnlineReviewing) {
    return Colors.green.shade700; // Tím
  }
  // Trạng thái thanh toán (Màu tím)
  if (status.canMakePayment) {
    return const Color(0xFF9C27B0); // Tím
  }

  // Trạng thái xem xét đề xuất (Màu xanh lá)
  if (status.canReviewSuggestion) {
    return const Color(0xFF4CAF50); // Xanh lá
  }

  // Trạng thái chờ xác nhận hoàn thành (Màu xanh lam)
  if (status.isCompleted) {
    return const Color(0xFF00BCD4); // Xanh lam
  }

  // Trạng thái đang chờ lịch (Màu cam nhạt)
  if (status.isWaitingStaffSchedule) {
    return const Color(0xFFFF9800); // Cam
  }

  // Trạng thái nhân viên đang đánh giá (Màu vàng)
  if (status.isReviewerAssessing) {
    return const Color(0xFFFFC107); // Vàng
  }

  // Trạng thái đang cập nhật dịch vụ (Màu xám xanh)
  if (status.isReviewerAssessing) {
    return const Color(0xFF607D8B); // Xám xanh
  }

  // Trạng thái có đề xuất mới (Màu xanh lục)
  if (status.isSuggestionReady) {
    return const Color(0xFF8BC34A); // Xanh lục
  }

  // Trạng thái đang vận chuyển (Màu cam đậm)
  if (status.isMovingInProgress) {
    return const Color(0xFFFF5722); // Cam đậm
  }

  // // Trạng thái hoàn thành (Màu tím đậm)
  // if (status.isCompleted) {
  //   return const Color(0xFF673AB7); // Tím đậm
  // }

  // Màu mặc định cho các trạng thái khác (Xám)
  return const Color(0xFF9E9E9E); // Xám
}
