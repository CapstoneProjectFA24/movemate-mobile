import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:movemate/configs/routes/app_router.dart';
import 'package:movemate/features/booking/domain/entities/booking_response/assignment_response_entity.dart';
import 'package:movemate/features/booking/domain/entities/booking_response/booking_detail_response_entity.dart';
import 'package:movemate/features/booking/domain/entities/house_type_entity.dart';
import 'package:movemate/features/booking/domain/entities/services_package_entity.dart';
import 'package:movemate/features/booking/domain/entities/truck_category_entity.dart';
import 'package:movemate/features/booking/presentation/screens/controller/service_package_controller.dart';
import 'package:movemate/features/booking/presentation/screens/service_screen/service_controller.dart';
import 'package:movemate/features/order/domain/entites/order_entity.dart';
import 'package:movemate/features/order/presentation/widgets/details/priceItem.dart';
import 'package:movemate/features/order/presentation/widgets/main_detail_ui/customer_info.dart';
import 'package:movemate/features/profile/domain/entities/profile_entity.dart';
import 'package:movemate/features/profile/presentation/controllers/profile_controller/profile_controller.dart';
import 'package:movemate/hooks/use_fetch_obj.dart';
import 'package:movemate/services/chat_services/models/chat_model.dart';
import 'package:movemate/services/realtime_service/booking_realtime_entity/booking_realtime_entity.dart';
import 'package:movemate/services/realtime_service/booking_status_realtime/booking_status_stream_provider.dart';
import 'package:movemate/utils/commons/widgets/widgets_common_export.dart';
import 'package:movemate/features/booking/presentation/screens/controller/booking_controller.dart';
import 'package:movemate/features/booking/data/models/resquest/reviewer_status_request.dart';
import 'package:movemate/utils/constants/asset_constant.dart';
import 'package:movemate/utils/enums/enums_export.dart';

@RoutePage()
class ReviewOnline extends HookConsumerWidget {
  final OrderEntity order;
  final OrderEntity? orderOld;
  static const double spacing = 10.0;
  const ReviewOnline({super.key, required this.order, required this.orderOld});

  // Helper method to get reviewer assignment with a default value
  AssignmentResponseEntity getReviewerAssignment(OrderEntity order) {
    return order.assignments.firstWhere(
      (e) => e.staffType == 'REVIEWER',
      orElse: () => AssignmentResponseEntity(
        bookingId: 0,
        staffType: 'REVIEWER',
        userId: 0,
        id: 0,
        status: "READY",
        isResponsible: false,
        price: 0,
      ),
    );
  }

  // Helper method to get truck booking detail with a default value
  BookingDetailResponseEntity getTruckBookingDetail(OrderEntity order) {
    return order.bookingDetails.firstWhere(
      (e) => e.type == 'TRUCK',
      orElse: () => BookingDetailResponseEntity(
        bookingId: 0,
        id: 0,
        type: 'TRUCK',
        serviceId: 0,
        quantity: 0,
        price: 0,
        status: "READY",
        name: "Xe Tải",
        description: "Không có mô tả",
        imageUrl: "",
      ),
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isExpanded = useState(false);
    final expandedIndex = useState<int>(-1);
    void toggleDropdown() {
      isExpanded.value = !isExpanded.value;
    }

    final stateProfile = ref.watch(profileControllerProvider);
    final stateService = ref.watch(serviceControllerProvider);
    final stateServicePackage = ref.watch(servicePackageControllerProvider);

    final reviewerAssignment = getReviewerAssignment(order);
    final getAssID = reviewerAssignment.userId;

    final truckBookingDetail = getTruckBookingDetail(order);
    final getServiceId = truckBookingDetail.serviceId;

    // print('getIdAssignment: $getAssID');
    // print('getServiceId: $getServiceId');

    final useFetchResultProfile = useFetchObject<ProfileEntity>(
      function: (context) async {
        return ref
            .read(profileControllerProvider.notifier)
            .getProfileInforById(getAssID, context);
      },
      context: context,
    );
    final profileUserAssign = useFetchResultProfile.data;

    // final useFetchResultService = useFetchObject<ServicesPackageEntity>(
    //   function: (context) async {
    //     return ref
    //         .read(serviceControllerProvider.notifier)
    //         .getServicesById(getServiceId, context);
    //   },
    //   context: context,
    // );
    // final serviceData = useFetchResultService.data;

    final useFetchResultTruckCate = useFetchObject<TruckCategoryEntity>(
      function: (context) => ref
          .read(servicePackageControllerProvider.notifier)
          .getTruckDetailById(order.truckNumber, context),
      context: context,
    );
    final resultTruckCate = useFetchResultTruckCate.data;

    final staffResponsibility =
        // order.assignments.where((e) => e.isResponsible == true).toList();
        ref
            .watch(bookingStreamProvider(order.id.toString()))
            .value
            ?.assignments
            .where((e) => e.staffType == 'REVIEWER')
            .first;

    // Validate data
    final isDataValid = getAssID != 0 && getServiceId != 0;

    return LoadingOverlay(
      isLoading: stateProfile.isLoading ||
          stateService.isLoading ||
          stateServicePackage.isLoading,
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: const CustomAppBar(
          title: 'Gợi ý dịch vụ',
          backButtonColor: AssetsConstants.whiteColor,
          centerTitle: true,
        ),
        body: isDataValid
            ? SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      const Text(
                        'Chọn xe không hợp lý',
                        style: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 8),
                      const Text(
                        'Chúng tôi đề xuất cho bạn như sau',
                        style: TextStyle(fontSize: 16, color: Colors.grey),
                      ),
                      const SizedBox(height: 16),
                      buildServiceCard(
                        order: order,
                        orderOld: orderOld,
                        profileUserAssign: profileUserAssign,
                        truckCateDetails: resultTruckCate,
                        ref: ref,
                        context: context,
                      ),
                      const SizedBox(height: 12),
                      buildContactCard(
                        order: order,
                        profileUserAssign: profileUserAssign,
                        context: context,
                        staffAssignment: staffResponsibility,
                      ),
                    ],
                  ),
                ),
              )
            : const Center(
                child: Text(
                  'Thông tin đơn hàng không hợp lệ. Vui lòng thử lại sau.',
                  style: TextStyle(fontSize: 16, color: Colors.red),
                  textAlign: TextAlign.center,
                ),
              ),
        bottomNavigationBar: isDataValid
            ? Padding(
                padding: const EdgeInsets.all(16.0),
                child: SafeArea(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      buildButton(
                        'Xác nhận',
                        Colors.orange,
                        onPressed: () async {
                          final bookingStatus =
                              order.status.toBookingTypeEnum();
                          final reviewerStatusRequest = ReviewerStatusRequest(
                            status: BookingStatusType.depositing,
                          );
                          print('order: $reviewerStatusRequest');
                          await ref
                              .read(bookingControllerProvider.notifier)
                              .confirmReviewBooking(
                                request: reviewerStatusRequest,
                                order: order,
                                context: context,
                              );
                        },
                      ),
                      const SizedBox(height: 12),
                      buildButton(
                        'Hủy',
                        Colors.white,
                        textColor: Colors.grey,
                        borderColor: Colors.grey,
                        onPressed: () => context.router.pop(),
                      ),
                    ],
                  ),
                ),
              )
            : const SizedBox.shrink(),
      ),
    );
  }

  Widget buildHouseInformation(
      {required WidgetRef ref, required BuildContext context}) {
    // Format date and time for new order
    final formattedDateNew = DateFormat('dd-MM-yyyy')
        .format(DateTime.parse(order.bookingAt.toString()));
    final formattedTimeNew =
        DateFormat('hh:mm').format(DateTime.parse(order.bookingAt.toString()));

    // Format date and time for old order
    final formattedDateOld = orderOld != null
        ? DateFormat('dd-MM-yyyy')
            .format(DateTime.parse(orderOld!.bookingAt.toString()))
        : null;
    final formattedTimeOld = orderOld != null
        ? DateFormat('hh:mm')
            .format(DateTime.parse(orderOld!.bookingAt.toString()))
        : null;

    final useFetchResultOld = useFetchObject<HouseTypeEntity>(
      function: (context) => ref
          .read(servicePackageControllerProvider.notifier)
          .getHouseTypeById(order.houseTypeId, context),
      context: context,
    );
    final useFetchResultNew = useFetchObject<HouseTypeEntity>(
      function: (context) => ref
          .read(servicePackageControllerProvider.notifier)
          .getHouseTypeById(orderOld!.houseTypeId, context),
      context: context,
    );

    final houseTypeDataOld = useFetchResultOld.data;
    final houseTypeDataNew = useFetchResultNew.data;

    // Get house type, floor and room information for both old and new orders
    final houseTypeNew = houseTypeDataNew?.name ?? "Unknown";
    final floorNumberNew = order.floorsNumber.toString() ?? "Unknown";
    final roomNumberNew = order.roomNumber.toString() ?? "Unknown";

    final houseTypeOld = houseTypeDataOld?.name ?? "Unknown";
    final floorNumberOld = orderOld?.floorsNumber.toString() ?? "Unknown";
    final roomNumberOld = orderOld?.roomNumber.toString() ?? "Unknown";

    print("tuan checking ${order.houseType?.name} ");

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            // Compare house type for old and new orders
            Column(
              children: [
                const LabelText(
                  content: 'Loại nhà : ',
                  size: 14,
                  fontWeight: FontWeight.w400,
                ),
                if (houseTypeNew == houseTypeOld)
                  LabelText(
                    content: houseTypeNew,
                    size: 14,
                    fontWeight: FontWeight.bold,
                  )
                else ...[
                  LabelText(
                    content: houseTypeOld,
                    size: 14,
                    fontWeight: FontWeight.bold,
                  ),
                  const SizedBox(height: 5),
                  LabelText(
                    content: houseTypeNew,
                    size: 14,
                    fontWeight: FontWeight.bold,
                  ),
                ],
              ],
            ),
            const SizedBox(width: 16),

            // Compare floor number for old and new orders
            Column(
              children: [
                const LabelText(
                  content: 'Tầng : ',
                  size: 14,
                  fontWeight: FontWeight.w400,
                ),
                if (floorNumberNew == floorNumberOld)
                  LabelText(
                    content: floorNumberNew,
                    size: 14,
                    fontWeight: FontWeight.bold,
                  )
                else ...[
                  LabelText(
                    content: floorNumberOld,
                    size: 14,
                    fontWeight: FontWeight.bold,
                  ),
                  const SizedBox(height: 5),
                  LabelText(
                    content: floorNumberNew,
                    size: 14,
                    fontWeight: FontWeight.bold,
                  ),
                ],
              ],
            ),
            const SizedBox(width: 16),

            // Compare room number for old and new orders
            Column(
              children: [
                const LabelText(
                  content: 'Phòng : ',
                  size: 14,
                  fontWeight: FontWeight.w400,
                ),
                if (roomNumberNew == roomNumberOld)
                  LabelText(
                    content: roomNumberNew,
                    size: 14,
                    fontWeight: FontWeight.bold,
                  )
                else ...[
                  LabelText(
                    content: roomNumberOld,
                    size: 14,
                    fontWeight: FontWeight.bold,
                  ),
                  const SizedBox(height: 5),
                  LabelText(
                    content: roomNumberNew,
                    size: 14,
                    fontWeight: FontWeight.bold,
                  ),
                ],
              ],
            ),
          ],
        ),
        const SizedBox(height: spacing),

        // Row for displaying moving date and time
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Column(
              children: [
                Row(
                  children: [
                    const LabelText(
                      content: 'Ngày dọn nhà : ',
                      size: 14,
                      fontWeight: FontWeight.w400,
                    ),
                    // Compare dates: If same, show only new, if different, show both
                    if (formattedDateNew == formattedDateOld)
                      LabelText(
                        content: formattedDateNew ?? "label",
                        size: 14,
                        fontWeight: FontWeight.bold,
                      )
                    else ...[
                      // Display old date first, if different
                      LabelText(
                        content: formattedDateOld ?? "label",
                        size: 14,
                        fontWeight: FontWeight.bold,
                      ),
                      const SizedBox(height: 5),
                      LabelText(
                        content: formattedDateNew ?? "label",
                        size: 14,
                        fontWeight: FontWeight.bold,
                      ),
                    ],
                  ],
                ),
              ],
            ),
            // Display time
            if (formattedTimeNew == formattedTimeOld)
              LabelText(
                content: '  ${formattedTimeNew ?? "label"}',
                size: 14,
                fontWeight: FontWeight.bold,
              )
            else ...[
              // Display both old and new time if they are different
              LabelText(
                content: '  ${formattedTimeOld ?? "label"}',
                size: 14,
                fontWeight: FontWeight.bold,
              ),
              const SizedBox(height: 5),
              LabelText(
                content: '  ${formattedTimeNew ?? "label"}',
                size: 14,
                fontWeight: FontWeight.bold,
              ),
            ],
          ],
        ),
      ],
    );
  }

//test

  Widget buildServiceCard({
    required OrderEntity order,
    required OrderEntity? orderOld,
    required ProfileEntity? profileUserAssign,
    required TruckCategoryEntity? truckCateDetails,
    required WidgetRef ref,
    required BuildContext context,
  }) {
    return LoadingOverlay(
      isLoading: truckCateDetails == null,
      child: Container(
        width: double.infinity,
        height: 500, // Cố định chiều cao của buildServiceCard
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
                      buildHouseInformation(ref: ref, context: context),
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
                // interactive: true,
                child: ListView.builder(
                  itemCount: order.bookingDetails.length,
                  itemBuilder: (context, index) {
                    final newService = order.bookingDetails[index];
                    // final oldService = order.bookingDetails[index];
                    // Get the 'TRUCK' service from orderOld
                    final oldService = orderOld?.bookingDetails.firstWhere(
                      (e) =>
                          e.serviceId == newService.serviceId &&
                          e.type == "TRUCK",
                      orElse: () => BookingDetailResponseEntity(
                        bookingId: 0,
                        id: 0,
                        type: "TRUCK", // Ensure a valid type
                        serviceId: 0,
                        quantity: 0,
                        price: 0,
                        status: "READY",
                        name: "No Service",
                        description: "No description",
                        imageUrl: "",
                      ),
                    ); // Default return if no matching service
                    final oldServiceTruck = orderOld?.bookingDetails.firstWhere(
                      (e) => e.type == "TRUCK",
                    ); // Default return if no matching service

                    if (newService.type == "TRUCK") {
                      if (oldServiceTruck?.serviceId != 0) {
                        // If oldService is not the default
                        if (newService.serviceId == oldService?.serviceId) {
                          if (newService.price == oldService?.price) {
                            return buildPriceItem(newService.name,
                                formatPrice(newService.price.toInt()));
                          } else {
                            return Column(
                              children: [
                                buildPriceItem(
                                    " ${oldService?.name}",
                                    formatPrice(
                                        (oldService?.price ?? 0).toInt()),
                                    isStrikethrough: true),
                                buildPriceItem(newService.name,
                                    formatPrice(newService.price.toInt())),
                              ],
                            );
                          }
                        } else {
                          return Column(
                            children: [
                              buildPriceItem(
                                  "${oldServiceTruck?.name}",
                                  formatPrice(
                                      (oldServiceTruck?.price ?? 0).toInt()),
                                  isStrikethrough: true),
                              buildPriceItem(newService.name,
                                  formatPrice(newService.price.toInt())),
                            ],
                          );
                        }
                      } else {
                        // If no old service, just display the new service
                        return buildPriceItem(newService.name,
                            formatPrice(newService.price.toInt()));
                      }
                    } else {
                      // For non-"TRUCK" services, compare id and price
                      final oldServiceNonTruck = orderOld?.bookingDetails
                          .firstWhere(
                              (e) =>
                                  e.serviceId == newService.serviceId &&
                                  e.type != "TRUCK",
                              orElse: () => BookingDetailResponseEntity(
                                    bookingId: 0,
                                    id: 0,
                                    type: "TRUCK", // Default for non-TRUCK
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
                                    type: "TRUCK", // Default for non-TRUCK
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
                          formatPrice(newService.price.toInt()),
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
                                  oldServiceNonTruck?.price.toInt() ?? 0),
                              isStrikethrough: true,
                              quantity: oldServicesNonTruck?.quantity ?? 0,
                            ),
                            buildPriceItem(
                              newService.name,
                              formatPrice(newService.price.toInt()),
                              quantity: newService.quantity,
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
                                  oldServicesNonTruck?.price.toInt() ?? 0),
                              isStrikethrough: true,
                              quantity: oldServicesNonTruck?.quantity ?? 0,
                            ),
                            buildPriceItem(
                              newService.name,
                              formatPrice(newService.price.toInt()),
                              quantity: newService.quantity,
                            ),
                          ],
                        );
                      } else {
                        return buildPriceItem(
                          newService.name,
                          formatPrice(newService.price.toInt()),
                          quantity: newService.quantity,
                        );
                      }
                    }
                  },
                ),
              ),
            ),

            const SizedBox(height: 8),
            // Deposit display logic
            if (orderOld != null) ...[
              // If the deposit from the old and new order are the same, only show new order's deposit
              if (order.deposit == orderOld.deposit)
                buildPriceItem(
                    'Tiền đặt cọc', formatPrice(order.deposit.toInt()))
              else ...[
                // If the deposit is different, show both old and new order's deposit
                buildPriceItem(
                  'Tiền đặt cọc cũ',
                  formatPrice(orderOld.deposit.toInt()),
                  isStrikethrough: true,
                ),
                buildPriceItem(
                  'Tiền đặt cọc mới',
                  formatPrice(order.deposit.toInt()),
                ),
              ]
            ] else ...[
              // If no old order, just show the new order's deposit
              buildPriceItem(
                  'Tiền đặt cọc', formatPrice(order.deposit.toInt())),
            ],

            // Hiển thị các fee từ feeDetails
            ...order.feeDetails.map((fee) {
              return buildPriceItem(
                fee.name,
                formatPrice(fee.amount.toInt()),
              );
            }),

            // Total Price display logic
            if (orderOld != null) ...[
              // If the total from the old and new order are the same, only show new order's total
              if (order.total == orderOld.total)
                buildSummary(
                  'Tổng giá',
                  formatPrice(order.total.toInt()),
                  fontWeight: FontWeight.w600,
                )
              else ...[
                // If the total is different, show both old and new order's totals
                buildPriceItem(
                  'Tổng giá cũ',
                  formatPrice(orderOld.total.toInt()),
                  isStrikethrough: true,
                ),
                buildSummary(
                  'Tổng giá mới',
                  formatPrice(order.total.toInt()),
                  fontWeight: FontWeight.w600,
                ),
              ]
            ] else ...[
              // If no old order, just show the new order's total
              buildSummary(
                'Tổng giá',
                formatPrice(order.total.toInt()),
                fontWeight: FontWeight.w600,
              ),
            ],
          ],
        ),
      ),
    );
  }

//

  Widget buildContactCard({
    required OrderEntity order,
    required ProfileEntity? profileUserAssign,
    required BuildContext context,
    required AssignmentsRealtimeEntity? staffAssignment,
  }) {
    StaffRole convertToStaffRole(String staffType) {
      switch (staffType.toUpperCase()) {
        case 'REVIEWER':
          return StaffRole.reviewer;
        default:
          return StaffRole.manager;
      }
    }

    return Container(
      padding: const EdgeInsets.all(8),
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
      child: Row(
        children: [
          // Profile Avatar with Null Handling
          profileUserAssign?.avatarUrl != null &&
                  profileUserAssign!.avatarUrl!.isNotEmpty
              ? CircleAvatar(
                  backgroundImage: NetworkImage(profileUserAssign.avatarUrl!),
                  radius: 25,
                )
              : const CircleAvatar(
                  backgroundImage:
                      AssetImage('assets/images/profile/Image.png'),
                  radius: 25,
                ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(order.review != null ? order.review! : '',
                    style: const TextStyle(fontWeight: FontWeight.bold)),
                const Text('Liên hệ với nhân viên',
                    style: TextStyle(fontWeight: FontWeight.bold)),
                Text('${profileUserAssign?.name}',
                    style: TextStyle(color: Colors.grey.shade700)),
                Text('${profileUserAssign?.phone}',
                    style: TextStyle(color: Colors.grey.shade700)),
                // Additional contact details can be added here
              ],
            ),
          ),
          IconButton(
            onPressed: () {
              context.router.push(
                ChatWithStaffScreenRoute(
                  staffId: staffAssignment!.userId.toString(),
                  staffName: profileUserAssign?.name ?? 'Nhân viên',
                  staffRole: convertToStaffRole(staffAssignment.staffType),
                  staffImageAvatar: profileUserAssign?.avatarUrl ?? '',
                  bookingId: order.id.toString(),
                ),
              );
            },
            style: IconButton.styleFrom(
              backgroundColor: Colors.orange,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              padding: const EdgeInsets.all(8),
            ),
            icon: const Icon(
              Icons.chat,
              color: Colors.white,
              size: 16,
            ),
          )
        ],
      ),
    );
  }

//  context.router.push(
//                     ChatWithStaffScreenRoute(
//                       staffId: staffAssignment.userId.toString(),
//                       staffName: staff?.name ?? 'Nhân viên',
//                       staffRole: _convertToStaffRole(staffAssignment.staffType),
//                       staffImageAvatar: staff?.avatarUrl ?? '',
//                       bookingId: order.id.toString(),
//                     ),
//                   );
  Widget buildButton(
    String text,
    Color color, {
    Color textColor = Colors.white,
    Color? borderColor,
    required VoidCallback onPressed,
  }) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: color,
          foregroundColor: textColor,
          side: borderColor != null ? BorderSide(color: borderColor) : null,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          padding: const EdgeInsets.symmetric(vertical: 16),
        ),
        child: Text(
          text,
          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }
}

// Hàm hỗ trợ để định dạng giá
String formatPrice(int price) {
  final formatter = NumberFormat('#,###', 'vi_VN');
  return '${formatter.format(price)} đ';
}
