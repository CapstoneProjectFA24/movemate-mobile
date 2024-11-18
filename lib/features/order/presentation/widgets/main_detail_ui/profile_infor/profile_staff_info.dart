import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:auto_route/auto_route.dart';
import 'package:movemate/configs/routes/app_router.dart';
import 'package:movemate/features/booking/domain/entities/booking_response/assignment_response_entity.dart';
import 'package:movemate/features/order/domain/entites/order_entity.dart';
import 'package:movemate/features/order/presentation/screens/driver_tracking_map/driver_tracking_map.dart';
import 'package:movemate/features/order/presentation/widgets/profile_card.dart';
import 'package:movemate/features/profile/domain/entities/staff_profile_entity.dart';
import 'package:movemate/features/profile/presentation/controllers/profile_driver_controller/profile_driver_controller.dart';
import 'package:movemate/hooks/use_booking_status.dart';
import 'package:movemate/hooks/use_fetch_obj.dart';
import 'package:movemate/services/chat_services/models/chat_model.dart';
import 'package:movemate/services/realtime_service/booking_status_realtime/booking_status_stream_provider.dart';
import 'package:movemate/utils/commons/widgets/widgets_common_export.dart';

class ProfileStaffInfo extends HookConsumerWidget {
  final AssignmentResponseEntity staffAssignment;
  final OrderEntity order;

  const ProfileStaffInfo({
    required this.staffAssignment,
    required this.order,
    super.key,
  });

  StaffRole _convertToStaffRole(String staffType) {
    switch (staffType.toUpperCase()) {
      case 'DRIVER':
        return StaffRole.driver;
      case 'PORTER':
        return StaffRole.porter;
      case 'REVIEWER':
        return StaffRole.reviewer;
      default:
        return StaffRole.manager;
    }
  }

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

    bool canShowMap(String staffType, BookingStatusResult bookingStatus) {
      switch (staffType.toUpperCase()) {
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

    void handleMapNavigation(
        BuildContext context, String staffType, String userId) {
      switch (staffType.toUpperCase()) {
        case "DRIVER":
          context.router.push(TrackingDriverMapRoute(
            staffId: userId,
            job: order,
            bookingStatus: bookingStatus,
          ));
          break;
        case "REVIEWER":
          context.router.push(ReviewerTrackingMapRoute(
            staffId: userId,
            job: order,
            bookingStatus: bookingStatus,
          ));
          break;
        case "PORTER":
          // Add Porter tracking route if needed
          break;
      }
    }

    void handleChatWithStaff(BuildContext context, StaffProfileEntity? staff) {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('Liên hệ với nhân viên'),
            content: Text('Bạn có muốn chat với ${staff?.name} không?'),
            actions: [
              TextButton(
                onPressed: () => context.router.pop(),
                child: const Text('Hủy'),
              ),
              TextButton(
                onPressed: () {
                  context.router.pop();
                  context.router.push(
                    ChatWithStaffScreenRoute(
                      staffId: staffAssignment.userId.toString(),
                      staffName: staff?.name ?? 'Nhân viên',
                      staffRole: _convertToStaffRole(staffAssignment.staffType),
                      bookingId: order.id.toString(),
                    ),
                  );
                },
                child: const Text('Chat ngay'),
              ),
            ],
          );
        },
      );
    }

    return LoadingOverlay(
      isLoading: isStateController,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: ProfileCard(
          title: getCardTitle(staffAssignment.staffType),
          profileImageUrl: staff?.avatarUrl ??
              'https://storage.googleapis.com/a1aa/image/kQqIOadQcVp4CFdZfMh5llKP6sUMpfDr5KIUucyHmaXaArsTA.jpg',
          name: staff?.name ?? '',
          ratingDetails: staff?.phone ?? '',
          onPhonePressed: () => handleChatWithStaff(context, staff),
          onCommentPressed: () => handleMapNavigation(
            context,
            staffAssignment.staffType,
            staffAssignment.userId.toString(),
          ),
          iconCall: true,
          iconLocation: canShowMap(staffAssignment.staffType, bookingStatus),
        ),
      ),
    );
  }
}
