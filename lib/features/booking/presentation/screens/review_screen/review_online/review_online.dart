import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:movemate/features/booking/domain/entities/booking_response/assignment_response_entity.dart';
import 'package:movemate/features/booking/domain/entities/booking_response/booking_detail_response_entity.dart';
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
import 'package:movemate/utils/commons/widgets/widgets_common_export.dart';
import 'package:movemate/features/booking/presentation/screens/controller/booking_controller.dart';
import 'package:movemate/features/booking/data/models/resquest/reviewer_status_request.dart';
import 'package:movemate/utils/constants/asset_constant.dart';
import 'package:movemate/utils/enums/enums_export.dart';

@RoutePage()
class ReviewOnline extends HookConsumerWidget {
  final OrderEntity order;
  final OrderEntity? orderOld;

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

    // print(
    //     'order  truckNumber check xe : ${resultTruckCate?.estimatedHeight} x ${resultTruckCate?.estimatedLenght} ');

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
                    crossAxisAlignment: CrossAxisAlignment.start,
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
                        // serviceData: serviceData,
                        truckCateDetails: resultTruckCate,
                      ),
                      const SizedBox(height: 12),
                      buildContactCard(
                          order: order, profileUserAssign: profileUserAssign),
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

//gốc
// //
//   Widget buildServiceCard({
//     required OrderEntity order,
//     required ProfileEntity? profileUserAssign,
//     required TruckCategoryEntity? truckCateDetails,
//   }) {
//     return LoadingOverlay(
//       isLoading: truckCateDetails == null,
//       child: Container(
//         width: double.infinity,
//         height: 400, // Cố định chiều cao của buildServiceCard
//         padding: const EdgeInsets.all(16),
//         decoration: BoxDecoration(
//           color: Colors.white,
//           borderRadius: BorderRadius.circular(8),
//           boxShadow: [
//             BoxShadow(
//               color: Colors.grey.withOpacity(0.2),
//               spreadRadius: 1,
//               blurRadius: 5,
//               offset: const Offset(0, 3),
//             ),
//           ],
//         ),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             Row(
//               children: [
//                 truckCateDetails?.imageUrl != null &&
//                         truckCateDetails!.imageUrl.isNotEmpty
//                     ? Image.network(
//                         truckCateDetails.imageUrl,
//                         width: 100,
//                         height: 100,
//                         fit: BoxFit.cover,
//                         errorBuilder: (context, error, stackTrace) =>
//                             const Icon(Icons.error, size: 100),
//                       )
//                     : Image.network(
//                         'https://img.lovepik.com/png/20231013/Cartoon-blue-logistics-transport-truck-package-consumption-driver_196743_wh860.png',
//                         width: 100,
//                         height: 100,
//                         fit: BoxFit.cover,
//                       ),
//                 const SizedBox(width: 16),
//                 Expanded(
//                   child: Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       Text(
//                           order.bookingDetails
//                               .firstWhere(
//                                 (e) => e.type == 'TRUCK',
//                                 orElse: () => BookingDetailResponseEntity(
//                                   bookingId: 0,
//                                   id: 0,
//                                   type: 'TRUCK',
//                                   serviceId: 0,
//                                   quantity: 0,
//                                   price: 0,
//                                   status: "READY",
//                                   name: "Xe Tải",
//                                   description: "Không có mô tả",
//                                   imageUrl: "",
//                                 ),
//                               )
//                               .name,
//                           style: const TextStyle(fontWeight: FontWeight.bold)),
//                       const SizedBox(height: 8),
//                       FittedBox(
//                         child: Row(
//                           children: [
//                             Text(truckCateDetails?.estimatedLenght ?? '',
//                                 style: TextStyle(
//                                     fontSize: 13, color: Colors.grey.shade700)),
//                             Text(' dài, ',
//                                 style: TextStyle(
//                                     fontSize: 13, color: Colors.grey.shade700)),
//                             Text(truckCateDetails?.estimatedWidth ?? '',
//                                 style: TextStyle(
//                                     fontSize: 13, color: Colors.grey.shade700)),
//                             Text(' rộng, ',
//                                 style: TextStyle(
//                                     fontSize: 13, color: Colors.grey.shade700)),
//                             Text(truckCateDetails?.estimatedHeight ?? '',
//                                 style: TextStyle(
//                                     fontSize: 13, color: Colors.grey.shade700)),
//                             Text(' cao',
//                                 style: TextStyle(
//                                     fontSize: 13, color: Colors.grey.shade700)),
//                           ],
//                         ),
//                       ),
//                       const SizedBox(height: 8),
//                       Text(
//                           order.bookingDetails
//                               .firstWhere((e) => e.type == 'TRUCK')
//                               .description,
//                           style: const TextStyle(fontSize: 15)),
//                       const SizedBox(height: 8),
//                       // Text(
//                       //     'Giá: ${formatPrice(order.bookingDetails.firstWhere((e) => e.type == 'TRUCK').price.toInt())}',
//                       //     style: const TextStyle(
//                       //         fontSize: 15, fontWeight: FontWeight.bold)),
//                     ],
//                   ),
//                 ),
//               ],
//             ),
//             const SizedBox(height: 16),
//             // Sử dụng Expanded kết hợp với ListView để có thể scroll danh sách buildPriceItem
//             // Expanded(
//             //   child: ListView.builder(
//             //     itemCount: order.bookingDetails.length,
//             //     itemBuilder: (context, index) {
//             //       final detail = order.bookingDetails[index];
//             //       return buildPriceItem(
//             //         detail.name ?? '',
//             //         formatPrice(detail.price.toInt()),
//             //       );
//             //     },
//             //   ),
//             // ),
//             // Expanded(
//             //   child: ListView.builder(
//             //     itemCount: orderOld!.bookingDetails.length,
//             //     itemBuilder: (context, index) {
//             //       final detail = orderOld!.bookingDetails[index];
//             //       return buildPriceItem(
//             //         detail.name ?? '',
//             //         formatPrice(detail.price.toInt()),
//             //       );
//             //     },
//             //   ),
//             // ),

//             Expanded(
//               child: ListView.builder(
//                 itemCount: order.bookingDetails.length,
//                 itemBuilder: (context, index) {
//                   final newDetail = order.bookingDetails[index];

//                   // Find matching service in old order
//                   final oldDetail = orderOld?.bookingDetails.firstWhere(
//                     (old) => old.id == newDetail.id,
//                     orElse: () => BookingDetailResponseEntity(
//                       id: 0,
//                       serviceId: 0,
//                       bookingId: 0,
//                       quantity: 0,
//                       price: 0,
//                       status: '',
//                       type: '',
//                       name: '',
//                       description: '',
//                       imageUrl: '',
//                     ),
//                   );

//                   return Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       buildPriceItem(
//                         newDetail.name ?? '',
//                         formatPrice(newDetail.price.toInt()),
//                       ),
//                       if (oldDetail != null &&
//                           oldDetail.price != newDetail.price)
//                         buildPriceItem(
//                           oldDetail.name ?? '',
//                           formatPrice(oldDetail.price.toInt()),
//                           isOld: true,
//                         ),
//                     ],
//                   );
//                 },
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// //
//test

  Widget buildServiceCard({
    required OrderEntity order,
    required OrderEntity? orderOld,
    required ProfileEntity? profileUserAssign,
    required TruckCategoryEntity? truckCateDetails,
  }) {
    return LoadingOverlay(
      isLoading: truckCateDetails == null,
      child: Container(
        width: double.infinity,
        height: 400, // Cố định chiều cao của buildServiceCard
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
                truckCateDetails?.imageUrl != null &&
                        truckCateDetails!.imageUrl.isNotEmpty
                    ? Image.network(
                        truckCateDetails.imageUrl,
                        width: 100,
                        height: 100,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) =>
                            const Icon(Icons.error, size: 100),
                      )
                    : Image.network(
                        'https://img.lovepik.com/png/20231013/Cartoon-blue-logistics-transport-truck-package-consumption-driver_196743_wh860.png',
                        width: 100,
                        height: 100,
                        fit: BoxFit.cover,
                      ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        order.bookingDetails
                            .firstWhere(
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
                            )
                            .name,
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 8),
                      FittedBox(
                        child: Row(
                          children: [
                            Text(truckCateDetails?.estimatedLenght ?? '',
                                style: TextStyle(
                                    fontSize: 13, color: Colors.grey.shade700)),
                            Text(' dài, ',
                                style: TextStyle(
                                    fontSize: 13, color: Colors.grey.shade700)),
                            Text(truckCateDetails?.estimatedWidth ?? '',
                                style: TextStyle(
                                    fontSize: 13, color: Colors.grey.shade700)),
                            Text(' rộng, ',
                                style: TextStyle(
                                    fontSize: 13, color: Colors.grey.shade700)),
                            Text(truckCateDetails?.estimatedHeight ?? '',
                                style: TextStyle(
                                    fontSize: 13, color: Colors.grey.shade700)),
                            Text(' cao',
                                style: TextStyle(
                                    fontSize: 13, color: Colors.grey.shade700)),
                          ],
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        order.bookingDetails
                            .firstWhere((e) => e.type == 'TRUCK')
                            .description,
                        style: const TextStyle(fontSize: 15),
                      ),
                      const SizedBox(height: 8),
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
                                buildPriceItem(newService.name,
                                    formatPrice(newService.price.toInt())),
                                buildPriceItem(
                                    " ${oldService?.name}",
                                    formatPrice(
                                        (oldService?.price ?? 0).toInt()),
                                    isStrikethrough: true),
                              ],
                            );
                          }
                        } else {
                          return Column(
                            children: [
                              buildPriceItem(newService.name,
                                  formatPrice(newService.price.toInt())),
                              buildPriceItem(
                                  "${oldServiceTruck?.name}",
                                  formatPrice(
                                      (oldServiceTruck?.price ?? 0).toInt()),
                                  isStrikethrough: true),
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
                        return buildPriceItem(newService.name,
                            formatPrice(newService.price.toInt()));
                      } else if (newService.serviceId ==
                              oldServiceNonTruck?.serviceId &&
                          newService.price != oldServiceNonTruck?.price) {
                        return Column(
                          children: [
                            buildPriceItem(newService.name,
                                formatPrice(newService.price.toInt())),
                            buildPriceItem(
                                oldServiceNonTruck?.name ?? 'Unknown',
                                formatPrice(
                                    oldServiceNonTruck?.price.toInt() ?? 0),
                                isStrikethrough: true),
                          ],
                        );
                      } else if (newService.serviceId !=
                              oldServiceNonTruck?.serviceId &&
                          newService.price != oldServiceNonTruck?.price &&
                          newService.type == oldServicesNonTruck?.type) {
                        return Column(
                          children: [
                            buildPriceItem(newService.name,
                                formatPrice(newService.price.toInt())),
                            buildPriceItem(
                                oldServicesNonTruck?.name ?? 'Unknown',
                                formatPrice(
                                    oldServicesNonTruck?.price.toInt() ?? 0),
                                isStrikethrough: true),
                          ],
                        );
                      } else {
                        return buildPriceItem(newService.name,
                            formatPrice(newService.price.toInt()));
                      }
                    }
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

//

  Widget buildContactCard({
    required OrderEntity order,
    required ProfileEntity? profileUserAssign,
  }) {
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
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Colors.orange,
              borderRadius: BorderRadius.circular(20),
            ),
            child: const Icon(Icons.chat, color: Colors.white, size: 20),
          ),
        ],
      ),
    );
  }

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
