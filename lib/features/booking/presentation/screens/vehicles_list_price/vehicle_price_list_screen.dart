import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:movemate/features/booking/domain/entities/service_truck/inverse_parent_service_entity.dart';
import 'package:movemate/features/booking/domain/entities/service_truck/truck_entity_response.dart';
import 'package:movemate/features/booking/domain/entities/truck_category_entity.dart';
import 'package:movemate/features/booking/domain/repositories/service_booking_repository.dart';
import 'package:movemate/features/booking/presentation/providers/booking_provider.dart';
import 'package:movemate/features/booking/presentation/providers/vehicle_list_price_provider/vehicle_list_price_provider.dart';
import 'package:movemate/features/booking/presentation/providers/vehicle_list_price_provider/vehicle_model_list_price.dart';
import 'package:movemate/features/booking/presentation/screens/controller/service_package_controller.dart';
import 'package:movemate/features/booking/presentation/screens/service_screen/service_controller.dart';
import 'package:movemate/features/order/presentation/screens/order_detail_screen.dart/confirm_last_payment/confirm_last_payment.dart';
import 'package:movemate/hooks/use_fetch.dart';
import 'package:movemate/models/request/paging_model.dart';
import 'package:movemate/utils/commons/widgets/app_bar.dart';
import 'package:movemate/utils/commons/widgets/format_price.dart';
import 'package:movemate/utils/commons/widgets/loading_overlay.dart';
import 'package:movemate/utils/constants/asset_constant.dart';

@RoutePage()
class VehiclePriceListScreen extends HookConsumerWidget {
  const VehiclePriceListScreen({super.key});

  // // Define vehiclesList as a static variable inside the class
  // static final List<VehicleModel> vehiclesList = [
  //   VehicleModel(
  //     title: 'Xe tải 500kg',
  //     size: '190cm x 140cm x 140cm',
  //     volume: '1.5 CBM',
  //     basePrice: '111,780đ',
  //     additionalPrice:
  //         '+10.800đ/km (4-10km)\n+7.560đ/km (10-15km)\n+5.940đ/km (15-45km)\n+4.860đ/km (>45km)',
  //     longDistancePrice:
  //         '362,880đ/40km đầu tiên\n+5.940đ/km (40-45km)\n+4.860đ/km (>45km)',
  //     imagePath: 'assets/images/home/Group18564.png',
  //     bgColor: Colors.orangeAccent,
  //   ),
  //   VehicleModel(
  //     title: 'Xe van 1000kg',
  //     size: '210cm x 130cm x 130cm',
  //     volume: '4 CBM',
  //     basePrice: '148,500đ',
  //     additionalPrice:
  //         '+12.420đ/km (4-10km)\n+9.720đ/km (10-15km)\n+7.020đ/km (15-45km)\n+5.400đ/km (>45km)',
  //     longDistancePrice:
  //         '447,120đ/40km đầu tiên\n+7.020đ/km (40-45km)\n+5.400đ/km (>45km)',
  //     imagePath: 'assets/images/home/Group18564.png',
  //     bgColor: Colors.tealAccent,
  //   ),
  // ];

  // Define vehicleListPriceProvider as a static variable inside the class

  // Định nghĩa provider ở cấp class
  // Define provider ở mức global
  static final vehicleListPriceProvider =
      StateNotifierProvider<VehicleListPriceProvider, int>((ref) {
    return VehicleListPriceProvider(
        vehiclesList: const []); // Initialize with empty list
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state =
        ref.watch(servicePackageControllerProvider); // Watch the booking state

    final controller = ref.read(servicePackageControllerProvider.notifier);

    final fetchResult = useFetch<Truck>(
      function: (model, context) async {
        return await controller.getTruckDetailPrice(model, context);
      },
      initialPagingModel: PagingModel(
        type: 'TRUCK',
      ),
      context: context,
    );
    final fetchResultdata = fetchResult.items;

    useEffect(() {
      if (fetchResult.items.isNotEmpty) {
        Future(() {
          ref
              .read(vehicleListPriceProvider.notifier)
              .updateVehiclesList(fetchResult.items);
        });
      }
      return null;
    }, [fetchResult.items]);

    final currentIndex = ref.watch(vehicleListPriceProvider);
    final vehicleProviderNotifier = ref.read(vehicleListPriceProvider.notifier);

    // Kiểm tra null và empty trước khi truy cập
    final currentVehicle =
        fetchResult.items.isNotEmpty && currentIndex < fetchResult.items.length
            ? fetchResult.items[currentIndex]
            : null;

    if (currentVehicle == null) {
      return const Center(child: CircularProgressIndicator());
    }

    print("checking for ${fetchResultdata.toString()}");

    void handleNavigation(bool isNext) {
      if (isNext) {
        vehicleProviderNotifier.nextVehicle();
      } else {
        vehicleProviderNotifier.nextVehicle();
      }
    }

    return LoadingOverlay(
      isLoading: state.isLoading,
      child: Scaffold(
        appBar: const CustomAppBar(
          title: 'Bảng giá niêm yết',
          backgroundColor: AssetsConstants.primaryMain,
          backButtonColor: AssetsConstants.whiteColor,
          centerTitle: true,
          showBackButton: true,
        ),
        body: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Vehicle Navigation Header
              // Navigation header
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  IconButton(
                    onPressed: () => vehicleProviderNotifier.previousVehicle(),
                    icon: const Icon(Icons.arrow_back_ios),
                  ),
                  Column(
                    children: [
                      Container(
                        width: 120,
                        height: 120,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8.0),
                          border: Border.all(color: Colors.grey.shade300),
                        ),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(8.0),
                          child: Image.network(
                            currentVehicle.imageUrl,
                            width: 120,
                            height: 120,
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        currentVehicle.categoryName,
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  IconButton(
                    onPressed: () => vehicleProviderNotifier.nextVehicle(),
                    icon: const Icon(Icons.arrow_forward_ios),
                  ),
                ],
              ),
              const SizedBox(height: 16),

              // Vehicle Details
              buildDetailRow('Kích thước',
                  '${currentVehicle.estimatedLenght} x ${currentVehicle.estimatedWidth} x ${currentVehicle.estimatedHeight}'),
              const SizedBox(height: 16),
              buildDetailRow(
                  'Số khối', "${currentVehicle.maxLoad.toString()} CBM"),
              const SizedBox(height: 16),

              // Basic Price Details
              if (fetchResultdata.isNotEmpty &&
                  currentIndex < fetchResultdata.length)
                buildPriceSection(
                  'Cước ban đầu tối thiểu',
                  formatPrice((fetchResultdata[currentIndex].price).toDouble()),
                ),
              const SizedBox(height: 16),
              if (fetchResultdata.isNotEmpty &&
                  currentIndex < fetchResultdata.length)
                buildPriceSection(
                  'Cước phí km tiếp theo',
                  fetchResultdata[currentIndex]
                      .feeSettings
                      .skip(1) // Bỏ qua fee setting đầu tiên (cước ban đầu)
                      .map((fee) =>
                          '${formatPrice((fee.amount)?.toDouble() ?? 0)}/km (${fee.description})')
                      .join('\n'),
                ),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildDetailRow(String label, String value) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
      margin: const EdgeInsets.symmetric(vertical: 4),
      decoration: BoxDecoration(
        color: Colors.grey[200],
        borderRadius: BorderRadius.circular(8.0),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: const TextStyle(fontSize: 16, color: Colors.black54),
          ),
          Text(
            value,
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }

  Widget buildPriceSection(String title, String priceDetails) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.grey[100],
        borderRadius: BorderRadius.circular(8.0),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            priceDetails,
            style: const TextStyle(fontSize: 14, color: Colors.black54),
          ),
        ],
      ),
    );
  }
}
