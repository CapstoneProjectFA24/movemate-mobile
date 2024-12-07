import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:movemate/configs/routes/app_router.dart';
import 'package:movemate/features/order/presentation/screens/order_detail_screen.dart/confirm_last_payment/confirm_last_payment.dart';
import 'package:movemate/features/profile/domain/entities/order_tracker_entity_response.dart';
import 'package:movemate/utils/commons/widgets/app_bar.dart';
import 'package:movemate/utils/constants/asset_constant.dart';
import 'package:movemate/utils/providers/common_provider.dart';

@RoutePage()
class IncidentDetailsScreen extends HookConsumerWidget {
  final BookingTrackersIncidentEntity incident;

  const IncidentDetailsScreen({super.key, required this.incident});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Sample image list - replace with your actual images
    // Xử lý thời gian
    final timeString = incident.time;
    final dateParts = timeString.split(" ")[0].split("-");
    final timeParts = timeString.split(" ")[1].split(":");
    final dateTime = DateTime(
      int.parse(dateParts[0]) + 2000,
      int.parse(dateParts[1]),
      int.parse(dateParts[2]),
      int.parse(timeParts[0]),
      int.parse(timeParts[1]),
      int.parse(timeParts[2]),
    );

    final day = DateFormat('EE').format(dateTime);
    final date = DateFormat('dd-MM-yyyy').format(dateTime);
    final time = DateFormat('HH:mm').format(dateTime);

    final user = ref.read(authProvider);
    // Xử lý realAmount nếu là null
    final realAmountText = incident.realAmount != null
        ? formatPrice(incident.realAmount?.toInt() ?? 0)
        : 'Đang chờ...';
    String statusText = '';
    Color statusColor = Colors.black;
    switch (incident.status) {
      case 'PENDING':
        statusText = 'Đang chờ nhân viên duyệt';
        statusColor = Colors.orange;
        break;
      case 'WAITING':
        statusText = 'Chờ quản lý duyệt';
        statusColor = Colors.blue;
        break;
      case 'AVAILABLE':
        statusText = 'Đã bồi thường';
        statusColor = Colors.green;
        break;
      case 'NOTAVAILABLE':
        statusText = 'Không bồi thường';
        statusColor = Colors.red;
        break;
      default:
        statusText = 'Trạng thái không xác định';
        statusColor = Colors.grey;
    }
    return Scaffold(
      appBar: const CustomAppBar(
        backgroundColor: AssetsConstants.primaryMain,
        backButtonColor: AssetsConstants.whiteColor,
        title: "Chi tiết sự cố",
        centerTitle: true,
        // iconSecond: Icons.home_outlined,
        // onCallBackSecond: () {
        //   final tabsRouter = context.router.root
        //       .innerRouterOf<TabsRouter>(TabViewScreenRoute.name);
        //   if (tabsRouter != null) {
        //     tabsRouter.setActiveIndex(0);
        //     context.router.popUntilRouteWithName(TabViewScreenRoute.name);
        //   } else {
        //     context.router.pushAndPopUntil(
        //       const TabViewScreenRoute(children: [
        //         HomeScreenRoute(),
        //       ]),
        //       predicate: (route) => false,
        //     );
        //   }
        // },
      ),
      body: Stack(
        children: [
          SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Center(
                    child: Text(
                      incident.title,
                      style: const TextStyle(
                        fontSize: 24.0,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF333333),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20.0),
                  _buildInfoSection(
                    'Mã đơn hàng',
                    'BOK${incident.bookingId}',
                    statusText,
                    icon: Icons.receipt_long,
                    statusColor: statusColor,
                  ),
                  const Divider(height: 30),
                  _buildSectionTitle('Thông tin khách hàng', Icons.person),
                  const SizedBox(height: 10),
                  _buildInfoRow('Tên', '${user?.name}'),
                  _buildInfoRow('Email', '${user?.email}'),
                  _buildInfoRow('Số điện thoại', '${user?.phone}'),
                  const SizedBox(height: 20),
                  _buildSectionTitle('Hình ảnh', Icons.image),
                  const SizedBox(height: 10),
                  SizedBox(
                    height: 100,
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: incident.trackerSources.length,
                      itemBuilder: (context, index) {
                        return Container(
                          width: 100,
                          margin: const EdgeInsets.only(right: 10),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(8),
                            color: Colors.grey[300],
                          ),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(8),
                            child: Image.network(
                              incident.trackerSources[index].resourceUrl,
                              //handel error imagne if not found image
                              errorBuilder: (context, error, stackTrace) {
                                return const Icon(
                                  Icons.image,
                                  size: 40,
                                  color: Colors.grey,
                                );
                              },
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                  const SizedBox(height: 20),
                  _buildSectionTitle('Thông tin sự cố', Icons.money),
                  const SizedBox(height: 10),
                  _buildInfoRow(
                    'Số tiền yêu cầu',
                    formatPrice(incident.estimatedAmount.toInt()),
                    valueColor: Colors.black,
                    valueFontWeight: FontWeight.bold,
                  ),
                  _buildInfoRow(
                    'Số tiền phản hồi',
                    realAmountText,
                    valueColor: Colors.green,
                    valueFontWeight: FontWeight.bold,
                  ),
                  const SizedBox(height: 20),
                  _buildSectionTitle('Thông tin đơn hàng', Icons.shopping_cart),
                  const SizedBox(height: 10),
                  _buildInfoRow('Ngày', ' $time  $date'),
                  _buildInfoRow(
                    'Tiền đặt cọc',
                    formatPrice(incident.deposit.toInt()),
                    valueFontWeight: FontWeight.bold,
                  ),
                  _buildInfoRow(
                    'Tổng giá',
                    formatPrice(incident.totalReal.toInt()),
                    valueFontWeight: FontWeight.bold,
                  ),
                  const SizedBox(height: 30),
                  _buildSectionTitle('Lý do:', Icons.receipt_sharp),
                  Center(
                    child: Text(
                      // ' ${incident.failedReason}',
                      ' ${incident.failedReason}',
                      style: const TextStyle(
                        fontSize: 14.0,
                        color: Colors.grey,
                        fontStyle: FontStyle.italic,
                      ),
                    ),
                  ),
                  const SizedBox(height: 80),
                ],
              ),
            ),
          ),
          Positioned(
            bottom: 10,
            left: 20,
            right: 20,
            child: ElevatedButton(
              onPressed: () {
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
              style: ElevatedButton.styleFrom(
                foregroundColor: Colors.white,
                backgroundColor: const Color(0xFFff9900),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8.0),
                ),
              ),
              child: const Text(
                'Trở về trang chủ',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionTitle(String title, IconData icon) {
    return Row(
      children: [
        Icon(icon, size: 20, color: const Color(0xFF666666)),
        const SizedBox(width: 8),
        Text(
          title,
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Color(0xFF333333),
          ),
        ),
      ],
    );
  }

  Widget _buildInfoSection(String label, String value, String status,
      {IconData? icon, Color? statusColor}) {
    return Row(
      children: [
        if (icon != null) ...[
          Icon(icon, size: 20, color: const Color(0xFF666666)),
          const SizedBox(width: 8),
        ],
        Text(
          '$label: ',
          style: const TextStyle(
            fontSize: 16,
            color: Color(0xFF666666),
          ),
        ),
        Text(
          value,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: Color(0xFF333333),
          ),
        ),
        const Spacer(),
        Text(
          status,
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.bold,
            color: statusColor ?? const Color(0xFF333333),
          ),
        ),
      ],
    );
  }

  Widget _buildInfoRow(
    String label,
    String value, {
    Color? valueColor,
    FontWeight? valueFontWeight,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: const TextStyle(
              fontSize: 14,
              color: Color(0xFF666666),
            ),
          ),
          Text(
            value,
            style: TextStyle(
              fontSize: 14,
              color: valueColor ?? const Color(0xFF333333),
              fontWeight: valueFontWeight ?? FontWeight.normal,
            ),
          ),
        ],
      ),
    );
  }
}
