import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:movemate/features/booking/domain/entities/booking_response/booking_detail_response_entity.dart';
import 'package:movemate/features/booking/presentation/screens/controller/booking_controller.dart';
import 'package:movemate/features/booking/presentation/screens/controller/service_package_controller.dart';
import 'package:movemate/features/order/domain/entites/order_entity.dart';
import 'package:movemate/features/order/presentation/controllers/order_controller/order_controller.dart';
import 'package:movemate/features/order/presentation/widgets/details/priceItem.dart';
import 'package:movemate/features/order/presentation/widgets/review_at_home/house_information_at_home.dart';
import 'package:movemate/features/order/presentation/widgets/review_online/house_information.dart';
import 'package:movemate/services/realtime_service/booking_status_realtime/booking_status_stream_provider.dart';
import 'package:movemate/utils/commons/widgets/format_price.dart';
import 'package:movemate/utils/commons/widgets/loading_overlay.dart';
import 'package:movemate/utils/constants/asset_constant.dart';

class ServicesCardAtHome extends HookConsumerWidget {
  final OrderEntity order;
  final OrderEntity? orderOld;

  const ServicesCardAtHome({
    super.key,
    required this.order,
    required this.orderOld,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(servicePackageControllerProvider);

    // final stateBooking = ref.watch(bookingControllerProvider);
    final stateOldBooking = ref.watch(orderControllerProvider);

    final bookingAsync = ref.watch(bookingStreamProvider(order.id.toString()));
    print('object list service housetypr ${orderOld?.houseTypeId}');
    final bool checkingHouseType = order.houseTypeId != orderOld?.houseTypeId ||
        order.roomNumber != orderOld?.roomNumber ||
        order.floorsNumber != orderOld?.floorsNumber ||
        order.bookingAt != orderOld?.bookingAt;

    print('checking lisst ${orderOld?.houseTypeId}');

    //     if (useFetchResultOld.isFetchingData) {
    //   return const Center(child: CircularProgressIndicator());
    // }

    return LoadingOverlay(
      isLoading: state.isLoading ||
          // stateBooking.isLoading ||
          stateOldBooking.isLoading,
      child: Container(
        width: double.infinity,
        height: checkingHouseType
            ? 450
            : 350, // Cố định chiều cao của buildServicesCardAtHome
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(8),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.2),
              spreadRadius: 1,
              blurRadius: 5,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      if (checkingHouseType)
                        HouseInformationAtHome(
                          order: order,
                          orderOld: orderOld,
                        ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),

            // Compare the service details from both lists
            Expanded(
              child: Scrollbar(
                thumbVisibility: true,
                thickness: 5,
                child: _buildServiceList(),
              ),
            ),
            const SizedBox(height: 12),

            _buildTotalPrice(bookingAsync),

            // Note colors for service types
            const SizedBox(height: 12),
            _buildLegend(),
          ],
        ),
      ),
    );
  }

  BookingDetailResponseEntity _createEmptyBookingDetail() {
    return BookingDetailResponseEntity(
      bookingId: 0,
      id: 0,
      type: "TRUCK",
      serviceId: 0,
      quantity: 0,
      price: 0,
      status: "READY",
      name: "No Service",
      description: "No description",
      imageUrl: "",
    );
  }

  Widget _buildServiceList() {
    List<Widget> allServiceWidgets = [];
    List<int> processedOldServices = [];

    // 1. Xử lý danh sách services hiện tại trước
    for (var newService in order.bookingDetails) {
      if (newService.type == "TRUCK") {
        if (orderOld != null) {
          final oldServiceTruck = orderOld?.bookingDetails.firstWhere(
            (e) => e.type == "TRUCK",
            orElse: () => _createEmptyBookingDetail(),
          );

          if (oldServiceTruck?.serviceId != 0) {
            processedOldServices.add(oldServiceTruck!.serviceId);
          }
        }
        allServiceWidgets.addAll(_buildTruckServiceWidgets(newService));
      } else {
        if (orderOld != null) {
          final oldServiceNonTruck = orderOld?.bookingDetails.firstWhere(
            (e) => e.serviceId == newService.serviceId && e.type != "TRUCK",
            orElse: () => _createEmptyBookingDetail(),
          );

          if (oldServiceNonTruck?.serviceId != 0) {
            processedOldServices.add(oldServiceNonTruck!.serviceId);
          }
        }
        allServiceWidgets.addAll(_buildNonTruckServiceWidgets(newService));
      }
    }

    // 2. Xử lý các services đã bị xóa
    if (orderOld != null) {
      for (var oldService in orderOld!.bookingDetails) {
        if (!processedOldServices.contains(oldService.serviceId)) {
          allServiceWidgets.add(
            buildPriceItem(
              "${oldService.name} (Đã xóa)",
              formatPrice(oldService.price.toDouble()),
              isStrikethrough: true,
              quantity: oldService.quantity,
            ),
          );
        }
      }
    }

    // 3. Xử lý deposit
    allServiceWidgets.addAll(_buildDepositWidgets());

    // 4. Xử lý fee details
    for (var fee in order.feeDetails) {
      allServiceWidgets.add(
        buildPriceItem(fee.name, formatPrice(fee.amount.toDouble())),
      );
    }

    return ListView(children: allServiceWidgets);
  }

  List<Widget> _buildTruckServiceWidgets(
      BookingDetailResponseEntity newService) {
    List<Widget> widgets = [];

    // Case 1: Không có order cũ -> service mới hoàn toàn
    if (orderOld == null) {
      widgets.add(buildPriceItem(
        "${newService.name} (Mới)",
        formatPrice(newService.price.toDouble()),
        quantity: newService.quantity,
        isStrikethrough: false,
      ));
      return widgets;
    }

    // Tìm service truck cũ
    final oldServiceTruck = orderOld?.bookingDetails.firstWhere(
      (e) => e.type == "TRUCK",
      orElse: () => _createEmptyBookingDetail(),
    );

    // Case 2: Service truck mới (không có service truck cũ)
    if (oldServiceTruck?.serviceId == 0) {
      widgets.add(buildPriceItem(
        "${newService.name} (Mới)",
        formatPrice(newService.price.toDouble()),
        quantity: newService.quantity,
        isStrikethrough: false,
      ));
      return widgets;
    }

    // Case 3: Cùng service và có thay đổi (giá hoặc số lượng)
    if (newService.serviceId == oldServiceTruck?.serviceId &&
        (newService.price != oldServiceTruck?.price ||
            newService.quantity != oldServiceTruck?.quantity)) {
      widgets.addAll([
        buildPriceItem(
          oldServiceTruck!.name,
          formatPrice(oldServiceTruck.price.toDouble()),
          isStrikethrough: true,
          quantity: oldServiceTruck.quantity,
        ),
        buildPriceItem(
          newService.name,
          formatPrice(newService.price.toDouble()),
          quantity: newService.quantity,
        ),
      ]);
      return widgets;
    }

    // Case 4: Thay đổi sang service truck khác
    if (newService.serviceId != oldServiceTruck?.serviceId) {
      widgets.addAll([
        buildPriceItem(
          oldServiceTruck!.name,
          formatPrice(oldServiceTruck.price.toDouble()),
          isStrikethrough: true,
          quantity: oldServiceTruck.quantity,
        ),
        buildPriceItem(
          "${newService.name} (Thay thế)",
          formatPrice(newService.price.toDouble()),
          quantity: newService.quantity,
          isStrikethrough: false,
        ),
      ]);
      return widgets;
    }

    // Case 5: Không có thay đổi
    widgets.add(buildPriceItem(
      newService.name,
      formatPrice(newService.price.toDouble()),
      quantity: newService.quantity,
    ));
    return widgets;
  }

  List<Widget> _buildNonTruckServiceWidgets(
      BookingDetailResponseEntity newService) {
    List<Widget> widgets = [];

    // Case 1: Không có order cũ -> service mới
    if (orderOld == null) {
      widgets.add(buildPriceItem(
        "${newService.name} (Mới)",
        formatPrice(newService.price.toDouble()),
        quantity: newService.quantity,
        isStrikethrough: false,
      ));
      return widgets;
    }

    // Tìm service non-truck cũ
    final oldServiceNonTruck = orderOld?.bookingDetails.firstWhere(
      (e) => e.serviceId == newService.serviceId && e.type != "TRUCK",
      orElse: () => _createEmptyBookingDetail(),
    );

    // Case 2: Service non-truck mới
    if (oldServiceNonTruck?.serviceId == 0) {
      widgets.add(buildPriceItem(
        "${newService.name} (Mới)",
        formatPrice(newService.price.toDouble()),
        quantity: newService.quantity,
        isStrikethrough: false,
      ));
      return widgets;
    }

    // Case 3: Cùng service và có thay đổi (giá hoặc số lượng)
    if (newService.serviceId == oldServiceNonTruck?.serviceId &&
        (newService.price != oldServiceNonTruck?.price ||
            newService.quantity != oldServiceNonTruck?.quantity)) {
      widgets.addAll([
        buildPriceItem(
          oldServiceNonTruck!.name,
          formatPrice(oldServiceNonTruck.price.toDouble()),
          isStrikethrough: true,
          quantity: oldServiceNonTruck.quantity,
        ),
        buildPriceItem(
          newService.name,
          formatPrice(newService.price.toDouble()),
          quantity: newService.quantity,
        ),
      ]);
      return widgets;
    }

    // Case 4: Không có thay đổi
    widgets.add(buildPriceItem(
      newService.name,
      formatPrice(newService.price.toDouble()),
      quantity: newService.quantity,
    ));
    return widgets;
  }

  List<Widget> _buildDepositWidgets() {
    List<Widget> widgets = [];

    if (orderOld == null) {
      widgets.add(buildPriceItem(
        'Tiền đặt cọc',
        formatPrice(order.deposit.toDouble()),
      ));
      return widgets;
    }

    if (order.deposit == orderOld?.deposit) {
      widgets.add(buildPriceItem(
        'Tiền đặt cọc',
        formatPrice(order.deposit.toDouble()),
      ));
    } else {
      widgets.addAll([
        buildPriceItem(
          'Tiền đặt cọc cũ',
          formatPrice(orderOld?.deposit.toDouble() ?? 0),
          isStrikethrough: true,
        ),
        buildPriceItem(
          'Tiền đặt cọc mới',
          formatPrice(order.deposit.toDouble()),
          isStrikethrough: false,
        ),
      ]);
    }

    return widgets;
  }

  Widget _buildTotalPrice(AsyncValue<dynamic> bookingAsync) {
    if (orderOld == null &&
        (order.vouchers == null || order.vouchers!.isEmpty)) {
      return buildSummary(
        'Tổng giá',
        formatPrice(order.total.toDouble()),
        fontWeight: FontWeight.w600,
      );
    }

    final bool pricesEqual = (bookingAsync.value?.total == orderOld?.total) ||
        (order.total == orderOld?.total);

    if (pricesEqual) {
      return buildSummary(
        'Tổng giá',
        formatPrice(
            bookingAsync.value?.total.toDouble() ?? order.total.toDouble()),
        fontWeight: FontWeight.w600,
      );
    }

    return Column(
      children: [
        buildPriceItem(
          'Tổng giá cũ',
          formatPrice(orderOld?.total.toDouble() ?? 0),
          isStrikethrough: true,
        ),
        buildPriceItem(
          'Tổng giá mới',
          formatPrice(
            bookingAsync.value?.total.toDouble() ?? order.total.toDouble(),
          ),
          isStrikethrough: false,
        ),
      ],
    );
  }

  Widget _buildLegend() {
    return FittedBox(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Container(width: 10, height: 12, color: Colors.red),
          const SizedBox(width: 8),
          const Text('Thông tin cũ', style: TextStyle(fontSize: 10)),
          const SizedBox(width: 16),
          Container(width: 10, height: 12, color: Colors.green),
          const SizedBox(width: 8),
          const Text('Thông tin cập nhật', style: TextStyle(fontSize: 10)),
          const SizedBox(width: 16),
          Container(width: 10, height: 12, color: Colors.black),
          const SizedBox(width: 8),
          const Text('Không thay đổi', style: TextStyle(fontSize: 10)),
        ],
      ),
    );
  }
}
