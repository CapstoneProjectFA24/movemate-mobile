import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';
import 'package:movemate/configs/routes/app_router.dart';
import 'package:movemate/features/booking/data/models/resquest/cancel_booking.dart';
import 'package:movemate/features/booking/presentation/screens/controller/booking_controller.dart';
import 'package:movemate/features/booking/presentation/widgets/booking_screen_2th/booking_package/sub_service_tile.dart';
import 'package:movemate/features/order/domain/entites/order_entity.dart';
import 'package:movemate/utils/commons/widgets/widgets_common_export.dart';
import 'package:movemate/utils/constants/asset_constant.dart';

@RoutePage()
class RefundScreen extends HookConsumerWidget {
  final OrderEntity order;
  const RefundScreen({
    super.key,
    required this.order,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(bookingControllerProvider);

    final reasons = [
      'Bất khả kháng',
      'Muốn thay đổi dịch vụ trong đơn hàng',
      'Thay đổi liên quan đến công việc/kinh doanh',
      'Bệnh hoặc gặp những vấn đề liên quand dến sức khỏe khác',
      'Lý do khác',
    ];

    final selectedReason = useState<String?>(null);
    return LoadingOverlay(
      isLoading: state.isLoading,
      child: Scaffold(
        backgroundColor: const Color(0xFFF5F5F5),
        appBar: const CustomAppBar(
          backgroundColor: AssetsConstants.primaryMain,
          backButtonColor: AssetsConstants.whiteColor,
          title: "Yêu cầu hoàn tiền",
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
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Lý do hoàn lại',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 10),
                ...reasons.map((reason) => RadioListTile(
                      title: Text(
                        reason,
                        style: const TextStyle(
                          color: Colors.black,
                        ),
                      ),
                      value: reason,
                      activeColor: Colors.orangeAccent,
                      groupValue: selectedReason.value,
                      onChanged: (value) {
                        selectedReason.value = value;
                        // Xử lý khi chọn lý do
                        print('Đã chọn lý do: $value');
                      },
                    )),
                const SizedBox(height: 10),
                const Text(
                  'Chính sách hoàn lại khác nhau dựa trên thời gian hủy đơn dọn nhà của bạn',
                  style: TextStyle(fontSize: 16, color: Color(0xFF666666)),
                ),
                const SizedBox(height: 20),
                _buildRefundPolicyCard(
                  title: 'Giá trị hoàn ước tính',
                  content:
                      'Hoàn tiền 100% tiền đặt cọc nếu hủy đặt lịch ít nhất 48 giờ trước thời gian dọn nhà',
                  amount: formatPrice(order.deposit.toInt()),
                ),
                const SizedBox(height: 10),
                _buildRefundPolicyCard(
                  title: 'Hoàn Tiền 70% tiền đặt cọc',
                  content:
                      'Nếu hủy dịch vụ trong vòng 24 đến 48 giờ trước thời gian dọn nhà, MoveMate sẽ hoàn lại 70% phí đặt lịch để bù đắp chi phí chuẩn bị',
                  amount: formatPrice((order.deposit * 0.7).toInt()),
                ),
                const SizedBox(height: 10),
                _buildRefundPolicyCard(
                  title: 'Hoàn Tiền 50% tiền đặt cọc',
                  content:
                      'Nếu hủy trong vòng 1 đến 24 giờ trước thời gian dọn nhà, MoveMate sẽ hoàn lại 50% phí dịch vụ',
                  amount: formatPrice((order.deposit * 0.5).toInt()),
                ),
                const SizedBox(height: 20),
                const SizedBox(height: 20),
                _buildFAQItem(
                  'Quá trình hoàn tiền mất bao lâu?',
                  'Quy trình hoàn tiền phụ thuộc vào chính sách của nhà cung cấp dịch vụ. MoveMate sẽ cập nhật thông tin đến quý khách trong suốt quá trình xử lý',
                ),
                const SizedBox(height: 20),
                _buildFAQItem(
                  'Làm thế nào tôi có thể gửi yêu cầu hoàn tiền?',
                  'Nhấp Bắt đầu Hoàn tiền bên dưới và chúng tôi sẽ xử lý yêu cầu của bạn. Đừng lo, đơn hàng của bạn vẫn còn hiệu lực cho đến khi bạn gửi yêu cầu hoàn tiền ở bên dưới',
                ),
                const SizedBox(height: 20),
                SizedBox(
                  width: double.infinity,
                  height: 54,
                  child: ElevatedButton(
                    onPressed: (selectedReason.value != null || state.isLoading)
                        ? () async {
                            final tabsRouter = context.router.root
                                .innerRouterOf<TabsRouter>(
                                    TabViewScreenRoute.name);
                            final cancelRequest = CancelBooking(
                              id: order.id,
                              cancelReason: selectedReason.value ?? '',
                            );

                            await ref
                                .read(bookingControllerProvider.notifier)
                                .cancelBooking(
                                  request: cancelRequest,
                                  id: order.id,
                                  context: context,
                                );

                            if (tabsRouter != null) {
                              tabsRouter.setActiveIndex(0);
                              context.router.popUntilRouteWithName(
                                  TabViewScreenRoute.name);
                            } else {
                              context.router.pushAndPopUntil(
                                const TabViewScreenRoute(children: [
                                  HomeScreenRoute(),
                                ]),
                                predicate: (route) => false,
                              );
                            }
                          }
                        : null,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.transparent,
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                        side: BorderSide(
                          color:
                              (selectedReason.value != null || state.isLoading)
                                  ? Colors.orange
                                  : Colors.grey,
                          width: 1,
                        ),
                      ),
                    ),
                    child: LabelText(
                      content: 'Yêu cầu hoàn tiền',
                      size: 14,
                      color: (selectedReason.value != null || state.isLoading)
                          ? Colors.orange
                          : Colors.grey,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildRefundPolicyCard({
    String? title,
    required String content,
    required String amount,
  }) {
    return Container(
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.6),
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, 0),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (title != null)
            Text(
              title,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.orangeAccent,
              ),
            ),
          if (title != null) const SizedBox(height: 10),
          Text(
            content,
            style: const TextStyle(fontSize: 16),
          ),
          const SizedBox(height: 10),
          Align(
            alignment: Alignment.centerRight,
            child: Text(
              amount,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFAQItem(String question, String answer) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          question,
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 10),
        Text(
          answer,
          style: const TextStyle(
            fontSize: 16,
            color: Color(0xFF666666),
          ),
        ),
      ],
    );
  }
}
