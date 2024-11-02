// order_details_screen.dart

import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:auto_route/auto_route.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:movemate/configs/routes/app_router.dart';
import 'package:movemate/features/booking/domain/entities/house_type_entity.dart';
import 'package:movemate/features/booking/domain/entities/service_entity.dart';
import 'package:movemate/features/booking/presentation/screens/controller/booking_controller.dart';
import 'package:movemate/features/booking/presentation/screens/controller/service_package_controller.dart';
import 'package:movemate/features/booking/presentation/screens/service_screen/service_controller.dart';
import 'package:movemate/features/order/domain/entites/order_entity.dart';
import 'package:movemate/features/order/presentation/controllers/order_controller/order_controller.dart';
import 'package:movemate/features/order/presentation/widgets/main_detail_ui/booking_status.dart';
import 'package:movemate/features/order/presentation/widgets/main_detail_ui/customer_info.dart';
import 'package:movemate/features/order/presentation/widgets/main_detail_ui/map_widget.dart';
import 'package:movemate/features/order/presentation/widgets/main_detail_ui/price_details.dart';
import 'package:movemate/features/order/presentation/widgets/main_detail_ui/profile_info.dart';
import 'package:movemate/features/order/presentation/widgets/main_detail_ui/service_info_card.dart';
import 'package:movemate/features/order/presentation/widgets/main_detail_ui/timeline_steps.dart';
import 'package:movemate/hooks/use_fetch_obj.dart';
import 'package:movemate/models/request/paging_model.dart';
import 'package:movemate/services/realtime_service/booking_status_realtime/booking_status_stream_provider.dart';
import 'package:movemate/utils/commons/widgets/app_bar.dart';
import 'package:movemate/utils/constants/asset_constant.dart';
import 'package:movemate/utils/enums/enums_export.dart';
import 'package:movemate/utils/commons/functions/string_utils.dart';
// Hooks
import 'package:movemate/hooks/use_fetch.dart';
import 'package:timeline_tile/timeline_tile.dart';

@RoutePage()
class OrderDetailsScreen extends HookConsumerWidget {
  const OrderDetailsScreen({
    super.key,
    required this.order,
  });
  final OrderEntity order;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isExpanded = useState(false);
    final expandedIndex = useState<int>(-1);

    final state = ref.watch(bookingControllerProvider);

    final List<Map<String, dynamic>> steps = [
      {
        'title': 'Đặt hàng',
        'details': ['Đơn hàng được tạo', 'Xác nhận thông tin'],
      },
      {
        'title': 'Gói hàng',
        'details': ['Sản phẩm được đóng gói', 'Chuẩn bị giao'],
      },
      {
        'title': 'Giao hàng',
        'details': ['Đang vận chuyển', 'Giao hàng đến nơi'],
      },
      {
        'title': 'Thành công',
        'details': ['Giao hàng thành công', 'Hoàn tất đơn hàng'],
      },
    ];

    final statusAsync =
        ref.watch(orderStatusStreamProvider(order.id.toString()));

    final useFetchResult = useFetchObject<HouseTypeEntity>(
      function: (context) => ref
          .read(servicePackageControllerProvider.notifier)
          .getHouseTypeById(order.houseTypeId, context),
      context: context,
    );

    // Fetch Services
    final fetchResultVehicle = useFetch<ServiceEntity>(
      function: (model, context) => ref
          .read(serviceControllerProvider.notifier)
          .getServices(model, context),
      initialPagingModel: PagingModel(),
      context: context,
    );

    final fetchResultVehicleId =
        fetchResultVehicle.items.map((e) => e.id).toList();
    print("object: fetchResultVehicle.data = $fetchResultVehicleId");

    final checkID = fetchResultVehicleId ==
        order.bookingDetails.map((e) => e.serviceId).toList();

    print("object: fetchResultVehicle.data = $checkID");

    final houseType = useFetchResult.data;

    final truckBookingDetails = order.bookingDetails
        .map((e) => e.serviceId)
        .where((e) => e.toString() == 'TRUCK')
        .toList();

    final truckBookingDetailsGetId =
        order.bookingDetails.where((detail) => detail.type == 'TRUCK').toList();


    // print(houseType?.toJson());

    void toggleDropdown() {
      isExpanded.value = !isExpanded.value;
    }

    return Scaffold(
      appBar: CustomAppBar(
        backgroundColor: AssetsConstants.primaryMain,
        onCallBackFirst: () {
          Navigator.pop(context);
        },
        backButtonColor: AssetsConstants.whiteColor,
        title: "Thông tin đơn hàng #${order.id ?? ""}",
        iconSecond: Icons.home_outlined,
        onCallBackSecond: () {
          final tabsRouter = context.router.root
              .innerRouterOf<TabsRouter>(TabViewScreenRoute.name);
          if (tabsRouter != null) {
            tabsRouter.setActiveIndex(0);
            context.router.popUntilRouteWithName(TabViewScreenRoute.name);
          } else {
            context.router.pushAndPopUntil(
              const TabViewScreenRoute(children: [
                HomeScreenRoute(),
              ]),
              predicate: (route) => false,
            );
          }
        },
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.only(left: 2.0, top: 40),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              BookingStatus(statusAsync: statusAsync, order: order),
              const SizedBox(height: 50),
              TimelineSteps(
                steps: steps,
                expandedIndex: expandedIndex,
              ),
              const SizedBox(height: 30),
              ServiceInfoCard(
                order: order,
                houseType: houseType,
              ),
              const SizedBox(height: 20),
              FadeInLeft(
                child: const Padding(
                  padding: EdgeInsets.only(left: 16.0),
                  child: Text("Map",
                      style:
                          TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                ),
              ),
              const MapWidget(),
              const SizedBox(height: 20),
              const ProfileInfo(),
              const SizedBox(height: 20),
              FadeInLeft(
                child: const Padding(
                  padding: EdgeInsets.only(left: 16.0),
                  child: Text("Thông tin khách hàng",
                      style:
                          TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
                ),
              ),
              const SizedBox(height: 20),
              CustomerInfo(
                isExpanded: isExpanded,
                toggleDropdown: toggleDropdown,
              ),
              const SizedBox(height: 20),
              PriceDetails(
                order: order,
                statusAsync: statusAsync,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
