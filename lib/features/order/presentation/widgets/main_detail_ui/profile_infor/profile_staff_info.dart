// components/profile_info.dart

import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:movemate/features/booking/domain/entities/booking_response/assignment_response_entity.dart';
import 'package:movemate/features/order/presentation/widgets/profile_card.dart';
import 'package:movemate/features/profile/domain/entities/profile_entity.dart';
import 'package:movemate/features/profile/domain/entities/staff_profile_entity.dart';
import 'package:movemate/features/profile/presentation/controllers/profile_controller/profile_controller.dart';
import 'package:movemate/features/profile/presentation/controllers/profile_driver_controller/profile_driver_controller.dart';
import 'package:movemate/hooks/use_fetch_obj.dart';
import 'package:movemate/utils/commons/widgets/widgets_common_export.dart';

class ProfileStaffInfo extends HookConsumerWidget {
  final AssignmentResponseEntity staffAssignment;
  const ProfileStaffInfo({
    required this.staffAssignment,
    super.key,
  });

  // You can pass data as parameters if needed

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

    final isStateController = state.isLoading;
    final isFetchingData = useFetchResultProfileAssign.isFetchingData;

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
          onCommentPressed: () {
            // Handle comment icon press
          },
          iconCall: true,
          iconLocation: true,
        ),
      ),
    );
  }
}
