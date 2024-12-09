import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:movemate/configs/routes/app_router.dart';
import 'package:movemate/features/booking/domain/entities/booking_response/assignment_response_entity.dart';
import 'package:movemate/features/booking/domain/entities/booking_response/booking_detail_response_entity.dart';

import 'package:movemate/features/booking/presentation/screens/controller/service_package_controller.dart';
import 'package:movemate/features/booking/presentation/screens/service_screen/service_controller.dart';
import 'package:movemate/features/order/domain/entites/order_entity.dart';

import 'package:movemate/features/order/presentation/widgets/review_online/confirmation_link.dart';
import 'package:movemate/features/order/presentation/widgets/review_online/contact_card.dart';

import 'package:movemate/features/order/presentation/widgets/review_online/services_card.dart';
import 'package:movemate/features/profile/domain/entities/profile_entity.dart';
import 'package:movemate/features/profile/presentation/controllers/profile_controller/profile_controller.dart';
import 'package:movemate/features/promotion/data/models/response/promotion_about_user_response.dart';
import 'package:movemate/features/promotion/domain/entities/promotion_entity.dart';
import 'package:movemate/features/promotion/domain/entities/voucher_entity.dart';
import 'package:movemate/features/promotion/presentation/controller/promotion_controller.dart';

import 'package:movemate/features/promotion/presentation/widgets/voucher_modal/voucher_modal.dart';
import 'package:movemate/hooks/use_booking_status.dart';
import 'package:movemate/hooks/use_fetch_obj.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
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

  get vouchers => null;

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
    final stateProfile = ref.watch(profileControllerProvider);
    final stateService = ref.watch(serviceControllerProvider);
    final stateServicePackage = ref.watch(servicePackageControllerProvider);
    final statePromotion = ref.watch(promotionControllerProvider);

    final reviewerAssignment = getReviewerAssignment(order);
    final getAssID = reviewerAssignment.userId;

    final truckBookingDetail = getTruckBookingDetail(order);
    final getServiceId = truckBookingDetail.serviceId;
    final selectedVouchers = useState<List<VoucherEntity>>([]);

    final useFetchResultProfile = useFetchObject<ProfileEntity>(
      function: (context) async {
        return ref
            .read(profileControllerProvider.notifier)
            .getProfileInforById(getAssID, context);
      },
      context: context,
    );
    final profileUserAssign = useFetchResultProfile.data;

    final staffResponsibility = ref
        .watch(bookingStreamProvider(order.id.toString()))
        .value
        ?.assignments
        .where((e) => e.staffType == 'REVIEWER')
        .first;

    final useFetchResultPromotion = useFetchObject<PromotionAboutUserEntity>(
      function: (context) => ref
          .read(promotionControllerProvider.notifier)
          .getPromotionNoUser(context),
      context: context,
    );

    useEffect(() {
      useFetchResultPromotion.refresh;
      return null;
    }, []); // Empty dependency array means it runs once on mount

    // print(
    //     ' check list promotion promotionUser.length ${useFetchResultPromotion.data!.promotionUser.any((e) => e.serviceId != null)}');
    // Khởi tạo trạng thái để lưu các voucher được chọn

    // Hàm callback để thêm voucher vào danh sách đã chọn
    void addVoucher(VoucherEntity voucher) {
      if (!selectedVouchers.value.contains(voucher)) {
        selectedVouchers.value = [...selectedVouchers.value, voucher];
      }
    }

    // Hàm callback để loại bỏ voucher khỏi danh sách đã chọn (nếu cần)
    void removeVoucher(VoucherEntity voucher) {
      selectedVouchers.value =
          selectedVouchers.value.where((v) => v.id != voucher.id).toList();
    }

    List<VoucherEntity> getMatchingVouchers({
      required OrderEntity order,
      required List<PromotionEntity> promotions,
    }) {
      // Get all serviceIds from bookingDetails
      final bookingServiceIds =
          order.bookingDetails.map((detail) => detail.serviceId).toSet();

      // print("validVouchers checking serviceIds $bookingServiceIds");
      final matchingVouchers = <VoucherEntity>[];

      for (var promotion in promotions) {
        // Check if promotion's serviceId matches any booking detail's serviceId
        if (bookingServiceIds.contains(promotion.serviceId)) {
          // Check if promotion is currently valid
          final now = DateTime.now();
          // print('validVouchers checking 1 dateTime $now');
          // print(
          //     'validVouchers checking 2 dateTime ${now.isAfter(promotion.startDate)}');
          // print(
          // 'validVouchers checking 3 dateTime ${now.isBefore(promotion.endDate)}');
          if (now.isBefore(promotion.endDate)) {
            // Add vouchers that are:
            // 1. Active
            // 2. Not used (bookingId is null)
            // 3. Either not assigned to a user (userId is null) or assigned to the order's user
            final validVouchers = promotion.vouchers.where((voucher) =>
                voucher.isActived &&
                voucher.bookingId == 0 &&
                (voucher.userId == order.userId));

            // print("validVouchers checking  4 ${validVouchers.length}");
            matchingVouchers.addAll(validVouchers);
            // print("validVouchers checking  5 ${matchingVouchers.length}");
            // print("validVouchers checking 6 ");
          }
        }
      }

      return matchingVouchers;
    }

// Example usage in your widget:
    final matchingVouchers = useState<List<VoucherEntity>>([]);

    useEffect(() {
      if (useFetchResultPromotion.data?.promotionUser != null) {
        final validVouchers = getMatchingVouchers(
          order: order,
          promotions: useFetchResultPromotion.data!.promotionUser,
        );
        print('validVouchers checking 1 $validVouchers');
        print(
            'validVouchers checking 2 ${useFetchResultPromotion.data!.promotionUser.where((e) => e.serviceId != 0).toList().toString()}');
        // print('validVouchers checking 3 $validVouchers');
        matchingVouchers.value = validVouchers;
      }
      return null;
    }, [useFetchResultPromotion.data]);
    final bookingAsync = ref.watch(bookingStreamProvider(order.id.toString()));

    final bookingStatus =
        useBookingStatus(bookingAsync.value, order.isReviewOnline ?? false);

    // Validate data
    final isDataValid = getAssID != 0 && getServiceId != 0;
    final checkIsUnchanged = order.isUnchanged == true;

    final checkDepossit =
        bookingAsync.value!.status == BookingStatusType.depositing;

    final checkReviwed = bookingAsync.value!.status == 'REVIEWED';
    print('log care  ${!checkDepossit && checkReviwed}');
    return LoadingOverlay(
      isLoading: stateProfile.isLoading ||
          stateService.isLoading ||
          stateServicePackage.isLoading ||
          statePromotion.isLoading,
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: CustomAppBar(
          title:
              order.isUnchanged == true ? 'Gợi ý dịch vụ' : 'Xác nhận dịch vụ',
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
                      Text(
                        order.isUnchanged == false
                            ? 'Vui lòng xác nhận'
                            : 'Chọn xe không hợp lý',
                        style: const TextStyle(
                            fontSize: 16, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 8),
                      const Text(
                        'Chúng tôi đề xuất cho bạn như sau',
                        style: TextStyle(fontSize: 14, color: Colors.grey),
                      ),
                      const SizedBox(height: 16),
                      ServiceCard(
                        order: order,
                        orderOld: orderOld,
                      ),
                      const SizedBox(height: 12),
                      ContactCard(
                        order: order,
                        profileUserAssign: profileUserAssign,
                        staffAssignment: staffResponsibility,
                      ),
                      const SizedBox(height: 10),
                      if (matchingVouchers.value.isNotEmpty &&
                          !checkDepossit &&
                          checkReviwed)
                        ConfirmationLink(
                          order: order,
                          vouchers: matchingVouchers.value,
                          selectedVouchers: selectedVouchers
                              .value, // Truyền danh sách đã chọn
                          onVoucherSelected: addVoucher,
                          onVoucherRemoved: removeVoucher,
                        ),
                      const SizedBox(height: 20),
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
                      // if (selectedVouchers.value.isNotEmpty)
                      //   Column(
                      //     crossAxisAlignment: CrossAxisAlignment.start,
                      //     children: [
                      //       const Text(
                      //         'Các phiếu giảm giá đã chọn:',
                      //         style: TextStyle(
                      //             fontSize: 16, fontWeight: FontWeight.bold),
                      //       ),
                      //       const SizedBox(height: 8),
                      //       ...selectedVouchers.value.map((voucher) => ListTile(
                      //             title: Text('Voucher ID: ${voucher.id}'),
                      //             subtitle: Text(
                      //                 'Category ID: ${voucher.promotionCategoryId}'),
                      //             trailing: IconButton(
                      //               icon: const Icon(Icons.remove_circle,
                      //                   color: Colors.red),
                      //               onPressed: () => removeVoucher(voucher),
                      //             ),
                      //           )),
                      //       const SizedBox(height: 16),
                      //     ],
                      //   ),
                      buildButton('Xác nhận', Colors.orange,
                          onPressed: (!checkDepossit && checkReviwed)
                              ? () async {
                                  final bookingStatus =
                                      order.status.toBookingTypeEnum();

                                  final reviewerStatusRequest =
                                      ReviewerStatusRequest(
                                    status: BookingStatusType.depositing,
                                    vouchers: selectedVouchers.value
                                        .map((v) => Voucher(
                                              id: v.id,
                                              promotionCategoryId:
                                                  v.promotionCategoryId,
                                            ))
                                        .toList(),
                                  );
                                  print(
                                      'ReviewerStatusRequest: ${reviewerStatusRequest.toJson()}');

                                  print('order: $reviewerStatusRequest');
                                  await ref
                                      .read(bookingControllerProvider.notifier)
                                      .confirmReviewBooking(
                                        request: reviewerStatusRequest,
                                        order: order,
                                        context: context,
                                      );
                                }
                              : () {
                                  context.router
                                      .push(PaymentScreenRoute(id: order.id));
                                }),
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
//

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
