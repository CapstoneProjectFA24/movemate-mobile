//route
import 'package:auto_route/auto_route.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
//widgets
import 'package:flutter/material.dart';
//widgets
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';
import 'package:movemate/configs/routes/app_router.dart';
import 'package:movemate/features/booking/data/models/resquest/reviewer_status_request.dart';
import 'package:movemate/features/booking/presentation/screens/controller/booking_controller.dart';
import 'package:movemate/features/order/domain/entites/order_entity.dart';
import 'package:movemate/features/order/presentation/widgets/review_online/confirmation_link.dart';
import 'package:movemate/features/profile/domain/entities/profile_entity.dart';
import 'package:movemate/features/profile/presentation/controllers/profile_controller/profile_controller.dart';
import 'package:movemate/features/promotion/data/models/response/promotion_about_user_response.dart';
import 'package:movemate/features/promotion/domain/entities/promotion_entity.dart';
import 'package:movemate/features/promotion/domain/entities/voucher_entity.dart';
import 'package:movemate/features/promotion/presentation/controller/promotion_controller.dart';
import 'package:movemate/hooks/use_fetch_obj.dart';
import 'package:movemate/services/chat_services/models/chat_model.dart';
import 'package:movemate/services/realtime_service/booking_status_realtime/booking_status_stream_provider.dart';
import 'package:movemate/utils/commons/widgets/app_bar.dart';
import 'package:movemate/utils/commons/widgets/form_input/label_text.dart';
import 'package:movemate/utils/commons/widgets/loading_overlay.dart';
import 'package:movemate/utils/constants/asset_constant.dart';
import 'package:movemate/utils/enums/enums_export.dart';

@RoutePage()
class ReviewAtHome extends HookConsumerWidget {
  const ReviewAtHome({super.key, required this.order});
  final OrderEntity order;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(bookingControllerProvider);
    // final statePromotion = ref.watch(promotionControllerProvider);

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

    // Khởi tạo trạng thái để lưu các voucher được chọn
    final selectedVouchers = useState<List<VoucherEntity>>([]);

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
      final matchingVouchers = <VoucherEntity>[];

      for (var promotion in promotions) {
        // Check if promotion's serviceId matches any booking detail's serviceId
        if (bookingServiceIds.contains(promotion.serviceId)) {
          // Check if promotion is currently valid
          final now = DateTime.now();
          if (now.isAfter(promotion.startDate) &&
              now.isBefore(promotion.endDate)) {
            // Add vouchers that are:
            // 1. Active
            // 2. Not used (bookingId is null)
            // 3. Either not assigned to a user (userId is null) or assigned to the order's user
            final validVouchers = promotion.vouchers.where((voucher) =>
                voucher.isActived &&
                voucher.bookingId == 0 &&
                (voucher.userId == order.userId));

            matchingVouchers.addAll(validVouchers);
          }
        }
      }

      return matchingVouchers;
    }

    final matchingVouchers = useState<List<VoucherEntity>>([]);

    useEffect(() {
      if (useFetchResultPromotion.data?.promotionUser != null) {
        final validVouchers = getMatchingVouchers(
          order: order,
          promotions: useFetchResultPromotion.data!.promotionUser,
        );
        matchingVouchers.value = validVouchers;
      }
      return null;
    }, [useFetchResultPromotion.data]);
    final bookingAsync = ref.watch(bookingStreamProvider(order.id.toString()));

    final checkDepossit = bookingAsync.value!.status == 'DEPOSITING';

    final checkWaiting = bookingAsync.value!.status == 'WAITING';
    return LoadingOverlay(
      isLoading: state.isLoading,
      child: Scaffold(
        backgroundColor: const Color(0xFFF5F5F5),
        appBar: const CustomAppBar(
          backButtonColor: AssetsConstants.whiteColor,
          title: 'Gợi ý dịch vụ',
          centerTitle: true,
        ),
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 10,
                    offset: const Offset(0, 0),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisSize: MainAxisSize
                    .min, // Đảm bảo Column chiếm không gian tối thiểu
                children: [
                  const SizedBox(height: 10),
                  AppointmentTime(
                    order: order,
                  ),
                  const SizedBox(height: 10),
                  Description(order: order),
                  const SizedBox(height: 20),
                  ContactSection(order: order),
                  const SizedBox(height: 30),
                  if (matchingVouchers.value.isNotEmpty && checkWaiting)
                    ConfirmationLink(
                      order: order,
                      vouchers: matchingVouchers.value,
                      selectedVouchers:
                          selectedVouchers.value, // Truyền danh sách đã chọn
                      onVoucherSelected: addVoucher,
                      onVoucherRemoved: removeVoucher,
                    ),
                  const SizedBox(height: 20),
                ],
              ),
            ),
          ),
        ),
        bottomNavigationBar: Padding(
          padding: const EdgeInsets.all(16.0),
          child: SafeArea(
            child: Buttons(
              order: order,
              selectedVouchers: selectedVouchers.value,
            ),
          ),
        ),
      ),
    );
  }
}

class Buttons extends HookConsumerWidget {
  final OrderEntity order;
  final List<VoucherEntity> selectedVouchers;
  const Buttons({
    super.key,
    required this.order,
    required this.selectedVouchers,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(profileControllerProvider);
    final reviewrInAssigmentId =
        order.assignments.firstWhere((e) => e.staffType == "REVIEWER").userId;

    final useFetchUserInfo = useFetchObject<ProfileEntity>(
      function: (context) async {
        return ref
            .read(profileControllerProvider.notifier)
            .getProfileInforById(reviewrInAssigmentId, context);
      },
      context: context,
    );
    final profileStaffReviewer = useFetchUserInfo.data;

    final bookingAsync = ref.watch(bookingStreamProvider(order.id.toString()));

    final checkDepossit = bookingAsync.value!.status == 'DEPOSITING';

    final checkWaiting = bookingAsync.value!.status == 'WAITING';

    // print('log care 1  $checkDepossit');
    // print('log care 2 $checkWaiting');
    // print('log care 3 ${state.isLoading}');
    // print('log care 2 $checkWaiting');
    return LoadingOverlay(
      isLoading: state.isLoading,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          ActionButton(
            text: 'Thay đổi lịch hẹn',
            color: Colors.white,
            borderColor: const Color(0xFFFF6600),
            textColor: const Color(0xFFFF6600),
            onPressed: () async {
              // Show confirmation modal
              showDialog(
                context: context,
                builder: (BuildContext context) {
                  return AlertDialog(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16.0),
                    ),
                    title: const Text(
                      'Thay đổi lịch hẹn',
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                    ),
                    backgroundColor: Colors.white,
                    content: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                            'Bạn có chắc chắn muốn thay đổi lịch hẹn không.'),
                        const SizedBox(height: 16),
                        Row(
                          children: [
                            const Icon(Icons.chat_bubble_outline,
                                color: Color(0xFFFF6600)),
                            const SizedBox(width: 8),
                            GestureDetector(
                              onTap: () {
                                // Handle chat with staff action
                                Navigator.of(context).pop();
                                // Redirect to chat screen or open chat
                                // openChatWithStaff(context);
                                context.router.push(ChatWithStaffScreenRoute(
                                    staffId:
                                        profileStaffReviewer?.id.toString() ??
                                            "2",
                                    staffName:
                                        profileStaffReviewer?.name ?? "vinh",
                                    staffRole: StaffRole.reviewer,
                                    staffImageAvatar:
                                        profileStaffReviewer?.avatarUrl ?? "",
                                    bookingId: order.id.toString()));
                              },
                              child: const Text(
                                'Chat với nhân viên',
                                style: TextStyle(
                                  color: Color(0xFFFF6600),
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                    actions: [
                      TextButton(
                        onPressed: () {
                          Navigator.of(context).pop(); // Close modal
                        },
                        child: const Text(
                          'Hủy',
                          style: TextStyle(color: Colors.grey),
                        ),
                      ),
                      TextButton(
                        onPressed: () async {
                          // Proceed with updating the booking
                          final reviewerStatusRequest = ReviewerStatusRequest(
                            status: BookingStatusType.assigned,
                          );
                          await ref
                              .read(bookingControllerProvider.notifier)
                              .changeBookingAt(
                                request: reviewerStatusRequest,
                                order: order,
                                context: context,
                              );
                          Navigator.of(context).pop(); // Close modal
                        },
                        child: const Text(
                          'Xác nhận',
                          style: TextStyle(color: Color(0xFFFF6600)),
                        ),
                      ),
                    ],
                  );
                },
              );
            },
          ),
          const SizedBox(height: 8),
          if (checkWaiting)
            ActionButton(
                text: 'Xác nhận',
                color: const Color(0xFFFF6600),
                textColor: Colors.white,
                onPressed: () async {
                  final reviewerStatusRequest = ReviewerStatusRequest(
                    status: BookingStatusType.depositing,
                    vouchers: selectedVouchers
                        .map((v) => Voucher(
                              id: v.id,
                              promotionCategoryId: v.promotionCategoryId,
                            ))
                        .toList(),
                  );
                  await ref
                      .read(bookingControllerProvider.notifier)
                      .confirmReviewBooking(
                        request: reviewerStatusRequest,
                        order: order,
                        context: context,
                      );
                }),
          if (checkDepossit)
            ActionButton(
              text: 'Thanh toán',
              color: const Color(0xFFFF6600),
              textColor: Colors.white,
              onPressed: () {
                // print('log care done ');
                context.router.push(PaymentScreenRoute(id: order.id));
              },
            ),
          const SizedBox(height: 8),
          ActionButton(
            text: 'Hủy',
            color: Colors.white,
            borderColor: const Color(0xFF666666),
            textColor: const Color(0xFF666666),
            onPressed: () {
              // Handle event when 'Hủy' button is pressed
              context.router.pop();
            },
          ),
        ],
      ),
    );
  }
}

class AppointmentTime extends StatelessWidget {
  final OrderEntity order;
  const AppointmentTime({super.key, required this.order});

  @override
  Widget build(BuildContext context) {
    // print("order updatedAt ${order.updatedAt}");
    // print("order reviewAt ${order.reviewAt}");
// hàm để định dạng ngày tháng
    final formattedDateReviewAt = DateFormat('dd-MM-yyyy')
        .format(DateTime.parse(order.reviewAt.toString()));

    final formattedTimeReviewAt =
        DateFormat('HH:mm').format(DateTime.parse(order.reviewAt.toString()));

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Text(
          'Lịch hẹn với người đánh giá',
          textAlign: TextAlign.center,
          style: TextStyle(
            color: Color(0xFFFF6600),
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 5),
        LabelText(
          content: '$formattedDateReviewAt  $formattedTimeReviewAt ',
          size: 14,
          color: AssetsConstants.primaryMain,
          fontWeight: FontWeight.bold,
        ),
      ],
    );
  }
}

class Description extends StatelessWidget {
  const Description({super.key, required this.order});
  final OrderEntity order;
  @override
  Widget build(BuildContext context) {
    return const Text(
      'Nhằm nâng cao tính chính xác của dịch vụ chúng tôi đề cử nhân viên đến xem xét ',
      textAlign: TextAlign.center,
      style: TextStyle(
        color: Color(0xFF666666),
        fontSize: 14,
      ),
    );
  }
}

class ContactSection extends HookConsumerWidget {
  final OrderEntity order;
  const ContactSection({super.key, required this.order});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Column(
      children: [
        const Text(
          'Liên hệ với nhân viên',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 10),
        ContactInfo(
          order: order,
        ),
      ],
    );
  }
}

class ContactInfo extends HookConsumerWidget {
  const ContactInfo({super.key, required this.order});
  final OrderEntity order;
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(profileControllerProvider);
    final reviewrInAssigmentId =
        order.assignments.firstWhere((e) => e.staffType == "REVIEWER").userId;

    final useFetchUserInfo = useFetchObject<ProfileEntity>(
      function: (context) async {
        return ref
            .read(profileControllerProvider.notifier)
            .getProfileInforById(reviewrInAssigmentId, context);
      },
      context: context,
    );
    final profileStaffReviewer = useFetchUserInfo.data;

    return LoadingOverlay(
      isLoading: state.isLoading,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          CircleAvatar(
            radius: 20,
            backgroundImage: NetworkImage(
              profileStaffReviewer?.avatarUrl ??
                  'https://via.placeholder.com/150',
            ),
          ),
          const SizedBox(width: 10),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                profileStaffReviewer?.name ?? 'No Name',
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Row(
                children: [
                  const Icon(FontAwesomeIcons.solidStar,
                      color: Colors.amber, size: 12),
                  const SizedBox(width: 5),
                  Text(
                    '${profileStaffReviewer?.phone}',
                    style:
                        const TextStyle(fontSize: 12, color: Color(0xFF666666)),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(width: 20),
          // IconButton(
          //   icon: const Icon(FontAwesomeIcons.phone,
          //       size: 18, color: Color(0xFF666666)),
          //   onPressed: () {
          //     // Xử lý sự kiện khi nhấn vào biểu tượng điện thoại
          //   },
          // ),
          const SizedBox(width: 20),
          IconButton(
            icon: const Icon(FontAwesomeIcons.comment,
                size: 18, color: Color(0xFF666666)),
            onPressed: () {
              // Xử lý sự kiện khi nhấn vào biểu tượng tin nhắn
              context.router.push(ChatWithStaffScreenRoute(
                  staffId: profileStaffReviewer?.id.toString() ?? "2",
                  staffName: profileStaffReviewer?.name ?? "vinh",
                  staffRole: StaffRole.reviewer,
                  staffImageAvatar: profileStaffReviewer?.avatarUrl ?? "",
                  bookingId: order.id.toString()));
            },
          ),
        ],
      ),
    );
  }
}

class ActionButton extends StatelessWidget {
  final String text;
  final Color color;
  final Color textColor;
  final Color? borderColor;
  final VoidCallback onPressed;

  const ActionButton({
    super.key,
    required this.text,
    required this.color,
    required this.textColor,
    required this.onPressed,
    this.borderColor,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity, // Nút chiếm toàn bộ chiều rộng
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: color,
          foregroundColor: textColor,
          side: borderColor != null ? BorderSide(color: borderColor!) : null,
          padding: const EdgeInsets.symmetric(vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
        ),
        onPressed: onPressed,
        child: Text(
          text,
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: textColor, // Đảm bảo màu chữ chính xác
          ),
        ),
      ),
    );
  }
}
