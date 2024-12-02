import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:movemate/configs/routes/app_router.dart';
import 'package:movemate/features/order/domain/entites/order_entity.dart';
import 'package:movemate/utils/constants/asset_constant.dart';

import '../../../../../../utils/commons/widgets/widgets_common_export.dart';

@RoutePage()
class ConfirmLastPayment extends HookConsumerWidget {
  final OrderEntity? orderObj;
  final int id;
  const ConfirmLastPayment(
      {super.key, required this.orderObj, required this.id});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // hàm để định dạng ngày tháng
    final formattedDateBookingAt = DateFormat('dd/MM/yyyy')
        .format(DateTime.parse(orderObj!.bookingAt.toString()));
    final formattedTimeBookingAt = DateFormat('hh:mm')
        .format(DateTime.parse(orderObj!.bookingAt.toString()));
    return Scaffold(
      appBar: const CustomAppBar(
        title: 'Xác nhận nghiệm thu',
        centerTitle: true,
        backgroundColor: AssetsConstants.primaryMain,
        backButtonColor: AssetsConstants.whiteColor,
      ),
      backgroundColor: Colors.grey[100],
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: Image.network(
                    'https://res.cloudinary.com/dkpnkjnxs/image/upload/v1732365346/movemate_logo_esm5fx.png',
                    height: 130,
                    width: 180,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              const SizedBox(height: 16),
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.grey[100],
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        const Icon(Icons.location_on, color: Colors.blue),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            orderObj?.pickupAddress ?? '',
                            overflow: TextOverflow.ellipsis,
                            maxLines: 4,
                            style: const TextStyle(fontSize: 12),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        const Icon(Icons.location_on, color: Colors.red),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            orderObj?.deliveryAddress ?? '',
                            overflow: TextOverflow.ellipsis,
                            maxLines: 4,
                            style: const TextStyle(fontSize: 12),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              const _SummaryItem(
                label: 'Chi tiết đơn hàng',
                value: '',
                isBold: true,
              ),
              const SizedBox(height: 8),
              ...orderObj!.bookingDetails.map<Widget>((detail) {
                return _OrderItem(
                  label: detail.name ?? '',
                  price: formatPrice(detail.price.toInt()),
                );
              }),
              const SizedBox(height: 8),
              const Divider(),
              const SizedBox(height: 8),
              _OrderItem(
                label: 'Đặt cọc',
                price: formatPrice(orderObj!.deposit.toInt()),
              ),
              const SizedBox(height: 8),
              _OrderItem(
                label: 'Tổng giá',
                price: formatPrice(orderObj!.total.toInt()),
              ),
              const SizedBox(height: 8),
              _OrderItem(
                label: 'Số tiền còn lại phải thanh toán',
                isBold: true,
                price: formatPrice(
                    ((orderObj!.total) - (orderObj!.deposit)).toInt()),
              ),
              const SizedBox(height: 16),
              _SummaryItem(
                label: 'Ghi chú:',
                value: (orderObj?.note != null && orderObj!.note!.isNotEmpty)
                    ? orderObj!.note!
                    : 'Không có',
                isGrey: true,
              ),
              _SummaryItem(
                label: 'Mã đơn hàng:',
                value: orderObj!.id.toString(),
                isGrey: true,
              ),
              _SummaryItem(
                label: 'Thời gian vận chuyển:',
                isGrey: true,
                value: '$formattedDateBookingAt - $formattedTimeBookingAt',
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SizedBox(
          width: double.infinity,
          height: 54,
          child: ElevatedButton(
            onPressed: () {
              context.router.push(LastPaymentScreenRoute(
                id: id,
              ));
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFFFF9900),
              elevation: 2,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            child: const LabelText(
              content: ' Xác nhận hoàn thành',
              size: 16,
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    );
  }
}

class _OrderItem extends StatelessWidget {
  final String label;
  final String price;
  final bool isBold;

  const _OrderItem({
    required this.label,
    required this.price,
    this.isBold = false,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: TextStyle(
              fontWeight: isBold ? FontWeight.bold : FontWeight.normal,
            ),
          ),
          Text(
            price,
            style: TextStyle(
              fontWeight: isBold ? FontWeight.bold : FontWeight.normal,
            ),
          ),
        ],
      ),
    );
  }
}

class _SummaryItem extends StatelessWidget {
  final String label;
  final String value;
  final bool isGrey;
  final bool isBold;
  const _SummaryItem({
    required this.label,
    required this.value,
    this.isGrey = false,
    this.isBold = false,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: TextStyle(
              color: isGrey
                  ? AssetsConstants.greyColor
                  : AssetsConstants.blackColor,
              fontWeight: isBold ? FontWeight.bold : FontWeight.normal,
            ),
          ),
          Text(value),
        ],
      ),
    );
  }
}

String formatPrice(int price) {
  final formatter = NumberFormat('#,###', 'vi_VN');
  return '${formatter.format(price)} đ';
}
