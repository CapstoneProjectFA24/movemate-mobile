// order_details_screen.dart

import 'package:flutter/material.dart';
import 'package:auto_route/auto_route.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:movemate/configs/routes/app_router.dart';

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
import 'package:movemate/features/order/presentation/widgets/main_detail_ui/modal_action/incidents_content_modal.dart';
import 'package:movemate/features/order/presentation/widgets/main_detail_ui/price_details/price_details.dart';

import 'package:movemate/features/order/presentation/widgets/main_detail_ui/profile_infor/profile_staff_info.dart';

import 'package:movemate/features/order/presentation/widgets/main_detail_ui/service_info_card.dart';
import 'package:movemate/features/order/presentation/widgets/main_detail_ui/timeline_steps.dart';
import 'package:movemate/features/order/presentation/widgets/tab_container/custom_tab_container.dart';
import 'package:movemate/features/profile/presentation/controllers/profile_controller/profile_controller.dart';
import 'package:movemate/features/promotion/data/models/response/promotion_about_user_response.dart';
import 'package:movemate/features/promotion/domain/entities/promotion_entity.dart';
import 'package:movemate/features/promotion/domain/entities/voucher_entity.dart';
import 'package:movemate/features/promotion/presentation/controller/promotion_controller.dart';
import 'package:movemate/hooks/use_booking_status.dart';
import 'package:movemate/hooks/use_fetch_obj.dart';
import 'package:movemate/services/chat_services/models/chat_model.dart';
import 'package:movemate/services/realtime_service/booking_realtime_entity/booking_realtime_entity.dart';
import 'package:movemate/services/realtime_service/booking_realtime_entity/order_stream_manager.dart';
import 'package:movemate/services/realtime_service/booking_status_realtime/booking_status_stream_provider.dart';
import 'package:movemate/utils/commons/widgets/widgets_common_export.dart';
import 'package:movemate/utils/constants/asset_constant.dart';
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
    final stateBooking = ref.watch(bookingControllerProvider);
    final statusAsync =
        ref.watch(orderStatusStreamProvider(order.id.toString()));

    final statusOrders = statusAsync.when(
      data: (status) => status,
      loading: () => const CircularProgressIndicator(),
      error: (err, stack) => Text('Error: $err'),
    );

    final bookingAsync = ref.watch(bookingStreamProvider(order.id.toString()));
    final bookingStatus =
        useBookingStatus(bookingAsync.value, order.isReviewOnline ?? false);

    final canRepostBooking = bookingStatus.isProcessingRequest;

    final bookingAssignment = bookingAsync.value?.assignments.length;

    // TO DO for traking position
    final canCheckReviewerTracking = bookingStatus.isReviewerMoving;
    final canCheckDriverTracking = bookingStatus.isDriverProcessingMoving;
    final canCheckPorterTracking = bookingStatus.isPorterProcessingMoving;

    final useFetchResult = useFetchObject<HouseTypeEntity>(
      function: (context) => ref
          .read(servicePackageControllerProvider.notifier)
          .getHouseTypeById(order.houseTypeId, context),
      context: context,
    );
    final houseType = useFetchResult.data;

    List<AssignmentsRealtimeEntity>? getListStaffResponsibility(
        OrderEntity order) {
      try {
        final staffResponsibility =
            // order.assignments.where((e) => e.isResponsible == true).toList();
            ref
                .watch(bookingStreamProvider(order.id.toString()))
                .value
                ?.assignments
                //đổi từ chọn đứa được isressponible thành isReviewer
                .where(
                    (e) => e.isResponsible == true && e.staffType == 'REVIEWER')
                .toList();
        return staffResponsibility;
      } catch (e) {
        print('Error: $e');
        return [];
      }
    }

    List<AssignmentsRealtimeEntity>? getListStaffDriverInOrder(
        OrderEntity order) {
      try {
        final staffResponsibility =
            // order.assignments.where((e) => e.isResponsible == true).toList();
            ref
                .watch(bookingStreamProvider(order.id.toString()))
                .value
                ?.assignments
                .where((e) => e.staffType == 'DRIVER')
                .toList();
        return staffResponsibility;
      } catch (e) {
        print('Error: $e');
        return [];
      }
    }

    List<AssignmentsRealtimeEntity>? getListStaffPorterInOrder(
        OrderEntity order) {
      try {
        final staffResponsibility =
            // order.assignments.where((e) => e.isResponsible == true).toList();
            ref
                .watch(bookingStreamProvider(order.id.toString()))
                .value
                ?.assignments
                .where((e) => e.staffType == 'PORTER')
                .toList();

        // print(
        //     "object cheking liststaffPorterInOrder ${staffResponsibility.toString()}");

        return staffResponsibility;
      } catch (e) {
        print('Error: $e');
        return [];
      }
    }

    // List<VouchersRealtimeEntity>? getListVoucher(OrderEntity order) {
    //   try {
    //     final voucherAvailable = ref
    //         .watch(bookingStreamProvider(order.id.toString()))
    //         .value
    //         ?.vouchers
    //         .where((e) => e.bookingId == order.id)
    //         .toList();

    //     return voucherAvailable;
    //   } catch (e) {
    //     print('Error: $e');
    //     return [];
    //   }
    // }

    final listStaffResponsibility = getListStaffResponsibility(order);

    final listStaffDriverInOrder = getListStaffDriverInOrder(order);
    final listStaffPorterInOrder = getListStaffPorterInOrder(order);
    // final listVoucher = getListVoucher(order);
    // final currentListStaff = ref
    //     .watch(bookingStreamProvider(order.id.toString()))
    //     .value
    //     ?.assignments
    //     .where((e) => e.isResponsible == true)
    //     .toList();

    // print(
    //     "check current list ${currentListStaff?.firstWhere((e) => e.isResponsible == true)}");

    final getServiceId = order.bookingDetails
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
              .getOrderEntityById(order.id);
        },
        context: context);

    ref.listen<bool>(refreshOrderList, (_, __) => orderEntity.refresh());
    ref.listen<bool>(refreshOrderDetailsById, (_, __) => orderEntity.refresh());
    ref.listen<bool>(refreshOrderDetails, (_, __) => orderEntity.refresh());

    useEffect(() {
      OrderStreamManager().updateJob(order);
      return null;
    }, [bookingAsync.value]);

    // print(
    //     " current listStaffResponsibility ${listStaffResponsibility?.firstWhere((e) => e.staffType == 'DRIVER').isResponsible}");
    if (listStaffResponsibility == null) {
      return const Center(
        child: CircularProgressIndicator(),
      );
    }
    // print("tuan log check status 3 ${order.status}");
    return LoadingOverlay(
      isLoading:
          state.isLoading || stateService.isLoading || stateProfile.isLoading,
      child: Scaffold(
        appBar: CustomAppBar(
          backgroundColor: AssetsConstants.primaryMain,
          iconFirst: bookingStatus.canReport ? Icons.error : Icons.refresh,
          iconFirstColor: AssetsConstants.whiteColor,
          onCallBackFirst: bookingStatus.canReport
              ? () {
                  showModalBottomSheet(
                    context: context,
                    isScrollControlled: true, // Cho phép cuộn trong modal
                    backgroundColor: Colors.transparent, // Chỉnh nền trong suốt
                    builder: (BuildContext context) {
                      return IncidentsContentModal(order: order);
                    },
                  );
                }
              : () {
                  orderEntity.refresh();
                },
          backButtonColor: AssetsConstants.whiteColor,
          title: "Thông tin đơn hàng BOK${order.id ?? ""}",
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
                BookingStatus(order: orderEntity.data ?? order),
                const SizedBox(height: 20),
                TimelineSteps(
                  order: orderEntity.data ?? order,
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
                            order: order,
                          );
                        }),
                    const SizedBox(height: 20),
                    if (listStaffDriverInOrder!.isNotEmpty ||
                        listStaffPorterInOrder!.isNotEmpty)
                      CustomTabContainer(
                        porterItems: listStaffPorterInOrder ?? [],
                        driverItems: listStaffDriverInOrder ?? [],
                        bookingId: order.id,
                        order: order,
                      ),
                    const SizedBox(height: 20),
                    const LabelText(
                      content: 'Thông tin khách hàng',
                      size: 16,
                      fontFamily: 'bold',
                      color: AssetsConstants.blackColor,
                      fontWeight: FontWeight.w500,
                    ),
                    ServiceInfoCard(
                      order: orderEntity.data ?? order,
                      houseType: houseType,
                    )
                  ],
                ),
                // const SizedBox(height: 20),
                // (statusOrders == BookingStatusType.assigned &&
                //             order.isReviewOnline == false) ||
                //         (statusOrders == BookingStatusType.reviewed &&
                //             order.isReviewOnline == true)
                //     ? Column(
                //         children: [
                //           FadeInLeft(
                //             child: const Padding(
                //               padding: EdgeInsets.only(left: 16.0),
                //               child: Text(
                //                 "Map",
                //                 style: TextStyle(
                //                     fontSize: 20, fontWeight: FontWeight.bold),
                //               ),
                //             ),
                //           ),
                //           const MapWidget(),
                //         ],
                //       )
                //     : Container(),
                const SizedBox(height: 10),
                // (statusOrders == BookingStatusType.reviewed)
                // //?
                // CustomerInfo(
                //   isExpanded: isExpanded,
                //   order: order,
                //   toggleDropdown: toggleDropdown,
                // ),
                // : Container(),
                const SizedBox(height: 20),
                PriceDetails(
                  order: orderEntity.data ?? order,
                  serviceData: serviceData,
                  statusAsync: statusAsync,
                  // listVoucher: listVoucher ?? [],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

StaffRole convertToStaffRole(String staffType) {
  switch (staffType.toUpperCase()) {
    case 'DRIVER':
      return StaffRole.driver;
    case 'PORTER':
      return StaffRole.porter;
    case 'REVIEWER':
      return StaffRole.reviewer;
    default:
      return StaffRole.manager;
  }
}
