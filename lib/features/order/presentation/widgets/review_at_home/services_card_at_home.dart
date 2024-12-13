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
                child: ListView.builder(
                  itemCount: order.bookingDetails.length +
                      order.feeDetails.length +
                      1, // 1 for the deposit
                  itemBuilder: (context, index) {
                    // Hiển thị dịch vụ (bookingDetails)
                    if (index < order.bookingDetails.length) {
                      final newService = order.bookingDetails[index];
                      final oldService = orderOld?.bookingDetails.firstWhere(
                        (e) =>
                            e.serviceId == newService.serviceId &&
                            e.type == "TRUCK",
                        orElse: () => BookingDetailResponseEntity(
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
                        ),
                      );
                      final oldServiceTruck =
                          orderOld?.bookingDetails.firstWhere(
                        (e) => e.type == "TRUCK",
                      );

                      if (newService.type == "TRUCK") {
                        if (oldServiceTruck?.serviceId != 0) {
                          if (newService.serviceId == oldService?.serviceId) {
                            if (newService.price == oldService?.price) {
                              return buildPriceItem(newService.name,
                                  formatPrice(newService.price.toDouble()));
                            } else {
                              return Column(
                                children: [
                                  buildPriceItem(
                                      " ${oldService?.name}",
                                      formatPrice(
                                          (oldService?.price ?? 0).toDouble()),
                                      isStrikethrough: true),
                                  buildPriceItem(newService.name,
                                      formatPrice(newService.price.toDouble()),
                                      isStrikethrough: false),
                                ],
                              );
                            }
                          } else {
                            return Column(
                              children: [
                                buildPriceItem(
                                    "${oldServiceTruck?.name}",
                                    formatPrice((oldServiceTruck?.price ?? 0)
                                        .toDouble()),
                                    isStrikethrough: true),
                                buildPriceItem(newService.name,
                                    formatPrice(newService.price.toDouble()),
                                    isStrikethrough: false),
                              ],
                            );
                          }
                        } else {
                          return buildPriceItem(newService.name,
                              formatPrice(newService.price.toDouble()));
                        }
                      } else {
                        final oldServiceNonTruck = orderOld?.bookingDetails
                            .firstWhere(
                                (e) =>
                                    e.serviceId == newService.serviceId &&
                                    e.type != "TRUCK",
                                orElse: () => BookingDetailResponseEntity(
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
                                    ));
                        final oldServicesNonTruck = orderOld?.bookingDetails
                            .firstWhere((e) => e.type != "TRUCK",
                                orElse: () => BookingDetailResponseEntity(
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
                                    ));

                        if (newService.serviceId ==
                                oldServiceNonTruck?.serviceId &&
                            newService.price == oldServiceNonTruck?.price) {
                          return buildPriceItem(
                            newService.name,
                            formatPrice(newService.price.toDouble()),
                            quantity: newService.quantity,
                          );
                        } else if (newService.serviceId ==
                                oldServiceNonTruck?.serviceId &&
                            newService.price != oldServiceNonTruck?.price) {
                          return Column(
                            children: [
                              buildPriceItem(
                                oldServiceNonTruck?.name ?? 'Unknown',
                                formatPrice(
                                    oldServiceNonTruck?.price.toDouble() ?? 0),
                                isStrikethrough: true,
                                quantity: oldServicesNonTruck?.quantity ?? 0,
                              ),
                              buildPriceItem(
                                newService.name,
                                formatPrice(newService.price.toDouble()),
                                quantity: newService.quantity,
                                isStrikethrough: false,
                              ),
                            ],
                          );
                        } else if (newService.serviceId !=
                                oldServiceNonTruck?.serviceId &&
                            newService.price != oldServiceNonTruck?.price &&
                            newService.type == oldServicesNonTruck?.type) {
                          return Column(
                            children: [
                              buildPriceItem(
                                oldServicesNonTruck?.name ?? 'Unknown',
                                formatPrice(
                                    oldServicesNonTruck?.price.toDouble() ?? 0),
                                isStrikethrough: true,
                                quantity: oldServicesNonTruck?.quantity ?? 0,
                              ),
                              buildPriceItem(
                                newService.name,
                                formatPrice(newService.price.toDouble()),
                                quantity: newService.quantity,
                                isStrikethrough: false,
                              ),
                            ],
                          );
                        } else {
                          return buildPriceItem(
                            newService.name,
                            formatPrice(newService.price.toDouble()),
                            quantity: newService.quantity,
                          );
                        }
                      }
                    }

                    // Hiển thị deposit (tiền đặt cọc)
                    if (index == order.bookingDetails.length) {
                      if (orderOld != null) {
                        if (order.deposit == orderOld?.deposit) {
                          return buildPriceItem('Tiền đặt cọc',
                              formatPrice(order.deposit.toDouble()));
                        } else {
                          return Column(
                            children: [
                              buildPriceItem(
                                  'Tiền đặt cọc cũ',
                                  formatPrice(
                                      orderOld?.deposit.toDouble() ?? 0),
                                  isStrikethrough: true),
                              buildPriceItem('Tiền đặt cọc mới',
                                  formatPrice(order.deposit.toDouble()),
                                  isStrikethrough: false),
                            ],
                          );
                        }
                      } else {
                        return buildPriceItem('Tiền đặt cọc',
                            formatPrice(order.deposit.toDouble()));
                      }
                    }

                    // Hiển thị feeDetails
                    final fee = order
                        .feeDetails[index - order.bookingDetails.length - 1];
                    return buildPriceItem(
                        fee.name, formatPrice(fee.amount.toDouble()));
                  },
                ),
              ),
            ),
            const SizedBox(height: 12),

            // Tổng giá
            if (orderOld != null ||
                (order.vouchers?.length != 0 &&
                    order.vouchers?.length != null)) ...[
              if ((bookingAsync.value?.total == orderOld?.total) ||
                  (order.total == orderOld?.total))
                buildSummary(
                    'Tổng giá',
                    formatPrice(bookingAsync.value?.total.toDouble() ??
                        order.total.toDouble()),
                    fontWeight: FontWeight.w600)
              else ...[
                buildPriceItem(
                    'Tổng giá cũ', formatPrice(orderOld?.total.toDouble() ?? 0),
                    isStrikethrough: true),
                buildPriceItem(
                  'Tổng giá mới',
                  formatPrice(
                    bookingAsync.value?.total.toDouble() ??
                        order.total.toDouble(),
                  ),
                  isStrikethrough: false,
                ),
              ]
            ] else ...[
              buildSummary('Tổng giá', formatPrice(order.total.toDouble()),
                  fontWeight: FontWeight.w600),
            ],

            // Note colors for service types
            const SizedBox(height: 12),
            FittedBox(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Container(
                    width: 10,
                    height: 12,
                    color: Colors.red,
                  ),
                  const SizedBox(width: 8),
                  const Text('Thông tin cũ', style: TextStyle(fontSize: 10)),
                  const SizedBox(width: 16),
                  Container(
                    width: 10,
                    height: 12,
                    color: Colors.green,
                  ),
                  const SizedBox(width: 8),
                  const Text('Thông tin cập nhật',
                      style: TextStyle(fontSize: 10)),
                  const SizedBox(width: 16),
                  Container(
                    width: 10,
                    height: 12,
                    color: Colors.black,
                  ),
                  const SizedBox(width: 8),
                  const Text('Không thay đổi', style: TextStyle(fontSize: 10)),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
