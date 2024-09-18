import 'package:flutter/material.dart';
import 'package:auto_route/auto_route.dart';
import 'package:movemate/configs/routes/app_router.dart';
import 'package:movemate/utils/constants/asset_constant.dart';
import 'package:movemate/features/booking/presentation/screens/booking_details.dart';
import 'package:movemate/features/booking/presentation/widgets/booking_selection.dart';
import 'package:movemate/features/booking/presentation/providers/booking_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

@RoutePage()

@RoutePage()
class BookingScreen extends ConsumerWidget {
  const BookingScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
   
    final bookingState = ref.watch(bookingProvider);
    final bookingNotifier = ref.watch(bookingProvider.notifier);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Thông tin đặt hàng'),
        backgroundColor: AssetsConstants.mainColor,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            BookingSelection(
              onHouseTypeSelected: (selectedType) {
                bookingNotifier.updateHouseType(selectedType);
              },
              onRoomCountSelected: (count) {
                bookingNotifier.updateNumberOfRooms(count);
              },
              onFloorCountSelected: (count) {
                bookingNotifier.updateNumberOfFloors(count);
              },
            ),
            const SizedBox(height: 16),
            
            BookingDetails(
              houseType: bookingState.houseType,
              numberOfRooms: bookingState.numberOfRooms ?? 0,
              numberOfFloors: bookingState.numberOfFloors ?? 0,
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                context.router.push(AvailableVehiclesScreenRoute());
              },
              child: const Text('Tiếp tục'),
            ),
          ],
        ),
      ),
    );
  }
}
