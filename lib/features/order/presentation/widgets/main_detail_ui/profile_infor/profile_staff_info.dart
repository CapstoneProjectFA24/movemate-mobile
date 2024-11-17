// components/profile_info.dart

import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:movemate/configs/routes/app_router.dart';
import 'package:movemate/features/booking/domain/entities/booking_response/assignment_response_entity.dart';
import 'package:movemate/features/order/domain/entites/order_entity.dart';
import 'package:movemate/features/order/presentation/screens/driver_tracking_map/driver_tracking_map.dart';
import 'package:movemate/features/order/presentation/widgets/profile_card.dart';
import 'package:movemate/features/profile/domain/entities/staff_profile_entity.dart';
import 'package:movemate/features/profile/presentation/controllers/profile_driver_controller/profile_driver_controller.dart';
import 'package:movemate/hooks/use_booking_status.dart';
import 'package:movemate/hooks/use_fetch_obj.dart';
import 'package:movemate/services/realtime_service/booking_status_realtime/booking_status_stream_provider.dart';
import 'package:movemate/utils/commons/widgets/widgets_common_export.dart';
import 'package:auto_route/auto_route.dart';

class ProfileStaffInfo extends HookConsumerWidget {
  final AssignmentResponseEntity staffAssignment;
  final OrderEntity order;
  const ProfileStaffInfo({
    required this.staffAssignment,
    required this.order,
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(profileDriverControllerProvider);
    final useFetchResultProfileAssign = useFetchObject<StaffProfileEntity>(
      function: (context) async {
        return ref
            .read(profileDriverControllerProvider.notifier)
            .getProfileDriverInforById(staffAssignment.userId, context);
      },
      context: context,
    );
    final staff = useFetchResultProfileAssign.data;
    final bookingAsync = ref.watch(bookingStreamProvider(order.id.toString()));
    final bookingStatus =
        useBookingStatus(bookingAsync.value, order.isReviewOnline);
    final isStateController = state.isLoading;

    String getCardTitle(String staffType) {
      switch (staffType.toUpperCase()) {
        case "DRIVER":
          return "Thông tin tài xế";
        case "POSTER":
          return "Thông tin người bốc vác";
        case "REVIEWER":
          return "Thông tin người đánh giá";
        default:
          return "Thông tin tài xế";
      }
    }

    bool canShowMap() {
      switch (staffAssignment.staffType.toUpperCase()) {
        case "DRIVER":
          return bookingStatus.isDriverProcessingMoving;
        case "REVIEWER":
          return bookingStatus.isReviewerMoving;
        case "PORTER":
          return bookingStatus.isPorterProcessingMoving;
        default:
          return false;
      }
    }

    void handleMapNavigation() {
      switch (staffAssignment.staffType.toUpperCase()) {
        case "DRIVER":
          context.router.push(TrackingDriverMapRoute(
            staffId: staffAssignment.userId.toString(),
            job: order,
            bookingStatus: bookingStatus,
          ));
          break;
        case "REVIEWER":
          // Uncomment và customize route cho Reviewer khi cần
          // context.router.push(TrackingReviewerMapRoute(
          //   staffId: staffAssignment.userId.toString(),
          //   role: "REVIEWER",
          //   job: order,
          // ));
          break;
        case "PORTER":
          // Thêm route cho Porter nếu cần
          // context.router.push(TrackingPorterMapRoute(
          //   staffId: staffAssignment.userId.toString(),
          //   role: "PORTER",
          //   job: order,
          // ));
          break;
      }
    }

    return LoadingOverlay(
      isLoading: isStateController,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: ProfileCard(
          title: getCardTitle(staffAssignment.staffType),
          profileImageUrl: staff?.avatarUrl ??
              'https://storage.googleapis.com/a1aa/image/kQqIOadQcVp4CFdZfMh5llKP6sUMpfDr5KIUucyHmaXaArsTA.jpg',
          name: '${staff?.name}',
          // rating: staff?.codeIntroduce ?? '4.5',
          ratingDetails: '${staff?.phone}',
          onPhonePressed: () {
            // Handle phone icon press
          },
          onCommentPressed: handleMapNavigation,
          iconCall: true,
          iconLocation: canShowMap(),
          // iconLocation: true,
        ),
      ),
    );
  }
}
