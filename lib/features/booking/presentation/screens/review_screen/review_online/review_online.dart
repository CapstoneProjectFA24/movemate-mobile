import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:movemate/features/booking/domain/entities/services_package_entity.dart';
import 'package:movemate/features/booking/presentation/screens/service_screen/service_controller.dart';
import 'package:movemate/features/order/domain/entites/order_entity.dart';
import 'package:movemate/features/order/presentation/widgets/main_detail_ui/profile_info.dart';
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
  const ReviewOnline({super.key, required this.order});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final getAssID =
        order.assignments.firstWhere((e) => e.staffType == 'REVIEWER').userId;
    final getServiceId =
        order.bookingDetails.firstWhere((e) => e.type == 'TRUCK').serviceId;
    print('getIdAssignment: $getAssID');
    print('getServiceId: $getServiceId');

    final useFetchResultProfile = useFetchObject<ProfileEntity>(
      function: (context) async {
        return ref
            .read(profileControllerProvider.notifier)
            .getProfileInforById(getAssID, context);
      },
      context: context,
    );
    final profileUserAssign = useFetchResultProfile.data;

    final useFetchResultService = useFetchObject<ServicesPackageEntity>(
      function: (context) async {
        return ref
            .read(serviceControllerProvider.notifier)
            .getServicesById(getServiceId, context);
      },
      context: context,
    );
    final serviceData = useFetchResultService.data;

    print('profileUserAssign: $profileUserAssign');
    print('serviceData: $serviceData');
    print('serviceData: ${serviceData?.imageUrl}');
    print('order.bookingDetails  : ${order.bookingDetails}');
    return LoadingOverlay(
      isLoading: useFetchResultProfile.isFetchingData ||
          useFetchResultService.isFetchingData,
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: const CustomAppBar(
          title: 'Gợi ý dịch vụ',
          backButtonColor: AssetsConstants.whiteColor,
          centerTitle: true,
        ),
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Chọn xe không hợp lý',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),
                const Text(
                  'Chúng tôi đề xuất cho bạn như sau',
                  style: TextStyle(fontSize: 16, color: Colors.grey),
                ),
                const SizedBox(height: 16),
                buildServiceCard(
                    order: order,
                    profileUserAssign: profileUserAssign,
                    serviceData: serviceData),
                const SizedBox(height: 16),
                buildContactCard(
                    order: order, profileUserAssign: profileUserAssign),
                const SizedBox(height: 24),
              ],
            ),
          ),
        ),
        bottomNavigationBar: Padding(
          padding: const EdgeInsets.all(16.0),
          child: SafeArea(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                buildButton(
                  'Xác nhận',
                  Colors.orange,
                  onPressed: () async {
                    final bookingStatus = order.status.toBookingTypeEnum();
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
        ),
      ),
    );
  }

  Widget buildServiceCard(
      {required OrderEntity order,
      required ProfileEntity? profileUserAssign,
      required ServicesPackageEntity? serviceData}) {
    return Container(
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
              Image.network(
                // 'https://img.lovepik.com/png/20231013/Cartoon-blue-logistics-transport-truck-package-consumption-driver_196743_wh860.png',
                '${serviceData?.imageUrl}',
                width: 100,
                height: 100,
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                        order.bookingDetails
                            .firstWhere((e) => e.type == 'TRUCK')
                            .name,
                        // .join('\n '),
                        style: const TextStyle(fontWeight: FontWeight.bold)),
                    // Text('${order.bookingDetails.map((e) => e.type)} dịch vụ',
                    //     style: const TextStyle(color: Colors.grey)),
                    // const Text('4m dài, 1m8 rộng, 1m8 cao',
                    //     style: TextStyle(color: Colors.grey)),
                    // const Text('4m dài, 1m8 rộng, 1m8 cao',
                    //     style: TextStyle(color: Colors.grey)),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          // const Text('BOG xếp: (Bốc nhân viên bốc xếp)',
          //     style: TextStyle(fontWeight: FontWeight.bold)),
          // const Text('4 người', style: TextStyle(color: Colors.grey)),
          // const SizedBox(height: 8),
          // const Text('Bốc xếp ngoài giờ: (Khi nhân viên bốc xếp)',
          //     style: TextStyle(fontWeight: FontWeight.bold)),
          // const Text('476.000đ/giờ', style: TextStyle(color: Colors.grey)),
        ],
      ),
    );
  }

  Widget buildContactCard(
      {required OrderEntity order, required ProfileEntity? profileUserAssign}) {
    return Container(
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
      child: Row(
        children: [
          CircleAvatar(
            backgroundImage: NetworkImage('${profileUserAssign?.avatarUrl}'),
            radius: 25,
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(order.review != null ? order.review! : '',
                    style: const TextStyle(fontWeight: FontWeight.bold)),
                Text('${profileUserAssign?.name}',
                    style: const TextStyle(color: Colors.grey)),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Colors.orange,
              borderRadius: BorderRadius.circular(20),
            ),
            child: const Icon(Icons.phone, color: Colors.white, size: 20),
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
        child: Text(text,
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
      ),
    );
  }
}
