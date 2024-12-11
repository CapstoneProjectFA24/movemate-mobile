import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:movemate/features/booking/domain/entities/house_type_entity.dart';
import 'package:movemate/features/booking/presentation/screens/controller/service_package_controller.dart';
import 'package:movemate/features/order/domain/entites/order_entity.dart';
import 'package:movemate/features/order/presentation/controllers/order_controller/order_controller.dart';
import 'package:movemate/hooks/use_fetch_obj.dart';
import 'package:movemate/utils/commons/widgets/widgets_common_export.dart';

class HouseInformationAtHome extends HookConsumerWidget {
  final OrderEntity order;
  final OrderEntity? orderOld;

  const HouseInformationAtHome({
    required this.order,
    required this.orderOld,
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(servicePackageControllerProvider);

    // Format date and time for new order
    final formattedDateNew = DateFormat('dd-MM-yyyy')
        .format(DateTime.parse(order.bookingAt.toString()));
    final formattedTimeNew =
        DateFormat('HH:mm').format(DateTime.parse(order.bookingAt.toString()));

    // Format date and time for old order
    final formattedDateOld = orderOld != null
        ? DateFormat('dd-MM-yyyy')
            .format(DateTime.parse(orderOld!.bookingAt.toString()))
        : null;
    final formattedTimeOld = orderOld != null
        ? DateFormat('HH:mm')
            .format(DateTime.parse(orderOld!.bookingAt.toString()))
        : null;

    final useFetchResultNew = useFetchObject<HouseTypeEntity>(
      function: (context) => ref
          .read(servicePackageControllerProvider.notifier)
          .getHouseTypeById(order.houseTypeId, context),
      context: context,
    );
    final useFetchResultOld = useFetchObject<HouseTypeEntity>(
      function: (context) => ref
          .read(servicePackageControllerProvider.notifier)
          .getHouseTypeById(orderOld!.houseTypeId, context),
      context: context,
    );

    // final houseTypeDataOld = useFetchResultOld.data;
    // final houseTypeDataNew = useFetchResultNew.data;

    final houseTypeDataOld = useFetchResultOld.data;

    // Add null check before using
    final houseTypeOld = houseTypeDataOld?.name ?? "Unknown";

    // Get house type, floor and room information for both old and new orders
    final houseTypeNew = houseTypeDataOld?.name ?? "Unknown";
    final floorNumberNew = order.floorsNumber.toString() ?? "Unknown";
    final roomNumberNew = order.roomNumber.toString() ?? "Unknown";

    // final houseTypeOld = houseTypeDataOld?.name ?? "Unknown";
    final floorNumberOld = orderOld?.floorsNumber.toString() ?? "Unknown";
    final roomNumberOld = orderOld?.roomNumber.toString() ?? "Unknown";

    final bool checkDateTime = formattedDateNew == formattedDateOld &&
        formattedTimeOld == formattedTimeNew;
    print('check house type 1  ${useFetchResultNew.data}');
    print('check house type 1.111  ${orderOld!.houseTypeId}');
    print('check house type 1.1  ${useFetchResultOld.data}');
    print('check house type 2 $houseTypeOld');

    if (useFetchResultOld.isFetchingData) {
      return const Center(child: CircularProgressIndicator());
    }

    return LoadingOverlay(
      isLoading: state.isLoading,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // Compare house type for old and new orders
              _buildHouseTypeColumn(houseTypeOld, houseTypeNew),
              const SizedBox(width: 16),

              // Compare floor number for old and new orders
              _buildFloorColumn(floorNumberOld, floorNumberNew),
              const SizedBox(width: 16),

              // Compare room number for old and new orders
              _buildRoomColumn(roomNumberOld, roomNumberNew),
            ],
          ),
          const SizedBox(height: 16),

          // Row for displaying moving date and time
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              _buildDateAndTimeColumn(
                  formattedDateOld, formattedDateNew, checkDateTime),
              // Display time
              _buildTimeColumn(
                  formattedTimeOld, formattedTimeNew, checkDateTime),
            ],
          ),
        ],
      ),
    );
  }

  Column _buildHouseTypeColumn(String houseTypeOld, String houseTypeNew) {
    return Column(
      children: [
        const LabelText(
          content: 'Loại nhà : ',
          size: 14,
          fontWeight: FontWeight.w400,
        ),
        if (houseTypeNew == houseTypeOld)
          LabelText(
            content: houseTypeNew,
            size: 14,
            fontWeight: FontWeight.bold,
          )
        else ...[
          LabelText(
            content: houseTypeOld,
            size: 14,
            fontWeight: FontWeight.bold,
            color: Colors.red,
          ),
          const SizedBox(height: 5),
          LabelText(
            content: houseTypeNew,
            size: 14,
            fontWeight: FontWeight.bold,
            color: Colors.green,
          ),
        ],
      ],
    );
  }

  Column _buildFloorColumn(String floorNumberOld, String floorNumberNew) {
    return Column(
      children: [
        const LabelText(
          content: 'Tầng ',
          size: 14,
          fontWeight: FontWeight.w400,
        ),
        if (floorNumberNew == floorNumberOld)
          LabelText(
            content: floorNumberNew,
            size: 14,
            fontWeight: FontWeight.bold,
          )
        else ...[
          LabelText(
            content: floorNumberOld,
            size: 14,
            fontWeight: FontWeight.bold,
            color: Colors.red,
          ),
          const SizedBox(height: 5),
          LabelText(
            content: floorNumberNew,
            size: 14,
            fontWeight: FontWeight.bold,
            color: Colors.green,
          ),
        ],
      ],
    );
  }

  Column _buildRoomColumn(String roomNumberOld, String roomNumberNew) {
    return Column(
      children: [
        const LabelText(
          content: 'Phòng ',
          size: 14,
          fontWeight: FontWeight.w400,
        ),
        if (roomNumberNew == roomNumberOld)
          LabelText(
            content: roomNumberNew,
            size: 14,
            fontWeight: FontWeight.bold,
          )
        else ...[
          LabelText(
            content: roomNumberOld,
            size: 14,
            fontWeight: FontWeight.bold,
            color: Colors.red,
          ),
          const SizedBox(height: 5),
          LabelText(
            content: roomNumberNew,
            size: 14,
            fontWeight: FontWeight.bold,
            color: Colors.green,
          ),
        ],
      ],
    );
  }

  Column _buildDateAndTimeColumn(
      String? formattedDateOld, String? formattedDateNew, bool checkDateTime) {
    return Column(
      children: [
        Row(
          children: [
            const LabelText(
              content: 'Ngày dọn nhà : ',
              size: 14,
              fontWeight: FontWeight.w400,
            ),
            if (checkDateTime)
              LabelText(
                content: formattedDateNew ?? "label",
                size: 14,
                fontWeight: FontWeight.bold,
              )
            else ...[
              Column(
                children: [
                  LabelText(
                    content: formattedDateOld ?? "label",
                    size: 14,
                    fontWeight: FontWeight.bold,
                    color: !checkDateTime ? Colors.red : Colors.black,
                  ),
                  LabelText(
                    content: formattedDateNew ?? "label",
                    size: 14,
                    fontWeight: FontWeight.bold,
                    color: !checkDateTime ? Colors.green : Colors.black,
                  ),
                ],
              ),
              const SizedBox(height: 5),
            ],
          ],
        ),
      ],
    );
  }

  Column _buildTimeColumn(
      String? formattedTimeOld, String? formattedTimeNew, bool checkDateTime) {
    return Column(
      children: [
        if (checkDateTime)
          LabelText(
            content: '  ${formattedTimeNew ?? "label"}',
            size: 14,
            fontWeight: FontWeight.bold,
          )
        else ...[
          Column(
            children: [
              LabelText(
                content: '  ${formattedTimeOld ?? "label"}',
                size: 14,
                fontWeight: FontWeight.bold,
                color: !checkDateTime ? Colors.red : Colors.black,
              ),
              LabelText(
                content: '  ${formattedTimeNew ?? "label"}',
                size: 14,
                fontWeight: FontWeight.bold,
                color: !checkDateTime ? Colors.green : Colors.black,
              ),
            ],
          ),
          const SizedBox(height: 5),
        ],
      ],
    );
  }
}
