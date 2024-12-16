import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:auto_route/auto_route.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:movemate/configs/routes/app_router.dart';
import 'package:movemate/features/booking/domain/entities/booking_response/assignment_response_entity.dart';
import 'package:movemate/features/booking/domain/entities/booking_response/booking_response_entity.dart';
import 'package:movemate/features/booking/presentation/screens/controller/booking_controller.dart';
import 'package:movemate/features/order/domain/entites/order_entity.dart';
import 'package:movemate/features/order/presentation/screens/order_detail_screen.dart/order_details_screen.dart';
import 'package:movemate/features/profile/domain/entities/profile_entity.dart';
import 'package:movemate/features/profile/domain/entities/staff_profile_entity.dart';
import 'package:movemate/features/profile/presentation/controllers/profile_controller/profile_controller.dart';
import 'package:movemate/features/profile/presentation/controllers/profile_driver_controller/profile_driver_controller.dart';
import 'package:movemate/hooks/use_booking_status.dart';
import 'package:movemate/hooks/use_fetch_obj.dart';
import 'package:movemate/services/realtime_service/booking_realtime_entity/booking_realtime_entity.dart';
import 'package:movemate/services/realtime_service/booking_status_realtime/booking_status_stream_provider.dart';
import 'package:movemate/utils/commons/widgets/loading_overlay.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

// Navigation function cho cả Driver và Porter
void navigateToChatScreen({
  required BuildContext context,
  required String userId,
  required String name,
  required String? avatarUrl,
  required String role, // 'driver' hoặc 'porter'
  required int orderId,
}) {
  if (role == 'driver') {
    context.router.push(
      ChatWithStaffScreenRoute(
        staffId: userId.toString(),
        staffName: name ?? 'Nhân viên',
        staffRole: convertToStaffRole(role.toUpperCase()),
        staffImageAvatar: avatarUrl ?? '',
        bookingId: orderId.toString(),
      ),
    );
  } else if (role == 'porter') {
    context.router.push(
      ChatWithStaffScreenRoute(
        staffId: userId.toString(),
        staffName: name ?? 'Nhân viên',
        staffRole: convertToStaffRole(role.toUpperCase()),
        staffImageAvatar: avatarUrl ?? '',
        bookingId: orderId.toString(),
      ),
    );
  }
}

// Widget được sửa đổi để thêm chức năng chat
class ListItemWidget extends HookConsumerWidget {
  final AssignmentsRealtimeEntity item;
  final AssignmentsRealtimeEntity? selectedValue;
  final ValueNotifier<AssignmentsRealtimeEntity?> selectionNotifier;
  final OrderEntity order;
  final IconData icon;
  final Color iconColor;
  final String subtitle;
  final String role; // Thêm role để xác định loại người dùng
  final int orderId;
  const ListItemWidget({
    super.key,
    required this.item,
    required this.selectedValue,
    required this.selectionNotifier,
    required this.icon,
    required this.iconColor,
    required this.subtitle,
    required this.role,
    required this.orderId,
    required this.order,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // final state = ref.watch(profileControllerProvider);
    final isSelected = selectedValue == item;

    final state = ref.watch(profileDriverControllerProvider);
    final useFetchResultProfileAssign = useFetchObject<StaffProfileEntity>(
      function: (context) async {
        return ref
            .read(profileDriverControllerProvider.notifier)
            .getProfileDriverInforById(item.userId, context);
      },
      context: context,
    );

    final staffInformation = useFetchResultProfileAssign.data;

    final staffProFile = useFetchResultProfileAssign;
    final bookingAsync = ref.watch(bookingStreamProvider(order.id.toString()));
    final bookingStatus =
        useBookingStatus(bookingAsync.value, order.isReviewOnline ?? false);

    final FirebaseFirestore firestore = FirebaseFirestore.instance;
    final bookingData = useState<Map<String, dynamic>?>(null);

    useEffect(() {
      // Tạo subscription để lắng nghe thay đổi
      final subscription = firestore
          .collection('bookings')
          .doc(order.id.toString())
          .snapshots()
          .listen((snapshot) {
        if (snapshot.exists) {
          bookingData.value = snapshot.data();
        }
      });

      return () => subscription.cancel();
    }, []);

    Map<String, bool> getDriverAssignmentStatus(List assignments) {
      final staffAssignment = assignments.firstWhere(
          (a) => a['StaffType'] == 'DRIVER' && a['UserId'] == item.userId,
          orElse: () => null);

      if (staffAssignment == null) {
        return {
          'isDriverWaiting': false,
          'isDriverAssigned': false,
          'isDriverIncoming': false,
          'isDriverArrived': false,
          'isDriverInprogress': false,
          'isDriverCompleted': false,
          'isDriverFailed': false,
        };
      }

      return {
        'isDriverWaiting': staffAssignment['Status'] == 'WAITING',
        'isDriverAssigned': staffAssignment['Status'] == 'ASSIGNED',
        'isDriverIncoming': staffAssignment['Status'] == 'INCOMING',
        'isDriverArrived': staffAssignment['Status'] == 'ARRIVED',
        'isDriverInprogress': staffAssignment['Status'] == 'IN_PROGRESS',
        'isDriverCompleted': staffAssignment['Status'] == 'COMPLETED',
        'isDriverFailed': staffAssignment['Status'] == 'FAILED',
      };
    }

    Map<String, bool> getPorterAssignmentStatus(List assignments) {
      final staffAssignment = assignments.firstWhere(
          (a) => a['StaffType'] == 'PORTER' && a['UserId'] == item.userId,
          orElse: () => null);

      if (staffAssignment == null) {
        return {
          'isPorterWaiting': false,
          'isPorterAssigned': false,
          'isPorterIncoming': false,
          'isPorterArrived': false,
          'isPorterInprogress': false,
          'isPorterPacking': false,
          'isPorterOngoing': false,
          'isPorterDelivered': false,
          'isPorterUnloaded': false,
          'isPorterCompleted': false,
          'isPorterFailed': false,
        };
      }

      return {
        'isPorterWaiting': staffAssignment['Status'] == "WAITING",
        'isPorterAssigned': staffAssignment['Status'] == "ASSIGNED",
        'isPorterIncoming': staffAssignment['Status'] == "INCOMING",
        'isPorterArrived': staffAssignment['Status'] == "ARRIVED",
        'isPorterInprogress': staffAssignment['Status'] == "IN_PROGRESS",
        'isPorterPacking': staffAssignment['Status'] == "PACKING",
        'isPorterOngoing': staffAssignment['Status'] == "ONGOING",
        'isPorterDelivered': staffAssignment['Status'] == "DELIVERED",
        'isPorterUnloaded': staffAssignment['Status'] == "UNLOADED",
        'isPorterCompleted': staffAssignment['Status'] == "COMPLETED",
        'isPorterFailed': staffAssignment['Status'] == "FAILED",
      };
    }

    final canCheckDriverTracking = bookingStatus.isDriverProcessingMoving;
    final canCheckPorterTracking = bookingStatus.isPorterProcessingMoving;

    bool canShowMap(String staffType, BookingStatusResult bookingStatus) {
      switch (staffType.toUpperCase()) {
        case "DRIVER":
          return bookingStatus.isDriverProcessingMoving;
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
        case "PORTER":
          context.router.push(PorterTrackingMapRoute(
            staffId: userId,
            job: order,
            bookingStatus: bookingStatus,
          ));

          break;
      }
    }

    final checkStaffTypeDriver = item.staffType.toUpperCase() == "DRIVER";
    final checkStaffTypePorter = item.staffType.toUpperCase() == "PORTER";

    final canShowCheckImage = item.isResponsible == true;

    if (bookingData.value == null) {
      return const Center(child: CircularProgressIndicator());
    }

    return LoadingOverlay(
      isLoading: state.isLoading,
      child: Card(
        elevation: 0,
        margin: const EdgeInsets.symmetric(vertical: 4),
        color: isSelected ? Colors.orange.shade50 : Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
          side: BorderSide(
            color: isSelected ? Colors.orange.shade100 : Colors.grey.shade200,
            width: 1,
          ),
        ),
        child: InkWell(
          borderRadius: BorderRadius.circular(12),
          onTap: () {
            selectionNotifier.value = isSelected ? null : item;
          },
          child: Padding(
            padding: const EdgeInsets.all(12),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: iconColor.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: staffProFile.data?.avatarUrl != null &&
                          staffProFile.data!.avatarUrl!.isNotEmpty
                      ? Image.network(
                          staffProFile.data!.avatarUrl!,
                          width: 20,
                          height: 20,
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) {
                            // Hiển thị Icon nếu có lỗi khi tải hình ảnh
                            return Icon(
                              icon, // Biến `icon` nên được định nghĩa trước đây
                              color: iconColor,
                              size: 20,
                            );
                          },
                          loadingBuilder: (context, child, loadingProgress) {
                            if (loadingProgress == null) return child;
                            return SizedBox(
                              width: 20,
                              height: 20,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                value: loadingProgress.expectedTotalBytes !=
                                        null
                                    ? loadingProgress.cumulativeBytesLoaded /
                                        (loadingProgress.expectedTotalBytes ??
                                            1)
                                    : null,
                              ),
                            );
                          },
                        )
                      : Icon(
                          icon, // Biến `icon` nên được định nghĩa trước đây
                          color: iconColor,
                          size: 20,
                        ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      FittedBox(
                        child: Row(
                          children: [
                            Text(
                              ' ${staffProFile.data?.name ?? ''}',
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            const SizedBox(width: 8),
                            if (bookingData.value != null &&
                                bookingData.value!['Assignments'] != null)
                              Builder(
                                builder: (context) {
                                  final assignments =
                                      bookingData.value!['Assignments'] as List;
                                  if (item.staffType.toUpperCase() ==
                                      'DRIVER') {
                                    final driverStatus =
                                        getDriverAssignmentStatus(assignments);
                                    final status = driverStatus.entries
                                        .firstWhere(
                                            (entry) => entry.value == true,
                                            orElse: () => const MapEntry(
                                                'isDriverWaiting', true))
                                        .key
                                        .replaceAll('isDriver', '')
                                        .toUpperCase();
                                    return StatusBadge(
                                      status: status.toDisplayText(),
                                      backgroundColor: status.getStatusColor(),
                                      textColor: status.getTextColor(),
                                    );
                                  } else if (item.staffType.toUpperCase() ==
                                      'PORTER') {
                                    final porterStatus =
                                        getPorterAssignmentStatus(assignments);
                                    final status = porterStatus.entries
                                        .firstWhere(
                                            (entry) => entry.value == true,
                                            orElse: () => const MapEntry(
                                                'isPorterWaiting', true))
                                        .key
                                        .replaceAll('isPorter', '')
                                        .toUpperCase();
                                    return StatusBadge(
                                      status: status.toDisplayText(),
                                      backgroundColor: status.getStatusColor(),
                                      textColor: status.getTextColor(),
                                    );
                                  }
                                  return const SizedBox.shrink();
                                },
                              ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 12),
                      FittedBox(
                        child: Row(
                          children: [
                            Text(
                              subtitle,
                              style: TextStyle(
                                fontSize: 14,
                                color: Colors.grey.shade600,
                              ),
                            ),
                            const SizedBox(width: 4),
                            Text(
                              '-',
                              style: TextStyle(
                                fontSize: 14,
                                color: Colors.grey.shade600,
                              ),
                            ),
                            const SizedBox(width: 4),
                            Text(
                              staffProFile.data?.phone ?? '',
                              style: TextStyle(
                                fontSize: 14,
                                color: Colors.grey.shade600,
                              ),
                            ),
                          ],
                        ),
                      ),
                      if (canShowCheckImage) const SizedBox(height: 13),
                      if (canShowCheckImage)
                        InkWell(
                          onTap: () {
                            if (item.staffType == 'DRIVER') {
                              print('check xem hinh tai xe');
                              context.router.push(
                                  DriverUploadedImageScreenRoute(job: order));
                            } else {
                              context.router.push(
                                  PorterUploadedImageScreenRoute(job: order));
                              print('check xem hinh boc vac');
                            }

                            // context.router.push();
                          },
                          child: FittedBox(
                            child: Row(
                              children: [
                                if (checkStaffTypeDriver)
                                  const Text(
                                    ' Xem hình ảnh cập nhật tài xế',
                                    style: TextStyle(
                                      fontSize: 12,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                if (checkStaffTypePorter)
                                  const Text(
                                    ' Xem hình ảnh cập nhật bốc vác',
                                    style: TextStyle(
                                      fontSize: 12,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                              ],
                            ),
                          ),
                        ),
                    ],
                  ),
                ),
                // Thêm nút chat
                if (item.isResponsible == true)
                  Positioned(
                    right: 0,
                    child: Row(
                      children: [
                        if (canShowMap(item.staffType, bookingStatus) &&
                            (canCheckDriverTracking || canCheckPorterTracking))
                          IconButton(
                            icon: FaIcon(
                              FontAwesomeIcons.mapLocation,
                              size: 18,
                              color: Colors.grey.shade600,
                            ),
                            onPressed: () => handleMapNavigation(
                              context,
                              item.staffType,
                              item.userId.toString(),
                            ),
                          ),
                        IconButton(
                          icon: const Icon(Icons.chat_bubble_outline),
                          onPressed: () {
                            if (staffProFile.data != null) {
                              navigateToChatScreen(
                                context: context,
                                userId: item.userId.toString(),
                                name: staffProFile.data!.name ?? '',
                                avatarUrl: staffProFile.data!.avatarUrl,
                                role: role,
                                orderId: orderId,
                              );
                            }
                          },
                        ),
                      ],
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// Status Badge Widget
class StatusBadge extends StatelessWidget {
  final String status;
  final Color backgroundColor;
  final Color textColor;

  const StatusBadge({
    super.key,
    required this.status,
    required this.backgroundColor,
    required this.textColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        status,
        style: TextStyle(
          color: textColor,
          fontSize: 12,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}

extension StatusDisplay on String {
  String toDisplayText() {
    switch (this) {
      case 'WAITING':
        return 'Đang chờ';
      case 'ASSIGNED':
        return 'Đã phân công';
      case 'INCOMING':
        return 'Đang đến';
      case 'ARRIVED':
        return 'Đã đến';
      case 'INPROGRESS':
        return 'Đang thực hiện';
      case 'COMPLETED':
        return 'Hoàn thành';
      case 'FAILED':
        return 'Có sự cố';
      case 'PACKING':
        return 'Đang đóng gói';
      case 'ONGOING':
        return 'Đang di chuyển';
      case 'DELIVERED':
        return 'Đã vẫn chuyển';
      case 'UNLOADED':
        return 'Đã dỡ hàng';
      default:
        return this;
    }
  }

  Color getStatusColor() {
    switch (this) {
      case 'WAITING':
        return Colors.grey.shade100;
      case 'ASSIGNED':
        return Colors.blue.shade50;
      case 'INCOMING':
        return Colors.orange.shade50;
      case 'ARRIVED':
        return Colors.green.shade50;
      case 'INPROGRESS':
        return Colors.purple.shade50;
      case 'COMPLETED':
        return Colors.green.shade50;
      case 'FAILED':
        return Colors.red.shade50;
      case 'PACKING':
        return Colors.amber.shade50;
      case 'ONGOING':
        return Colors.indigo.shade50;
      case 'DELIVERED':
        return Colors.teal.shade50;
      case 'UNLOADED':
        return Colors.lime.shade50;
      default:
        return Colors.grey.shade100;
    }
  }

  Color getTextColor() {
    switch (this) {
      case 'WAITING':
        return Colors.grey.shade700;
      case 'ASSIGNED':
        return Colors.blue.shade700;
      case 'INCOMING':
        return Colors.orange.shade700;
      case 'ARRIVED':
        return Colors.green.shade700;
      case 'INPROGRESS':
        return Colors.purple.shade700;
      case 'COMPLETED':
        return Colors.green.shade700;
      case 'FAILED':
        return Colors.red.shade700;
      case 'PACKING':
        return Colors.amber.shade700;
      case 'ONGOING':
        return Colors.indigo.shade700;
      case 'DELIVERED':
        return Colors.teal.shade700;
      case 'UNLOADED':
        return Colors.lime.shade700;
      default:
        return Colors.grey.shade700;
    }
  }
}
