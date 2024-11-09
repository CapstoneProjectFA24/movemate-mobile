//route
import 'package:auto_route/auto_route.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

//widgets
import 'package:flutter/material.dart';
//widgets
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';
import 'package:movemate/features/booking/data/models/resquest/reviewer_status_request.dart';
import 'package:movemate/features/booking/presentation/screens/controller/booking_controller.dart';
import 'package:movemate/features/order/domain/entites/order_entity.dart';
import 'package:movemate/utils/commons/widgets/app_bar.dart';
import 'package:movemate/utils/commons/widgets/form_input/label_text.dart';
import 'package:movemate/utils/commons/widgets/loading_overlay.dart';
import 'package:movemate/utils/constants/asset_constant.dart';
import 'package:movemate/utils/enums/enums_export.dart';

@RoutePage()
class ReviewAtHome extends ConsumerWidget {
  const ReviewAtHome({super.key, required this.order});
  final OrderEntity order;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final bookingControllerState = ref.watch(bookingControllerProvider);

    return LoadingOverlay(
      isLoading: bookingControllerState.isLoading,
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
                  const SizedBox(height: 20),
                ],
              ),
            ),
          ),
        ),
        bottomNavigationBar: Padding(
          padding: const EdgeInsets.all(16.0),
          child: SafeArea(
            child: Buttons(order: order),
          ),
        ),
      ),
    );
  }
}

class Buttons extends ConsumerWidget {
  final OrderEntity order;
  const Buttons({super.key, required this.order});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        ActionButton(
          text: 'Thay đổi lịch hẹn',
          color: Colors.white,
          borderColor: const Color(0xFFFF6600),
          textColor: const Color(0xFFFF6600),
          onPressed: () {
            // Handle event when 'Thay đổi lịch hẹn' button is pressed
          },
        ),
        const SizedBox(height: 8),
        ActionButton(
          text: 'Xác nhận',
          color: const Color(0xFFFF6600),
          textColor: Colors.white,
          onPressed: () async {
            // await ref.read(bookingControllerProvider.notifier).submitBooking(
            //       context: context,
            //     );

            // to do to fix
            final bookingStatus = order.status.toBookingTypeEnum();

            final reviewerStatusRequest = ReviewerStatusRequest(
              status: BookingStatusType.depositing,
            );
            await ref
                .read(bookingControllerProvider.notifier)
                .confirmReviewBooking(
                  request: reviewerStatusRequest,
                  order: order,
                  context: context,
                );
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
    );
  }
}

class AppointmentTime extends StatelessWidget {
  final OrderEntity order;
  const AppointmentTime({super.key, required this.order});

  @override
  Widget build(BuildContext context) {
    print("order updatedAt ${order.updatedAt}");
    print("order reviewAt ${order.reviewAt}");

    final formattedDateReviewAt = DateFormat('dd-MM-yyyy')
        .format(DateTime.parse(order.reviewAt.toString()));

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Text(
          'Lịch hẹn với người đánh giá',
          textAlign: TextAlign.center,
          style: TextStyle(
            color: Color(0xFFFF6600),
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 5),
        LabelText(
          content: '$formattedDateReviewAt ',
          size: 18,
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
    final formattedTimeReviewAt =
        DateFormat('hh:mm').format(DateTime.parse(order.reviewAt.toString()));

    return Text(
      'Nhằm nâng cao tính chính xác của dịch vụ chúng tôi đề cử nhân viên đến xem xét vào lúc $formattedTimeReviewAt',
      textAlign: TextAlign.center,
      style: const TextStyle(
        color: Color(0xFF666666),
        fontSize: 14,
      ),
    );
  }
}

class ContactSection extends StatelessWidget {
  final OrderEntity order;
  const ContactSection({super.key, required this.order});

  @override
  Widget build(BuildContext context) {
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

class ContactInfo extends StatelessWidget {
  const ContactInfo({super.key, required this.order});
  final OrderEntity order;
  @override
  Widget build(BuildContext context) {
    print('contact info ${order.assignments.length}');
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const CircleAvatar(
          radius: 20,
          backgroundImage: NetworkImage(
            'https://storage.googleapis.com/a1aa/image/p5OKRdzupwITHJRADxe2zVw1ETxmkRfWfQZKa5mhRMjVmAMnA.jpg',
          ),
        ),
        const SizedBox(width: 10),
        const Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Hoàng Văn Huy',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
              ),
            ),
            Row(
              children: [
                Icon(FontAwesomeIcons.solidStar, color: Colors.amber, size: 12),
                SizedBox(width: 5),
                Text(
                  '5.0 • 61-N1 162.32',
                  style: TextStyle(fontSize: 12, color: Color(0xFF666666)),
                ),
              ],
            ),
          ],
        ),
        const SizedBox(width: 10),
        IconButton(
          icon: const Icon(FontAwesomeIcons.phone,
              size: 18, color: Color(0xFF666666)),
          onPressed: () {
            // Xử lý sự kiện khi nhấn vào biểu tượng điện thoại
          },
        ),
        const SizedBox(width: 10),
        IconButton(
          icon: const Icon(FontAwesomeIcons.comment,
              size: 18, color: Color(0xFF666666)),
          onPressed: () {
            // Xử lý sự kiện khi nhấn vào biểu tượng tin nhắn
          },
        ),
      ],
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
