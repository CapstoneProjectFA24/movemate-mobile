// order_details_screen.dart

import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:auto_route/auto_route.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:intl/intl.dart';
import 'package:movemate/configs/routes/app_router.dart';
import 'package:movemate/features/booking/domain/entities/house_type_entity.dart';
import 'package:movemate/features/booking/domain/entities/service_entity.dart';
import 'package:movemate/features/booking/domain/entities/services_package_entity.dart';
import 'package:movemate/features/booking/presentation/screens/controller/service_package_controller.dart';
import 'package:movemate/features/order/domain/entites/order_entity.dart';
import 'package:movemate/features/order/presentation/controllers/order_controller/order_controller.dart';
import 'package:movemate/features/order/presentation/widgets/main_detail_ui/booking_status.dart';
import 'package:movemate/features/order/presentation/widgets/main_detail_ui/customer_info.dart';
import 'package:movemate/features/order/presentation/widgets/main_detail_ui/map_widget.dart';
import 'package:movemate/features/order/presentation/widgets/main_detail_ui/price_details.dart';
import 'package:movemate/features/order/presentation/widgets/main_detail_ui/profile_info.dart';
import 'package:movemate/features/order/presentation/widgets/main_detail_ui/service_info_card.dart';
import 'package:movemate/features/order/presentation/widgets/main_detail_ui/timeline_steps.dart';
import 'package:movemate/features/profile/domain/entities/profile_entity.dart';
import 'package:movemate/features/profile/presentation/controllers/profile_controller/profile_controller.dart';
import 'package:movemate/hooks/use_fetch_obj.dart';
import 'package:movemate/models/request/paging_model.dart';
import 'package:movemate/services/realtime_service/booking_status_realtime/booking_status_stream_provider.dart';
import 'package:movemate/utils/commons/widgets/widgets_common_export.dart';
import 'package:movemate/utils/constants/asset_constant.dart';
import 'package:movemate/utils/enums/enums_export.dart';
// Hooks
import 'package:movemate/hooks/use_fetch.dart';

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

    final statusAsync =
        ref.watch(orderStatusStreamProvider(order.id.toString()));

    print("object: statusAsync  $statusAsync");
    print("object: order.status  ${order.status}");

    final statusOrders = statusAsync.when(
      data: (status) => status,
      loading: () => const CircularProgressIndicator(),
      error: (err, stack) => Text('Error: $err'),
    );

    final useFetchResult = useFetchObject<HouseTypeEntity>(
      function: (context) => ref
          .read(servicePackageControllerProvider.notifier)
          .getHouseTypeById(order.houseTypeId, context),
      context: context,
    );
    final houseType = useFetchResult.data;

    final useFetchResultProfile = useFetchObject<ProfileEntity>(
      function: (context) async {
        return ref
            .read(profileControllerProvider.notifier)
            .getProfileInforById(order.userId, context);
      },
      context: context,
    );
    final profileUser = useFetchResultProfile.data;

    final fetchReslut = useFetch<OrderEntity>(
      function: (model, context) => ref
          .read(orderControllerProvider.notifier)
          .getBookings(model, context),
      initialPagingModel: PagingModel(
        pageSize: 50,
        pageNumber: 1,
      ),
      context: context,
    );

    final fetchReslutService = useFetch<ServicesPackageEntity>(
      function: (model, context) => ref
          .read(orderControllerProvider.notifier)
          .getAllService(model, context),
      initialPagingModel: PagingModel(
        type: 'TRUCK',
        pageSize: 50,
        pageNumber: 1,
      ),
      context: context,
    );
    final serviceAll = fetchReslutService.items;

    return LoadingOverlay(
      isLoading: state.isLoading,
      child: Scaffold(
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
            padding: const EdgeInsets.only(left: 2.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                BookingStatus(order: order),
                const SizedBox(height: 50),
                TimelineSteps(
                  order: order,
                  expandedIndex: expandedIndex,
                ),
                const SizedBox(height: 16),
                statusOrders == BookingStatusType.pending
                    ? Column(
                        children: [
                          const LabelText(
                            content: 'Thông tin khách hàng',
                            size: 20,
                            fontFamily: 'bold',
                            color: AssetsConstants.blackColor,
                            fontWeight: FontWeight.w400,
                          ),
                          ServiceInfoCard(
                            statusAsync: statusAsync,
                            order: order,
                            houseType: houseType,
                            profileUser: profileUser,
                          ),
                        ],
                      )
                    : statusOrders == BookingStatusType.assigned
                        ? Column(
                            children: [
                              const ProfileInfo(),
                              const SizedBox(height: 20),
                              const LabelText(
                                content: 'Thông tin đánh giá',
                                size: 20,
                                fontFamily: 'bold',
                                color: AssetsConstants.blackColor,
                                fontWeight: FontWeight.w500,
                              ),
                              ServiceInfoCard(
                                statusAsync: statusAsync,
                                order: order,
                                houseType: houseType,
                                profileUser: profileUser,
                              )
                            ],
                          )
                        : Column(
                            children: [
                              const ProfileInfo(),
                              const SizedBox(height: 20),
                              const LabelText(
                                content: 'Thông tin đánh giá',
                                size: 20,
                                fontFamily: 'bold',
                                color: AssetsConstants.blackColor,
                                fontWeight: FontWeight.w500,
                              ),
                              ServiceInfoCard(
                                statusAsync: statusAsync,
                                order: order,
                                houseType: houseType,
                                profileUser: profileUser,
                              )
                            ],
                          ),
                const SizedBox(height: 20),
                (statusOrders == BookingStatusType.assigned &&
                            order.isReviewOnline == false) ||
                        (statusOrders == BookingStatusType.reviewed &&
                            order.isReviewOnline == true)
                    ? Column(
                        children: [
                          FadeInLeft(
                            child: const Padding(
                              padding: EdgeInsets.only(left: 16.0),
                              child: Text(
                                "Map",
                                style: TextStyle(
                                    fontSize: 20, fontWeight: FontWeight.bold),
                              ),
                            ),
                          ),
                          const MapWidget(),
                        ],
                      )
                    : Container(),
                const SizedBox(height: 10),
                (statusOrders == BookingStatusType.reviewed)
                    ? CustomerInfo(
                        statusOrders: statusOrders,
                        isExpanded: isExpanded,
                        toggleDropdown: toggleDropdown,
                      )
                    : Container(),
                const SizedBox(height: 20),
                PriceDetails(
                  order: order,
                  serviceAll: serviceAll,
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
