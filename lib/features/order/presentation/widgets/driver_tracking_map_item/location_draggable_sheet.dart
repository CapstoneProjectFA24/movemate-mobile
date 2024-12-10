import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:movemate/features/booking/domain/entities/booking_response/booking_detail_response_entity.dart';
import 'package:movemate/features/booking/domain/entities/house_type_entity.dart';
import 'package:movemate/features/order/domain/entites/order_entity.dart';
import 'package:movemate/features/profile/domain/entities/staff_profile_entity.dart';
import 'package:movemate/features/profile/presentation/controllers/profile_driver_controller/profile_driver_controller.dart';
import 'package:movemate/hooks/use_fetch_obj.dart';
import 'package:movemate/models/user_model.dart';
import 'package:movemate/services/realtime_service/booking_realtime_entity/booking_realtime_entity.dart';
import 'package:movemate/services/realtime_service/booking_status_realtime/booking_status_stream_provider.dart';
import 'package:movemate/utils/commons/widgets/format_price.dart';
import 'package:movemate/utils/providers/common_provider.dart';

class DeliveryDetailsBottomSheet extends HookConsumerWidget {
  final OrderEntity job;
  final int stadffId;
  const DeliveryDetailsBottomSheet(
      {super.key, required this.job, required this.stadffId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final bookingAsync = ref.watch(bookingStreamProvider(job.id.toString()));
    // final bookingStatus =
    //     useBookingStatus(bookingAsync.value, job.isReviewOnline);
    // final state = ref.watch(servicePackageControllerProvider);
    // final stateProfile = ref.watch(profileControllerProvider);

    // final bookingControllerHouse =
    //     ref.read(servicePackageControllerProvider.notifier);

    // Sử dụng useFetchObject để gọi getHouseDetails
    // final useFetchResult = useFetchObject<HouseTypeEntity>(
    //   function: (context) => ref
    //       .read(servicePackageControllerProvider.notifier)
    //       .getHouseTypeById(job.houseTypeId, context),
    //   context: context,
    // );
    // final houseTypeById = useFetchResult.data;
    final userdata = ref.read(authProvider);

    final useFetchResultProfileAssign = useFetchObject<StaffProfileEntity>(
      function: (context) async {
        return ref
            .read(profileDriverControllerProvider.notifier)
            .getProfileDriverInforById(stadffId, context);
      },
      context: context,
    );
    final profileUserAssign = useFetchResultProfileAssign.data;

    final bookingAssignment =
        bookingAsync.value?.assignments.firstWhere((e) => e.userId == stadffId);

    // final bookingTruck =
    //     bookingAsync.value?.bookingDetails.firstWhere((e) => e.type == 'TRUCK');

    if (bookingAssignment == null ||
        // bookingTruck == null ||
        profileUserAssign == null) {
      return const Center(
        child: CircularProgressIndicator(),
      );
    }

    return DraggableScrollableSheet(
      initialChildSize: 0.4,
      minChildSize: 0.25,
      maxChildSize: 0.8,
      builder: (context, scrollController) {
        return Container(
          color: Colors.transparent, // Màu nền tránh lỗi render
          child: SingleChildScrollView(
            controller: scrollController,
            child: Column(
              children: [
                // _buildDeliveryStatusCard(job: job, status: bookingStatus),
                _buildTrackingInfoCard(
                  job: job,
                  // status: bookingStatus,
                  context: context,
                  profileUserAssign: profileUserAssign,
                  assignments: bookingAssignment,
                  // bookingTruck: bookingTruck,
                ),
                _buildDetailsSheet(
                  context: context,
                  job: job,
                  // houseTypeById: houseTypeById,
                  profile: userdata,
                  // status: bookingStatus
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildTrackingInfoCard({
    required OrderEntity job,
    // required BookingStatusResult status,
    required BuildContext context,
    required StaffProfileEntity? profileUserAssign,
    required AssignmentsRealtimeEntity? assignments,
    // required BookingDetailRealTimeEntity? bookingTruck,
  }) {
    //PORTER
    //REVIEWER
    String getDriverRole() {
      try {
        // Xác định vai trò và loại nhân viên dựa trên `Assignments`
        final isResponsible = assignments?.isResponsible == true;
        final checkRole = isResponsible ? 'Trưởng' : 'Nhân viên';

        final staffType = assignments?.staffType;
        final checkType = () {
          if (staffType == 'DRIVER') {
            return 'Tài xế ${isResponsible ? 'Trưởng ' : ''}';
          } else if (staffType == 'PORTER') {
            return 'Bốc vác ${isResponsible ? 'Trưởng ' : ''}';
          } else if (staffType == 'REVIEWER') {
            return 'Người đánh giá';
          } else {
            return 'Nhân viên'; // Giá trị mặc định nếu không xác định được loại nhân viên
          }
        }();

        return checkType;
      } catch (e) {
        return 'Bốc vác'; // Giá trị mặc định nếu không tìm thấy Driver
      }
    }

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Container(
        margin: const EdgeInsets.only(bottom: 16),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(8),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          children: [
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Colors.grey[300]!),
              ),
              child: ClipRRect(
                borderRadius:
                    BorderRadius.circular(8), // Giữ bo góc cho hình ảnh
                child: Image.network(
                  profileUserAssign?.avatarUrl ??
                      'https://e7.pngegg.com/pngimages/705/224/png-clipart-user-computer-icons-avatar-miscellaneous-heroes.png',
                  fit: BoxFit
                      .cover, // Đảm bảo hình ảnh được cắt để vừa với khung
                  errorBuilder: (context, error, stackTrace) => const Icon(
                      Icons.error), // Hiển thị icon lỗi nếu tải ảnh thất bại
                ),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          getDriverRole(),
                          style:
                              Theme.of(context).textTheme.titleMedium?.copyWith(
                                    fontWeight: FontWeight.bold,
                                  ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          profileUserAssign?.name ?? '',
                          style:
                              Theme.of(context).textTheme.bodyMedium?.copyWith(
                                    color: Colors.grey[600],
                                  ),
                          overflow: TextOverflow.ellipsis,
                          maxLines: 2,
                        ),
                        Text(
                          profileUserAssign?.phone ?? '',
                          style:
                              Theme.of(context).textTheme.bodyMedium?.copyWith(
                                    color: Colors.grey[600],
                                  ),
                          overflow: TextOverflow.ellipsis,
                          maxLines: 2,
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          job.bookingDetails
                                  .firstWhere((e) => e.type == 'TRUCK')
                                  .name ??
                              '',
                          // '',
                          style: const TextStyle(
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDetailsSheet({
    required BuildContext context,
    required OrderEntity job,
    // required HouseTypeEntity? houseTypeById,
    required UserModel? profile,
    // required BookingStatusResult status,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12.0),
      child: Container(
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
          boxShadow: [
            BoxShadow(
              color: Colors.black12,
              blurRadius: 10,
              spreadRadius: 2,
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Container(
                margin: const EdgeInsets.symmetric(vertical: 12),
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: Colors.grey[300],
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // _buildSectionTitle('Thông tin dịch vụ'),
                  // const SizedBox(height: 16),
                  // _buildServiceInfo(job: job, house: houseTypeById),
                  // const SizedBox(height: 16),
                  _buildLocationInfo(job: job),
                  const SizedBox(height: 16),
                  SizedBox(
                    height: (job.bookingDetails.length * 25)
                        .toDouble(), // Fixed height for services list
                    child: SingleChildScrollView(
                      physics: const ClampingScrollPhysics(),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          //TODO: OPTIONAL field for services list have type TRUCK
                          buildServicesList(
                            job.bookingDetails,
                          ), // Hiển thị danh sách
                        ],
                      ),
                    ),
                  ),
                  const Divider(height: 32),
                  _buildSectionTitle('Thông tin khách hàng'),
                  const SizedBox(height: 16),
                  _buildCustomerInfo(profile: profile),
                  const SizedBox(height: 3),
                  // _buildConfirmationImageLink(
                  //   context: context, job: job,

                  //   // status: status
                  // ),
                  const SizedBox(height: 20),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: const TextStyle(
        fontSize: 12,
        fontWeight: FontWeight.w500,
        color: Color(0xFFFF7643),
      ),
    );
  }

  Widget _buildServiceInfo(
      {required OrderEntity job, required HouseTypeEntity? house}) {
    // print("check home ${job.userId}");
    return Row(
      children: [
        Expanded(
          flex: 2,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Loại nhà',
                style: TextStyle(
                  color: Colors.grey,
                  fontSize: 12,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                house?.name ?? '',
                style: const TextStyle(fontSize: 12),
              ),
            ],
          ),
        ),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Số tầng',
                style: TextStyle(
                  color: Colors.grey,
                  fontSize: 12,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                job.floorsNumber,
                style: const TextStyle(fontSize: 12),
              ),
            ],
          ),
        ),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Số phòng',
                style: TextStyle(
                  color: Colors.grey,
                  fontSize: 12,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                job.roomNumber,
                style: const TextStyle(fontSize: 12),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildLocationInfo({required OrderEntity job}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildLocationRow('Từ', job.pickupAddress),
        _buildLocationRow('Đến', job.deliveryAddress),
      ],
    );
  }

  Widget _buildLocationRow(String title, String address) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(
            color: Colors.grey,
            fontSize: 14,
          ),
        ),
        const SizedBox(height: 4),
        Row(
          children: [
            Expanded(
              child: Text(
                address,
                style: const TextStyle(fontSize: 14),
                maxLines: 4,
                overflow: TextOverflow.ellipsis,
              ),
            ),
            // const SizedBox(width: 12),
            // TextButton(
            //   onPressed: () {},
            //   child: const Text(
            //     'Xem thêm',
            //     style: TextStyle(
            //       color: Color(0xFFFF7643),
            //       fontSize: 14,
            //     ),
            //   ),
            // ),
          ],
        ),
      ],
    );
  }

  Widget _buildCustomerInfo({required UserModel? profile}) {
    print('check pro ${profile?.name}');
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Tên khách hàng',
              style: TextStyle(
                color: Colors.grey,
                fontSize: 14,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              profile?.name ?? '',
              style: const TextStyle(fontSize: 14),
            ),
          ],
        ),
        const SizedBox(height: 16),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Số điện thoại',
              style: TextStyle(
                color: Colors.grey,
                fontSize: 14,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              profile?.phone ?? '',
              style: const TextStyle(fontSize: 14),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildConfirmationImageLink(
      {required OrderEntity job,
      // required BookingStatusResult status,
      required BuildContext context}) {
    return GestureDetector(
      onTap: () {
        // Navigator.push(
        //   context,
        //   MaterialPageRoute(builder: (context) => const PorterConfirmScreen()),
        // );
        // context.router.push(DriverConfirmUploadRoute(
        //   job: job,
        // ));
      },
      child: const Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Xem hình ảnh xác nhận',
            style: TextStyle(
              color: Colors.blue,
              fontSize: 14,
            ),
          ),
        ],
      ),
    );
  }
}

Widget _buildProgressDot(bool isCompleted) {
  return Container(
    width: 20,
    height: 20,
    decoration: BoxDecoration(
      shape: BoxShape.circle,
      color: isCompleted ? Colors.orange : Colors.grey[300],
      border: Border.all(
        color: isCompleted ? Colors.orange : Colors.grey[300]!,
        width: 2,
      ),
    ),
    child: isCompleted
        ? const Icon(
            Icons.check,
            size: 12,
            color: Colors.white,
          )
        : null,
  );
}

Widget _buildProgressLine(bool isCompleted) {
  return Expanded(
    child: Container(
      height: 2,
      color: isCompleted ? Colors.orange : Colors.grey[300],
    ),
  );
}

Widget buildPriceItem(String description, String price) {
  return Row(
    mainAxisAlignment: MainAxisAlignment.spaceBetween,
    children: [
      Expanded(
        child: Text(
          description,
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
          style: const TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w400,
            color: Colors.black,
          ),
        ),
      ),
      Row(
        children: [
          const SizedBox(width: 12),
          Text(
            price,
            style: const TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w400,
              color: Colors.black,
            ),
          ),
          const SizedBox(width: 12),
        ],
      ),
    ],
  );
}

Widget buildServicesList(List<BookingDetailResponseEntity> bookingDetails,
    {bool isFilterByTruck = false}) {
  // Lọc các dịch vụ có type là 'TRUCK'
  // Lọc danh sách nếu cần
  final filteredServices = isFilterByTruck
      ? bookingDetails.where((detail) => detail.type == 'TRUCK').toList()
      : bookingDetails;

  // Trả về danh sách Widget để hiển thị
  return Column(
    children: filteredServices.map((detail) {
      return buildPriceItem(detail.name ?? 'Unknown Service',
          formatPrice(detail.price.toDouble() ?? 0));
    }).toList(),
  );
}
