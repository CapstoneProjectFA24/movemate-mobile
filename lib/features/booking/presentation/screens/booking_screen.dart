// booking_screen.dart
//route
import 'package:flutter/material.dart';
import 'package:auto_route/auto_route.dart';
import 'package:movemate/configs/routes/app_router.dart';
import 'package:movemate/features/booking/presentation/screens/controller/service_package_controller.dart';
//screen widget
import 'package:movemate/features/booking/presentation/widgets/booking_screen_1st/image_button/room_media_section.dart';
import 'package:movemate/features/booking/presentation/widgets/booking_screen_2th/export_booking_screen_2th.dart';
import 'package:movemate/features/booking/presentation/widgets/booking_screen_1st/booking_selection.dart';
import 'package:movemate/features/booking/presentation/widgets/vehicles_screen/vehicle_list.dart';
//widget utils and extensions
import 'package:movemate/utils/commons/widgets/app_bar.dart';
import 'package:movemate/utils/commons/widgets/form_input/label_text.dart';
import 'package:movemate/utils/commons/widgets/home_shimmer.dart';
import 'package:movemate/utils/constants/asset_constant.dart';
import 'package:movemate/models/request/paging_model.dart';

// Hooks
import 'package:flutter_hooks/flutter_hooks.dart'; // useScrollController
import 'package:movemate/hooks/use_fetch.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

//data and entities
import 'package:movemate/features/booking/domain/entities/service_truck/inverse_parent_service_entity.dart';

//controllers and providers
import 'package:movemate/features/booking/presentation/providers/booking_provider.dart';
import 'package:movemate/features/booking/presentation/screens/service_screen/service_controller.dart';

// @RoutePage()
// class BookingScreen extends HookConsumerWidget {
//   const BookingScreen({super.key});

//   @override
//   Widget build(BuildContext context, WidgetRef ref) {
//     final bookingState = ref.watch(bookingProvider);
//     final bookingNotifier = ref.read(bookingProvider.notifier);
//     final scrollController = useScrollController();
//     final controller = ref.read(serviceControllerProvider.notifier);

//     final fetchResultVehicles = useFetch<InverseParentServiceEntity>(
//       function: (model, context) async {
//         return await controller.getServicesTruck(model, context);
//       },
//       initialPagingModel: PagingModel(
//         type: 'TRUCK',
//       ),
//       context: context,
//     );

//     return Scaffold(
//       appBar: const CustomAppBar(
//         title: 'Chọn loại nhà ',
//         centerTitle: true,
//         backButtonColor: AssetsConstants.whiteColor,
//       ),
//       body: SafeArea(
//         child: Column(
//           children: [
//             Expanded(
//               child: CustomScrollView(
//                 controller: scrollController,
//                 slivers: [
//                   if (fetchResultVehicles.isFetchingData &&
//                       fetchResultVehicles.items.isEmpty)
//                     const SliverToBoxAdapter(
//                       child: SizedBox(
//                         height: 400,
//                         child: Center(child: HomeShimmer(amount: 1)),
//                       ),
//                     )
//                   else
//                     SliverPadding(
//                       padding: const EdgeInsets.all(16.0),
//                       sliver: SliverList(
//                         delegate: SliverChildListDelegate([
//                           const BookingSelection(),
//                           const SizedBox(height: 16),
//                           const RoomMediaSection(
//                             roomTitle: 'Tải ảnh lên',
//                             roomType: RoomType.livingRoom,
//                           ),
//                           const SizedBox(height: 16),
//                           Row(
//                             children: [
//                               const LabelText(
//                                 content: "Phương tiện có sẵn",
//                                 size: AssetsConstants.buttonFontSize + 1,
//                                 fontWeight: FontWeight.w600,
//                               ),
//                               if (bookingState.vehicleError != null)
//                                 Padding(
//                                   padding: const EdgeInsets.only(
//                                       top: 4.0, left: 8.0),
//                                   child: Text(
//                                     bookingState.vehicleError!,
//                                     style: const TextStyle(
//                                       color: Colors.red,
//                                       fontSize: 12,
//                                     ),
//                                   ),
//                                 ),
//                             ],
//                           ),
//                           VehicleList(
//                             fetchResult: fetchResultVehicles,
//                             scrollController: scrollController,
//                             bookingNotifier: bookingNotifier,
//                             bookingState: bookingState,
//                           ),
//                         ]),
//                       ),
//                     ),
//                 ],
//               ),
//             ),
//             if (!(fetchResultVehicles.isFetchingData &&
//                     fetchResultVehicles.items.isEmpty) &&
//                 bookingState.houseType != null &&
//                 bookingState.houseType?.id != null &&
//                 bookingState.selectedVehicle != null)
//               Consumer(
//                 builder: (context, ref, child) {
//                   final bookingState = ref.watch(bookingProvider);
//                   final bookingNotifier = ref.read(bookingProvider.notifier);

//                   return SummarySection(
//                     buttonText: "Bước tiếp theo",
//                     priceLabel: "Giá",
//                     buttonIcon: false,
//                     totalPrice:
//                         (bookingState.selectedVehicle?.truckCategory?.price ??
//                             0.0),
//                     isButtonEnabled: true,
//                     onPlacePress: () async {
//                       context.router.push(const BookingScreenServiceRoute());
//                     },
//                   );
//                 },
//               ),
//           ],
//         ),
//       ),
//     );
//   }
// }

@RoutePage()
class BookingScreen extends HookConsumerWidget {
  const BookingScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final bookingState = ref.watch(bookingProvider);
    final bookingStatePrice = ref.watch(bookingResponseProviderPrice);
    final bookingNotifier = ref.read(bookingProvider.notifier);
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

    print(
        " tuan bookingState selectedVehicle ${bookingState.selectedVehicle?.name}");
    return Scaffold(
      appBar: CustomAppBar(
        title: 'Chọn loại nhà ',
        centerTitle: true,
        backButtonColor: AssetsConstants.whiteColor,
        showBackButton: true,
        // iconFirst: Icons.arrow_back_ios,
        onCallBackFirst: () {
          // context.router.pop();
          bookingNotifier.resetHouseTypeInfo(null);
          bookingNotifier.resetVehiclesSelected(null);
        },
      ),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: CustomScrollView(
                controller: scrollController,
                slivers: [
                  if (fetchResultVehicles.isFetchingData &&
                      fetchResultVehicles.items.isEmpty)
                    const SliverToBoxAdapter(
                      child: SizedBox(
                        height: 400,
                        child: Center(child: HomeShimmer(amount: 1)),
                      ),
                    )
                  else
                    SliverPadding(
                      padding: const EdgeInsets.all(16.0),
                      sliver: SliverList(
                        delegate: SliverChildListDelegate([
                          const BookingSelection(),
                          const SizedBox(height: 16),
                          const RoomMediaSection(
                            roomTitle: 'Tải ảnh lên',
                            roomType: RoomType.livingRoom,
                          ),
                          const SizedBox(height: 16),
                          const LabelText(
                            content:
                                "Lưu ý: Bỏ qua mục này nếu bạn muốn xếp lịch hẹn đánh giá tại nhà.",
                            size: 12,
                            fontWeight: FontWeight.w600,
                            color: Colors.grey,
                          ),
                          Row(
                            children: [
                              const LabelText(
                                content: "Phương tiện có sẵn",
                                size: AssetsConstants.buttonFontSize + 1,
                                fontWeight: FontWeight.w600,
                              ),
                              if (bookingState.vehicleError != null)
                                Padding(
                                  padding: const EdgeInsets.only(
                                      top: 4.0, left: 8.0),
                                  child: Text(
                                    bookingState.vehicleError!,
                                    style: const TextStyle(
                                      color: Colors.red,
                                      fontSize: 12,
                                    ),
                                  ),
                                ),
                            ],
                          ),
                          VehicleList(
                            fetchResult: fetchResultVehicles,
                            scrollController: scrollController,
                          ),
                        ]),
                      ),
                    ),
                ],
              ),
            ),
            if (!(fetchResultVehicles.isFetchingData &&
                fetchResultVehicles.items.isEmpty))
              Consumer(
                builder: (context, ref, child) {
                  final bookingState = ref.watch(bookingProvider);
                  final bookingNotifier = ref.read(bookingProvider.notifier);

                  return SummarySection(
                    buttonText: "Bước tiếp theo",
                    priceLabel:
                        (bookingState.selectedVehicle?.name == 'not selected' ||
                                bookingState.selectedVehicle?.name == null)
                            ? ''
                            : "Giá",
                    // priceLabel:
                    //     bookingState.selectedVehicle?.name == 'not selected'
                    //         ? ""
                    //         : "Giá",
                    buttonIcon: false,
                    // totalPrice:
                    //     (bookingState.selectedVehicle?.truckCategory?.price ??
                    //         0),
                    totalPrice: (bookingStatePrice?.total ?? 0.0),
                    isButtonEnabled: bookingState.selectedVehicle != null,
                    onPlacePress: () async {
                      // print(
                      //     " tuan object chon xe ${bookingState.selectedVehicle}");
                      if (bookingState.houseType != null &&
                          bookingState.houseType?.id != null &&
                          bookingState.selectedVehicle != null &&
                          bookingState.selectedVehicle?.name !=
                              'not selected') {
                        context.router.push(const BookingScreenServiceRoute());
                      } else {
                        if (bookingState.houseType == null ||
                            bookingState.houseType?.id == null) {
                          bookingNotifier.setHouseTypeError(
                              "Vui lòng chọn loại nhà phù hợp");
                        }
                        if (bookingState.selectedVehicle == null ||
                            bookingState.selectedVehicle?.name ==
                                'not selected') {
                          bookingNotifier
                              .setVehicleError("Vui lòng chọn loại xe phù hợp");
                        }
                      }
                    },
                  );
                },
              ),
          ],
        ),
      ),
    );
  }
}
