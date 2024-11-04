// available_vehicles_screen.dart

import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:movemate/configs/routes/app_router.dart';
import 'package:movemate/features/booking/domain/entities/service_truck/inverse_parent_service_entity.dart';
import 'package:movemate/features/booking/presentation/providers/booking_provider.dart';
import 'package:movemate/features/booking/presentation/screens/service_screen/service_controller.dart';
import 'package:movemate/features/booking/presentation/widgets/vehicles_screen/vehicle_list.dart';

// Hooks
import 'package:movemate/hooks/use_fetch.dart';

// Widgets and Extensions
import 'package:movemate/models/request/paging_model.dart';
import 'package:movemate/utils/commons/widgets/widgets_common_export.dart';
import 'package:movemate/utils/constants/asset_constant.dart';


// Data - Entity
import 'package:movemate/features/booking/presentation/widgets/booking_screen_2th/export_booking_screen_2th.dart';

@RoutePage()
class AvailableVehiclesScreen extends HookConsumerWidget {
  const AvailableVehiclesScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final size = MediaQuery.sizeOf(context);
    final scrollController = useScrollController();

    final bookingState = ref.watch(bookingProvider); // Watch the booking state
    final bookingNotifier =
        ref.read(bookingProvider.notifier); // Read the booking notifier

    final controller = ref.read(serviceControllerProvider.notifier);

    final fetchResult = useFetch<InverseParentServiceEntity>(
      function: (model, context) async {
        return await controller.getServicesTruck(model, context);
      },
      initialPagingModel: PagingModel(
        type: 'TRUCK',
      ),
      context: context,
    );

    // useEffect(() {
    //   scrollController.onScrollEndsListener(fetchResult.loadMore);
    //   return () {
    //     scrollController.dispose();
    //   };
    // }, [scrollController, fetchResult.loadMore]);

    return Scaffold(
      appBar: CustomAppBar(
        title: 'Phương tiện có sẵn',
        iconFirst: Icons.refresh_rounded,
        onCallBackFirst: fetchResult.refresh,
        backButtonColor: AssetsConstants.whiteColor,
      ),
      body: Column(
        children: [
          SizedBox(height: size.height * 0.02),
          Expanded(
            child: VehicleList(
              fetchResult: fetchResult,
              scrollController: scrollController,
              bookingNotifier: bookingNotifier,
              bookingState: bookingState,
            ),
          ),
        ],
      ),
      bottomNavigationBar: SummarySection(
        buttonText: "Bước tiếp theo",
        priceLabel: 'Giá',
        buttonIcon: false,
        totalPrice: bookingState.totalPrice ?? 0.0,
        isButtonEnabled: bookingState.selectedVehicle != null,
        onPlacePress: () async {
          if (bookingState.selectedVehicle != null &&
              bookingState.houseType?.id != null) {
            // Hiển thị một dialog chờ
            showDialog(
              context: context,
              barrierDismissible: false,
              builder: (context) =>
                  const Center(child: CircularProgressIndicator()),
            );

            // Đóng dialog chờ
            Navigator.of(context).pop();

            context.router.push(const BookingScreenServiceRoute());
          } else {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                  content: Text('Vui lòng chọn phương tiện phù hợp')),
            );
          }
        },
      ),
    );
  }
}
