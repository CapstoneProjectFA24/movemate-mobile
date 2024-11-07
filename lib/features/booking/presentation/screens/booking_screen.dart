// booking_screen.dart
//route
import 'package:flutter/material.dart';
import 'package:auto_route/auto_route.dart';
import 'package:movemate/configs/routes/app_router.dart';
//screen widget
import 'package:movemate/features/booking/presentation/widgets/booking_screen_1st/image_button/booking_details.dart';
import 'package:movemate/features/booking/presentation/widgets/booking_screen_2th/export_booking_screen_2th.dart';
import 'package:movemate/features/booking/presentation/widgets/booking_screen_1st/booking_selection.dart';
import 'package:movemate/features/booking/presentation/widgets/vehicles_screen/vehicle_list.dart';
//widget utils and extensions
import 'package:movemate/utils/commons/widgets/app_bar.dart';
import 'package:movemate/utils/constants/asset_constant.dart';
import 'package:movemate/models/request/paging_model.dart';

// Hooks
import 'package:flutter_hooks/flutter_hooks.dart'; // useScrollController
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:movemate/hooks/use_fetch.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

//data and entities
import 'package:movemate/features/booking/domain/entities/service_truck/inverse_parent_service_entity.dart';

//controllers and providers
import 'package:movemate/features/booking/presentation/providers/booking_provider.dart';
import 'package:movemate/features/booking/presentation/screens/service_screen/service_controller.dart';

@RoutePage()
class BookingScreen extends HookConsumerWidget {
  const BookingScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final bookingState = ref.watch(bookingProvider);
    final bookingNotifier = ref.read(bookingProvider.notifier);

    final size = MediaQuery.sizeOf(context);
    final scrollController = useScrollController();

    final controller = ref.read(serviceControllerProvider.notifier);

    final fetchResultVehicles = useFetch<InverseParentServiceEntity>(
      function: (model, context) async {
        return await controller.getServicesTruck(model, context);
      },
      initialPagingModel: PagingModel(
        type: 'TRUCK',
      ),
      context: context,
    );

    return Scaffold(
      appBar: const CustomAppBar(
        title: 'Chọn loại nhà ',
        centerTitle: true,
        backButtonColor: AssetsConstants.whiteColor,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.only(bottom: 100),
          controller: scrollController,
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const BookingSelection(),
                const SizedBox(height: 16),
                const BookingDetails(),
                const SizedBox(height: 8),
                // SizedBox(height: size.height * 0.02),
                SizedBox(
                  height: size.height * 0.8,
                  child: VehicleList(
                    fetchResult: fetchResultVehicles,
                    scrollController: scrollController,
                    bookingNotifier: bookingNotifier,
                    bookingState: bookingState,
                  ),
                ),
                // SizedBox(height: size.height * 0.02),
              ],
            ),
          ),
        ),
      ),
      bottomNavigationBar: Consumer(
        builder: (context, ref, child) {
          final bookingState = ref.watch(bookingProvider);
          final bookingNotifier = ref.read(bookingProvider.notifier);

          return SummarySection(
            buttonIcon: false,
            buttonText: "Bước tiếp theo",
            priceLabel: "",
            isButtonEnabled: true,
            onPlacePress: () {
              if (bookingState.houseType != null &&
                  bookingState.houseType?.id != null) {
                // Validation passed, navigate to the next screen
                context.router.push(const AvailableVehiclesScreenRoute());
              } else {
                // Validation failed, set the error message
                bookingNotifier
                    .setHouseTypeError("Vui lòng chọn loại nhà phù hợp");
              }
            },
          );
        },
      ),
    );
  }
}
