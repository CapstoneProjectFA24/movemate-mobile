import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:movemate/configs/routes/app_router.dart';
import 'package:movemate/features/order/domain/entites/order_entity.dart';
import 'package:movemate/features/profile/domain/entities/profile_entity.dart';
import 'package:movemate/services/chat_services/models/chat_model.dart';
import 'package:movemate/services/realtime_service/booking_realtime_entity/booking_realtime_entity.dart';
import 'package:movemate/utils/constants/asset_constant.dart';

class ContactCard extends HookConsumerWidget {
  final OrderEntity order;
  final ProfileEntity? profileUserAssign;
  final AssignmentsRealtimeEntity? staffAssignment;

  const ContactCard({
    super.key,
    required this.order,
    required this.profileUserAssign,
    required this.staffAssignment,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
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
                  backgroundImage: NetworkImage(profileUserAssign?.avatarUrl ??
                      'assets/images/profile/Image.png'),
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
                  staffRole: convertToStaffRole(staffAssignment!.staffType),
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
}
