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
import 'package:movemate/features/order/presentation/widgets/details/address.dart';
import 'package:movemate/features/order/presentation/widgets/details/booking_code.dart';
import 'package:movemate/features/order/presentation/widgets/details/column.dart';
import 'package:movemate/features/order/presentation/widgets/details/infoItem.dart';
import 'package:movemate/features/order/presentation/widgets/details/item.dart';
import 'package:movemate/features/order/presentation/widgets/details/policies.dart';
import 'package:movemate/features/order/presentation/widgets/details/priceItem.dart';
import 'package:movemate/features/order/presentation/widgets/details/summary.dart';
import 'package:movemate/features/order/presentation/widgets/details/timeLine_title.dart';
import 'package:movemate/features/order/presentation/widgets/profile_card.dart';
import 'package:movemate/hooks/use_fetch_obj.dart';
import 'package:movemate/models/request/paging_model.dart';
import 'package:movemate/services/realtime_service/booking_status_realtime/booking_status_stream_provider.dart';
import 'package:movemate/utils/commons/widgets/app_bar.dart';
import 'package:movemate/utils/constants/asset_constant.dart';
import 'package:movemate/utils/enums/enums_export.dart';
import 'package:movemate/utils/commons/functions/string_utils.dart';
// Hooks
import 'package:movemate/hooks/use_fetch.dart';
import 'package:animate_do/animate_do.dart';
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
    final isExpanded1 = useState(false);
    final expandedIndex = useState<int>(-1);
    final truckImgUrl = useState<String>('');
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
      initialPagingModel: PagingModel(
        searchContent: "1",
      ),
      context: context,
    );

    final houseType = useFetchResult.data;
    // final logTest = useFetchResult.data;
    final truckBookingDetails =
        order.bookingDetails.where((detail) => detail.type == 'TRUCK').toList();

    String getServiceImageUrl(int serviceId) {
      final service = fetchResultVehicle.items.firstWhere(
        (service) => service.id == serviceId,
        orElse: () => ServiceEntity(
          id: 0,
          name: '',
          description: '',
          isActived: false,
          tier: 0,
          imageUrl: '',
          type: '',
          discountRate: 0,
          amount: 0,
        ),
      );
      return service.truckCategory?.imgUrl ?? '';
    }

    print(houseType?.toJson());
    // print(logTest);

    void toggleDropdown() {
      isExpanded.value = !isExpanded.value;
    }

    void toggleDropdown1() {}

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
              FadeInUp(
                child: Padding(
                    padding: const EdgeInsets.only(left: 14.0),
                    child: statusAsync.when(
                      data: (status) => Text(
                        getBookingStatusText(status).statusText,
                        style: const TextStyle(
                            fontSize: 20, fontWeight: FontWeight.w500),
                      ),
                      loading: () => const CircularProgressIndicator(),
                      error: (err, stack) => Text('Error: $err'),
                    )),
              ),
              const SizedBox(height: 10),
              Padding(
                padding: const EdgeInsets.only(left: 14.0),
                child: FadeInUp(
                  child: const Text(
                    "MoveMate sẽ gửi thông tin đến bạn sau",
                    style: TextStyle(fontSize: 14),
                  ),
                ),
              ),
              const SizedBox(height: 50),
              SizedBox(
                height: 35,
                child: Padding(
                  padding: const EdgeInsets.only(right: 8.0),
                  child: FadeInLeft(
                    child: ListView(
                      scrollDirection: Axis.horizontal,
                      children: const [
                        MyTimelineTitle(
                            isFirst: true, isLast: false, isPast: true),
                        MyTimelineTitle(
                            isFirst: false, isLast: false, isPast: true),
                        MyTimelineTitle(
                            isFirst: false, isLast: false, isPast: false),
                        MyTimelineTitle(
                            isFirst: false, isLast: true, isPast: false),
                        //isFirst: xét là đầu tiên
                        //isLast: xét là cuối cùng
                        //isPast: xét là enable
                      ],
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 2.0),
                child: FadeInLeft(
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: List.generate(steps.length, (index) {
                          final step = steps[index];
                          return GestureDetector(
                            onTap: () {
                              expandedIndex.value =
                                  expandedIndex.value == index ? -1 : index;
                            },
                            child: Column(
                              children: [
                                // Tiêu đề
                                Text(
                                  step['title'],
                                  textAlign: TextAlign.center,
                                  style: const TextStyle(fontSize: 14),
                                ),
                              ],
                            ),
                          );
                        }),
                      ),
                      ...List.generate(steps.length, (index) {
                        final step = steps[index];
                        return Visibility(
                          visible: expandedIndex.value == index,
                          child: Container(
                            width: 350,
                            height: 300,
                            margin: const EdgeInsets.only(top: 20.0),
                            padding: const EdgeInsets.all(10.0),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(8),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.grey.withOpacity(0.3),
                                  spreadRadius: 2,
                                  blurRadius: 5,
                                  offset: const Offset(0, 3),
                                ),
                              ],
                            ),
                            child: Column(
                              children: List.generate(step['details'].length,
                                  (detailIndex) {
                                return TimelineTile(
                                  alignment: TimelineAlign.start,
                                  isFirst: detailIndex == 0,
                                  isLast:
                                      detailIndex == step['details'].length - 1,
                                  indicatorStyle: IndicatorStyle(
                                    color: detailIndex <= index
                                        ? AssetsConstants.primaryMain
                                        : Colors.grey,
                                    iconStyle: IconStyle(
                                      iconData: Icons.circle,
                                      color: Colors.white,
                                    ),
                                  ),
                                  endChild: Container(
                                    margin: const EdgeInsets.only(left: 8),
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 16), // Thêm padding dọc
                                    child: Text(
                                      step['details'][detailIndex],
                                      style: const TextStyle(fontSize: 18),
                                    ),
                                  ),
                                  beforeLineStyle: LineStyle(
                                    color: detailIndex <= index
                                        ? AssetsConstants.primaryMain
                                        : Colors.grey,
                                    thickness: 4,
                                  ),
                                );
                              }),
                            ),
                          ),
                        );
                      }),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 30),
              Padding(
                padding: const EdgeInsets.only(left: 8.0),
                child: FadeInUp(
                  child: Center(
                    child: Container(
                      width: 350,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(10),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.1),
                            spreadRadius: 2,
                            blurRadius: 4,
                          ),
                        ],
                      ),
                      child: Column(
                        children: [
                          Container(
                            decoration: const BoxDecoration(
                              color: AssetsConstants.primaryMain,
                              borderRadius: BorderRadius.vertical(
                                  top: Radius.circular(10)),
                            ),
                            padding: const EdgeInsets.all(15),
                            child: const Row(
                              children: [
                                Icon(FontAwesomeIcons.home,
                                    color: Colors.white),
                                SizedBox(width: 10),
                                Text('Thông tin dịch vụ',
                                    style: TextStyle(
                                        color: Colors.white, fontSize: 18)),
                              ],
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(16),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  // 'Loại nhà : ${order.houseTypeId ?? "label"}',
                                  'Loại nhà : ${houseType?.name ?? "label"}',
                                  style: const TextStyle(
                                      fontWeight: FontWeight.bold),
                                ),
                                const SizedBox(height: 10),
                                buildAddressRow(
                                  Icons.location_on_outlined,
                                  'Từ:  ${order.pickupAddress} ',
                                ),
                                const Divider(
                                    height: 12,
                                    color: Colors.grey,
                                    thickness: 1),
                                buildAddressRow(
                                  Icons.location_searching,
                                  'Đến : ${order.pickupAddress}',
                                ),
                                const SizedBox(height: 20),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    buildDetailColumn(FontAwesomeIcons.building,
                                        "Tầng :${order.floorsNumber}"),
                                    buildDetailColumn(FontAwesomeIcons.building,
                                        "Phòng : ${order.roomNumber}"),
                                  ],
                                ),
                                const SizedBox(height: 20),
                                buildPolicies(FontAwesomeIcons.checkCircle,
                                    'Miễn phí hủy đơn hàng'),
                                const SizedBox(height: 20),
                                buildPolicies(FontAwesomeIcons.checkCircle,
                                    'Áp dụng chính sách đổi lịch'),
                                const SizedBox(height: 20),
                                buildBookingCode('Mã khuyến mãi', 'FD8UH6'),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
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
              Padding(
                padding: const EdgeInsets.only(
                    left: 20.0, top: 16, right: 16, bottom: 16),
                child: FadeInUp(
                  child: Container(
                    width: 400,
                    height: 150,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.1),
                          spreadRadius: 2,
                          blurRadius: 4,
                        ),
                      ],
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(10), // Bo góc cho ảnh
                      child: Image.network(
                        'https://storage.googleapis.com/a1aa/image/h2LnipfLWGVDFSNFJQfaZSX6zdfSAbOI7N8q2e1ECXUTMXVOB.jpg',
                        fit: BoxFit
                            .cover, // Điều chỉnh ảnh để vừa khít container
                        errorBuilder: (context, error, stackTrace) {
                          return const Center(
                            child: Icon(Icons
                                .error), // Hiển thị icon khi không tải được ảnh
                          );
                        },
                        loadingBuilder: (context, child, loadingProgress) {
                          if (loadingProgress == null) {
                            return child; // Hiển thị ảnh nếu đã tải xong
                          } else {
                            return const Center(
                              child:
                                  CircularProgressIndicator(), // Hiển thị loading khi đang tải ảnh
                            );
                          }
                        },
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: ProfileCard(
                  title: "Thông tin người đánh giá",
                  profileImageUrl:
                      'https://storage.googleapis.com/a1aa/image/kQqIOadQcVp4CFdZfMh5llKP6sUMpfDr5KIUucyHmaXaArsTA.jpg',
                  name: 'Lê Văn Phước Đại',
                  rating: 5.0,
                  ratingDetails: '73-H1 613.58',
                  onPhonePressed: () {
                    // Xử lý khi nhấn vào biểu tượng điện thoại
                    // Ví dụ: Mở ứng dụng gọi điện
                  },
                  onCommentPressed: () {
                    // Xử lý khi nhấn vào biểu tượng bình luận
                    // Ví dụ: Mở ứng dụng nhắn tin
                  },
                ),
              ),
              const SizedBox(height: 20),
              Padding(
                padding: const EdgeInsets.only(left: 16.0),
                child: FadeInLeft(
                  child: const Text("Thông tin khách hàng",
                      style:
                          TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
                ),
              ),
              // const Padding(
              //   padding: EdgeInsets.only(left: 16.0, top: 20),
              //   child: Text("Thông tin liên hệ",
              //       style:
              //           TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
              // ),
              // Padding(
              //   padding: const EdgeInsets.only(left: 16.0),
              //   child: Text("id :${order.userId}",
              //       style: const TextStyle(
              //           fontSize: 18, fontWeight: FontWeight.bold)),
              // ),

              const SizedBox(height: 20),
              Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  border: Border.all(color: const Color(0xFFDDDDDD)),
                  borderRadius: BorderRadius.circular(5),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      blurRadius: 2,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                padding: const EdgeInsets.all(20),
                width: double.infinity,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'Thông tin liên hệ',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        IconButton(
                          icon: Icon(
                            isExpanded.value
                                ? Icons.arrow_drop_up
                                : Icons.arrow_drop_down,
                            color: Colors.black54,
                          ),
                          onPressed: toggleDropdown, // Toggle dropdown
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    // Show customer info only if isExpanded.value is true
                    if (isExpanded.value) ...[
                      buildInfoItem('Họ và tên', 'NGUYEN VAN ANH'),
                      buildInfoItem('Số điện thoại', '0900123456'),
                      buildInfoItem('Email', 'nguyenvananh@gmail.com'),
                    ],
                  ],
                ),
              ),
              const SizedBox(height: 20),
              Container(
                // margin: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      blurRadius: 10,
                      offset: const Offset(0, 0),
                    ),
                  ],
                ),
                padding: const EdgeInsets.all(20),
                width: double.infinity,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'chi tiết giá',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    // buildItem(
                    //   imageUrl:
                    //       'https://storage.googleapis.com/a1aa/image/9rjSBLSWxmoedSK8EHEZx3zrEUxndkuAofGOwCAMywzUTWlTA.jpg',
                    //   title: 'Xe Tải 1250 kg',
                    //   description:
                    //       'Giờ Cấm Tải 6H-9H & 16H-20H | Chở tới đa 1250kg & 7CBM\n3.1 x 1.6 x 1.6 Mét - Lên đến 1250 kg',
                    // ),
                    ...truckBookingDetails.map<Widget>((detail) {
                      final imageUrl = getServiceImageUrl(detail.serviceId);
                      return buildItem(
                        imageUrl: imageUrl,
                        title: detail.name,
                        description: detail.description,
                      );
                    }),
                    ...order.bookingDetails.map<Widget>((detail) {
                      return buildPriceItem(
                        detail.name ?? '',
                        detail.price.toString() ?? '',
                      );
                    }),
                    buildSummary('Tiền đặt cọc', order.total.toString()),
                    buildSummary('Tiền trả liền', order.totalFee.toString()),
                    const Divider(color: Colors.grey, thickness: 1),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Padding(
                          padding: EdgeInsets.symmetric(vertical: 10),
                          child: Text(
                            'Đặt cọc',
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.grey,
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 10),
                          child: Text(
                            '${order.totalReal} đ',
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Colors.black,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const Align(
                      alignment: Alignment.centerRight,
                      child: Text(
                        'Ghi chú',
                        style: TextStyle(fontSize: 12, color: Colors.grey),
                      ),
                    ),
                    const SizedBox(height: 20),
                    statusAsync.when(
                      data: (status) {
                        final isButtonEnabled =
                            status == BookingStatusType.waiting ||
                                status == BookingStatusType.depositing ||
                                status == BookingStatusType.reviewed ||
                                status == BookingStatusType.coming;

                        String buttonText;

                        buttonText = getBookingStatusText(status).nextStep;

                        return ElevatedButton(
                          onPressed: isButtonEnabled
                              ? () {
                                  if (status == BookingStatusType.depositing) {
                                    context.pushRoute(
                                        PaymentScreenRoute(id: order.id));
                                  } else if (status ==
                                      BookingStatusType.reviewed) {
                                    context.pushRoute(
                                        ReviewOnlineRoute(order: order));
                                  } else {
                                    context.pushRoute(
                                        ReviewAtHomeRoute(order: order));
                                  }
                                }
                              : null,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: isButtonEnabled
                                ? const Color(0xFFFF9900)
                                : Colors.grey,
                            padding: const EdgeInsets.symmetric(vertical: 15),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(5),
                            ),
                            fixedSize: const Size(400, 50),
                          ),
                          child: Text(
                            buttonText,
                            style: TextStyle(
                              color:
                                  isButtonEnabled ? Colors.white : Colors.black,
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        );
                      },
                      loading: () => const CircularProgressIndicator(),
                      error: (err, stack) => Text('Error: $err'),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
