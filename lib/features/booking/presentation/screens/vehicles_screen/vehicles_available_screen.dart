// available_vehicles_screen.dart

import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:movemate/configs/routes/app_router.dart';
import 'package:movemate/features/booking/domain/entities/service_entity.dart';
import 'package:movemate/features/booking/presentation/screens/service_screen/service_controller.dart';
import 'package:movemate/features/booking/presentation/widgets/vehicles_screen/vehicle_list.dart';

// Hooks
import 'package:movemate/hooks/use_fetch.dart';

// Widgets and Extensions
import 'package:movemate/models/request/paging_model.dart';
import 'package:movemate/utils/commons/widgets/widgets_common_export.dart';

import 'package:movemate/utils/extensions/scroll_controller.dart';

// Data - Entity
import 'package:movemate/features/booking/presentation/widgets/booking_screen_2th/export_booking_screen_2th.dart';

@RoutePage()
class AvailableVehiclesScreen extends HookConsumerWidget {
  const AvailableVehiclesScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final size = MediaQuery.sizeOf(context);
    final scrollController = useScrollController();
    final state = ref.watch(serviceControllerProvider);

    final fetchResult = useFetch<ServiceEntity>(
      function: (model, context) => ref
          .read(serviceControllerProvider.notifier)
          .getServices(model, context),
      initialPagingModel: PagingModel(
        searchContent: "1",
      ),
      context: context,
    );

    useEffect(() {
      scrollController.onScrollEndsListener(fetchResult.loadMore);
      return scrollController.dispose;
    }, const []);

    final selectedService = useState<ServiceEntity?>(null);

    return Scaffold(
      appBar: CustomAppBar(
        title: 'Phương tiện có sẵn',
        iconFirst: Icons.refresh_rounded,
        onCallBackFirst: fetchResult.refresh,
      ),
      body: Column(
        children: [
          SizedBox(height: size.height * 0.02),
          Expanded(
            child: VehicleList(
              state: state,
              fetchResult: fetchResult,
              scrollController: scrollController,
              selectedService: selectedService,
            ),
          ),
        ],
      ),
      bottomNavigationBar: SummarySection(
        buttonText: "Bước tiếp theo",
        priceLabel: 'Giá',
        buttonIcon: false,
        totalPrice: selectedService.value?.amount ??
            0.0, // Show price from selected service
        isButtonEnabled: selectedService.value != null,
        onPlacePress: () {
          if (selectedService.value != null) {
            context.router.push(const BookingSelectPackageScreenRoute());
          } else {
            // Show a message to select a vehicle
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                  content: Text('vui lòng chọn phương tiện phù hợp')),
            );
          }
        },
      ),
    );
  }
}