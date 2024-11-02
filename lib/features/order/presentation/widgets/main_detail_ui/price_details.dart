// components/price_details.dart

import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:movemate/features/order/domain/entites/order_entity.dart';
import 'package:movemate/utils/commons/functions/string_utils.dart';
import 'package:movemate/utils/enums/enums_export.dart';
import 'package:auto_route/auto_route.dart';
import 'package:movemate/configs/routes/app_router.dart';
import 'package:movemate/features/order/presentation/widgets/details/item.dart';
import 'package:movemate/features/order/presentation/widgets/details/priceItem.dart';

class PriceDetails extends ConsumerWidget {
  final OrderEntity order;
  final AsyncValue<BookingStatusType> statusAsync;

  const PriceDetails({
    super.key,
    required this.order,
    required this.statusAsync,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {

    
    return Container(
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
          ...order.bookingDetails
              .where((detail) => detail.type == "TRUCK")
              .map((truckDetail) => buildItem(
                    imageUrl:
                        'https://storage.googleapis.com/a1aa/image/9rjSBLSWxmoedSK8EHEZx3zrEUxndkuAofGOwCAMywzUTWlTA.jpg',
                    title: truckDetail.name ?? 'Xe Tải',
                    description: truckDetail.description ?? 'Không có mô tả',
                  )),

          ...order.bookingDetails.map<Widget>((detail) {
            return buildPriceItem(
              detail.name ?? '',
              detail.price.toString(),
            );
          }),
          buildSummary('Tiền đặt cọc', order.deposit.toString()),
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
          // The 'Ghi chú' (Note) section
          const Align(
            alignment: Alignment.centerLeft,
            child: Text(
              'Ghi chú',
              style: TextStyle(fontSize: 12, color: Colors.grey),
            ),
          ),
          const SizedBox(height: 5),
          Align(
            alignment: Alignment.centerLeft,
            child: Text(
              "${order.note == '' ? 'Không có ghi chú' : order.note}", // Display the note from the order
              style: const TextStyle(fontSize: 14, color: Colors.black),
            ),
          ),

          const SizedBox(height: 20),
          statusAsync.when(
            data: (status) {
              final isButtonEnabled = status == BookingStatusType.waiting ||
                  status == BookingStatusType.depositing ||
                  status == BookingStatusType.reviewed ||
                  status == BookingStatusType.coming;

              String buttonText;

              buttonText = getBookingStatusText(status).nextStep;

              return ElevatedButton(
                onPressed: isButtonEnabled
                    ? () {
                        if (status == BookingStatusType.depositing) {
                          context.pushRoute(PaymentScreenRoute(id: order.id));
                        } else if (status == BookingStatusType.reviewed) {
                          context.pushRoute(ReviewOnlineRoute(order: order));
                        } else {
                          context.pushRoute(ReviewAtHomeRoute(order: order));
                        }
                      }
                    : null,
                style: ElevatedButton.styleFrom(
                  backgroundColor:
                      isButtonEnabled ? const Color(0xFFFF9900) : Colors.grey,
                  padding: const EdgeInsets.symmetric(vertical: 15),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(5),
                  ),
                  fixedSize: const Size(400, 50),
                ),
                child: Text(
                  buttonText,
                  style: TextStyle(
                    color: isButtonEnabled ? Colors.white : Colors.black,
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
    );
  }
}
