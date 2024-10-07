// available_vehicles_screen.dart

//config
import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:movemate/configs/routes/app_router.dart';

//hook
import 'package:movemate/hooks/use_fetch.dart';

//widget models - extension
import 'package:movemate/models/request/paging_model.dart';
import 'package:movemate/utils/commons/widgets/widgets_common_export.dart';
import 'package:movemate/utils/constants/asset_constant.dart';
import 'package:movemate/utils/extensions/scroll_controller.dart';

//data - entity
import 'package:movemate/features/booking/domain/entities/truck_category_entity.dart';
import 'package:movemate/features/booking/presentation/widgets/booking_screen_2th/export_booking_screen_2th.dart';
import '../service_screen/truck_controller.dart';

@RoutePage()
class AvailableVehiclesScreen extends HookConsumerWidget {
  const AvailableVehiclesScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Initialize
    final size = MediaQuery.sizeOf(context);
    final scrollController = useScrollController();
    final state = ref.watch(truckControllerProvider);

    // Fetch trucks
    final fetchResult = useFetch<TruckCategoryEntity>(
      function: (model, context) =>
          ref.read(truckControllerProvider.notifier).getTrucks(model, context),
      initialPagingModel: PagingModel(
        searchContent: "1",
      ),
      context: context,
    );

    useEffect(() {
      scrollController.onScrollEndsListener(fetchResult.loadMore);
      return scrollController.dispose;
    }, const []);

    return Scaffold(
      appBar: CustomAppBar(
        title: 'Available Vehicles',
        iconFirst: Icons.refresh_rounded,
        onCallBackFirst: fetchResult.refresh,
      ),
      body: Column(
        children: [
          SizedBox(height: size.height * 0.02),
          (state.isLoading && fetchResult.items.isEmpty)
              ? const Center(
                  child: HomeShimmer(amount: 4),
                )
              : fetchResult.items.isEmpty
                  ? const Align(
                      alignment: Alignment.topCenter,
                      child: EmptyBox(title: 'No data available'),
                    )
                  : Expanded(
                      child: ListView.builder(
                        itemCount: fetchResult.items.length + 1,
                        physics: const AlwaysScrollableScrollPhysics(),
                        controller: scrollController,
                        itemBuilder: (context, index) {
                          if (index == fetchResult.items.length) {
                            if (fetchResult.isFetchingData) {
                              return const CustomCircular();
                            }
                            return fetchResult.isLastPage
                                ? const NoMoreContent()
                                : Container();
                          }
                          final vehicle = fetchResult.items[index];
                          return GestureDetector(
                            onTap: () {
                              // Handle vehicle selection
                              // You can manage selected vehicle using another provider if needed
                            },
                            child: buildVehicleCard(
                              vehicle,
                              false, // Pass true if the vehicle is selected
                            ),
                          );
                        },
                      ),
                    ),
        ],
      ),
      bottomNavigationBar: SummarySection(
        buttonText: "Next Step",
        priceLabel: 'Total Price',
        buttonIcon: false,
        totalPrice: 0.0, // Update with actual total price if needed
        isButtonEnabled: true, // Update based on selection
        onPlacePress: () {
          context.router.push(const BookingSelectPackageScreenRoute());
        },
      ),
    );
  }

  Widget buildVehicleCard(
    TruckCategoryEntity vehicle,
    bool isSelected,
  ) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 8),
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: AssetsConstants.whiteColor,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: isSelected
              ? AssetsConstants.primaryDark
              : AssetsConstants.greyColor.shade300,
          width: 2,
        ),
        boxShadow: [
          BoxShadow(
            color: AssetsConstants.greyColor.shade200,
            spreadRadius: 2,
            blurRadius: 5,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      height: 140,
      width: double.infinity,
      child: Row(
        children: [
          // Vehicle Image
          Container(
            width: 60,
            height: 60,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8),
              color: AssetsConstants.greyColor.shade100,
            ),
            child: Image.network(
              vehicle.imgUrl,
              fit: BoxFit.contain,
              errorBuilder: (context, error, stackTrace) {
                return const Icon(Icons.image, size: 50);
              },
            ),
          ),
          const SizedBox(width: 16),
          // Vehicle Details
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  vehicle.categoryName,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                    color: AssetsConstants.blackColor,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 6),
                Text(
                  vehicle.description,
                  style: TextStyle(
                    fontSize: 12,
                    color: AssetsConstants.greyColor.shade700,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 6),
                Row(
                  children: [
                    const Icon(
                      Icons.straighten,
                      size: 16,
                      color: AssetsConstants.blackColor, // Màu icon
                    ),
                    const SizedBox(width: 4), // Khoảng cách giữa icon và text
                    Text(
                      ' ${vehicle.estimatedLength} x ${vehicle.estimatedWidth} x ${vehicle.estimatedHeight} x ${vehicle.maxLoad}',
                      style: const TextStyle(
                        fontSize: 12,
                        color: AssetsConstants.blackColor,
                      ),
                      maxLines: 1,
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
