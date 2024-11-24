// order_details_screen.dart

import 'package:flutter/material.dart';
import 'package:auto_route/auto_route.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:movemate/configs/routes/app_router.dart';
import 'package:movemate/features/booking/domain/entities/booking_response/assignment_response_entity.dart';
import 'package:movemate/features/booking/domain/entities/booking_response/booking_detail_response_entity.dart';
import 'package:movemate/features/booking/domain/entities/house_type_entity.dart';
import 'package:movemate/features/booking/domain/entities/services_package_entity.dart';
import 'package:movemate/features/booking/presentation/screens/controller/booking_controller.dart';
import 'package:movemate/features/booking/presentation/screens/controller/service_package_controller.dart';
import 'package:movemate/features/booking/presentation/screens/service_screen/service_controller.dart';
import 'package:movemate/features/order/domain/entites/order_entity.dart';
import 'package:movemate/features/order/presentation/controllers/order_controller/order_controller.dart';
import 'package:movemate/features/order/presentation/widgets/main_detail_ui/booking_status.dart';
import 'package:movemate/features/order/presentation/widgets/main_detail_ui/customer_info.dart';
import 'package:movemate/features/order/presentation/widgets/main_detail_ui/price_details.dart';

import 'package:movemate/features/order/presentation/widgets/main_detail_ui/profile_infor/profile_staff_info.dart';

import 'package:movemate/features/order/presentation/widgets/main_detail_ui/service_info_card.dart';
import 'package:movemate/features/order/presentation/widgets/main_detail_ui/timeline_steps.dart';
import 'package:movemate/features/profile/presentation/controllers/profile_controller/profile_controller.dart';
import 'package:movemate/hooks/use_booking_status.dart';
import 'package:movemate/hooks/use_fetch_obj.dart';
import 'package:movemate/services/realtime_service/booking_realtime_entity/order_stream_manager.dart';
import 'package:movemate/services/realtime_service/booking_status_realtime/booking_status_stream_provider.dart';
import 'package:movemate/utils/commons/widgets/widgets_common_export.dart';
import 'package:movemate/utils/constants/asset_constant.dart';
import 'package:movemate/utils/enums/enums_export.dart';

// Hooks
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
    void toggleDropdown() {
      isExpanded.value = !isExpanded.value;
    }

    final state = ref.watch(orderControllerProvider);
    final stateProfile = ref.watch(profileControllerProvider);
    final stateService = ref.watch(serviceControllerProvider);

    // Lấy order mới
    final useFetchNewOrder = useFetchObject<OrderEntity>(
      function: (context) => ref
          .read(orderControllerProvider.notifier)
          .getBookingNewById(order.id, context),
      context: context,
    );

    // Lấy order cũ
    final useFetcholdOrder = useFetchObject<OrderEntity>(
      function: (context) => ref
          .read(orderControllerProvider.notifier)
          .getBookingOldById(order.id, context),
      context: context,
    );

    final orderNew = useFetchNewOrder.data;
    final orderOld = useFetcholdOrder.data;

    final isOrderNewLoading = useFetchNewOrder.isFetchingData;
    final isOrderOldLoading = useFetcholdOrder.isFetchingData;

    // Chờ cho đến khi orderNew được load xong
    if (isOrderNewLoading) {
      return const LoadingOverlay(
        isLoading: true,
        child: Scaffold(),
      );
    }

    final statusAsync =
        ref.watch(orderStatusStreamProvider(orderNew!.id.toString()));

    final statusOrders = statusAsync.when(
      data: (status) => status,
      loading: () => const CircularProgressIndicator(),
      error: (err, stack) => Text('Error: $err'),
    );

    final bookingAsync =
        ref.watch(bookingStreamProvider(orderNew.id.toString()));
    final bookingStatus =
        useBookingStatus(bookingAsync.value, orderNew.isReviewOnline);

    // TO DO for traking position
    final canCheckReviewerTracking = bookingStatus.isReviewerMoving;
    final canCheckDriverTracking = bookingStatus.isDriverProcessingMoving;
    final canCheckPorterTracking = bookingStatus.isPorterProcessingMoving;

    final useFetchResult = useFetchObject<HouseTypeEntity>(
      function: (context) => ref
          .read(servicePackageControllerProvider.notifier)
          .getHouseTypeById(orderNew.houseTypeId, context),
      context: context,
    );
    final houseType = useFetchResult.data;

    List<AssignmentResponseEntity> getListStaffResponsibility(
        OrderEntity order) {
      try {
        final staffResponsibility =
            order.assignments.where((e) => e.isResponsible == true).toList();
        return staffResponsibility;
      } catch (e) {
        print('Error: $e');
        return [];
      }
    }

    final listStaffResponsibility = getListStaffResponsibility(orderNew);

    final getServiceId = orderNew.bookingDetails
        .firstWhere(
          (e) => e.type == 'TRUCK',
          orElse: () => BookingDetailResponseEntity(
            bookingId: 0,
            id: 0,
            type: 'TRUCK',
            serviceId: 0,
            quantity: 0,
            price: 0,
            status: "READY",
            name: "TRUCK",
            description: "TRUCK",
            imageUrl: "TRUCK",
          ),
        )
        .serviceId;

    final useFetchResultService = useFetchObject<ServicesPackageEntity>(
      function: (context) async {
        return ref
            .read(serviceControllerProvider.notifier)
            .getServicesById(getServiceId, context);
      },
      context: context,
    );
    final serviceData = useFetchResultService.data;

    final orderEntity = useFetchObject<OrderEntity>(
        function: (context) async {
          return ref
              .read(bookingControllerProvider.notifier)
              .getOrderEntityById(orderNew.id);
        },
        context: context);

    ref.listen<bool>(refreshOrderList, (_, __) => orderEntity.refresh());

    useEffect(() {
      OrderStreamManager().updateJob(orderNew);
      return null;
    }, [bookingAsync.value]);

    return LoadingOverlay(
      isLoading:
          state.isLoading || stateService.isLoading || stateProfile.isLoading,
      child: Scaffold(
        appBar: CustomAppBar(
          backgroundColor: AssetsConstants.primaryMain,
          onCallBackFirst: () {
            Navigator.pop(context);
          },
          backButtonColor: AssetsConstants.whiteColor,
          title: "Thông tin đơn hàng #${orderNew.id ?? ""}",
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
            padding: const EdgeInsets.only(left: 2.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                BookingStatus(order: orderNew),
                const SizedBox(height: 20),
                TimelineSteps(
                  order: orderNew,
                  expandedIndex: expandedIndex,
                ),
                const SizedBox(height: 14),
                Column(
                  children: [
                    ListView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: listStaffResponsibility.length,
                        itemBuilder: (context, index) {
                          final staffAssignment =
                              listStaffResponsibility[index];
                          return ProfileStaffInfo(
                            staffAssignment: staffAssignment,
                            order: orderNew,
                          );
                        }),
                    const SizedBox(height: 20),
                    const LabelText(
                      content: 'Thông tin khách hàng',
                      size: 16,
                      fontFamily: 'bold',
                      color: AssetsConstants.blackColor,
                      fontWeight: FontWeight.w500,
                    ),
                    ServiceInfoCard(
                      order: orderNew,
                      houseType: houseType,
                    )
                  ],
                ),
                const SizedBox(height: 10),
                PriceDetails(
                  order: orderNew,
                  serviceData: serviceData,
                  statusAsync: statusAsync,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
