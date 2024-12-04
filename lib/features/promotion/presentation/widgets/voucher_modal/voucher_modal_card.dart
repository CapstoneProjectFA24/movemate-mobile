// voucher_modal_card.dart
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:intl/intl.dart';
import 'package:movemate/features/promotion/domain/entities/promotion_entity.dart';
import 'package:movemate/features/promotion/domain/entities/voucher_entity.dart';
import 'package:movemate/features/promotion/presentation/controller/promotion_controller.dart';
import 'package:movemate/hooks/use_fetch_obj.dart';
import 'package:movemate/utils/commons/widgets/widgets_common_export.dart';

class VoucherModalCard extends HookConsumerWidget {
  final VoucherEntity voucher;
  final bool isSelected;
  final bool isDisabled;
  final Function(VoucherEntity) onVoucherUsed;
  final Function(VoucherEntity) onVoucherCanceled;
  final int index;

  const VoucherModalCard({
    super.key,
    required this.voucher,
    required this.isSelected,
    required this.isDisabled,
    required this.onVoucherUsed,
    required this.onVoucherCanceled,
    required this.index,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(promotionControllerProvider);

    final useFetchResultPromotion = useFetchObject<PromotionEntity>(
      function: (context) => ref
          .read(promotionControllerProvider.notifier)
          .getPromotionById(context, voucher.promotionCategoryId),
      context: context,
    );
    final promotion = useFetchResultPromotion.data;
    print("checking promotion by id ${useFetchResultPromotion.data?.toJson()}");
    return LoadingOverlay(
      isLoading: state.isLoading,
      child: Card(
        color: Colors.white,
        margin: const EdgeInsets.only(bottom: 16.0),
        elevation: 3.0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12.0),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  const Icon(
                    Icons.card_giftcard,
                    color: Colors.amberAccent,
                    size: 40.0,
                  ),
                  const SizedBox(width: 16.0),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Phiếu giảm giá ${promotion?.name} ${voucher.id}',
                          style: const TextStyle(
                            color: Colors.black,
                            fontSize: 16.0,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 8.0),
                        if (isDisabled)
                          const Text(
                            'Đã có voucher khác từ cùng chương trình được chọn',
                            style: TextStyle(
                              color: Colors.red,
                              fontSize: 14.0,
                              fontStyle: FontStyle.italic,
                            ),
                          )
                        else
                          Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Column(
                                children: [
                                  Text(
                                    'Giảm ${promotion?.discountRate}% cho đơn hàng',
                                    style: const TextStyle(
                                      color: Colors.grey,
                                      fontSize: 14.0,
                                    ),
                                  ),
                                  Text(
                                    'Giảm đến ${formatPrice(voucher.price.toInt())}',
                                    style: const TextStyle(
                                      color: Colors.grey,
                                      fontSize: 14.0,
                                    ),
                                  ),
                                ],
                              ),
                              // const SizedBox(
                              //   width: 8,
                              // ),
                              // Column(
                              //   children: [
                              //     Text(
                              //       'Giảm đến ${formatPrice(voucher.price.toInt())}',
                              //       style: TextStyle(
                              //         fontSize: 12, // Giảm kích thước font
                              //         fontWeight: FontWeight.bold,
                              //         color: Colors.orange.shade700,
                              //       ),
                              //     ),
                              //   ],
                              // ),
                            ],
                          ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16.0),
              Row(
                children: [
                  Text(
                    'HSD: ${DateFormat('dd/MM/yy').format(promotion!.endDate)}',
                    style: TextStyle(
                      fontSize: 11, // Giảm kích thước font
                      color: Colors.blue.shade700,
                    ),
                  ),
                  const Spacer(),
                  ElevatedButton(
                    onPressed: isDisabled
                        ? null
                        : () {
                            if (!isSelected) {
                              onVoucherUsed(voucher);
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  backgroundColor: Colors.orange.shade700,
                                  content: Text(
                                    'Đã sử dụng phiếu giảm giá ${index + 1}',
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              );
                            } else {
                              onVoucherCanceled(voucher);
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  backgroundColor: Colors.red.shade700,
                                  content: Text(
                                    'Đã hủy phiếu giảm giá ${index + 1}',
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              );
                            }
                          },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: isSelected
                          ? Colors.red
                          : (isDisabled ? Colors.grey : Colors.orange),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20.0),
                      ),
                    ),
                    child: Text(
                      isSelected
                          ? 'Hủy'
                          : (isDisabled ? 'Không khả dụng' : 'Sử dụng'),
                      style: const TextStyle(
                        color: Colors.white,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// Hàm hỗ trợ để định dạng giá
String formatPrice(int price) {
  final formatter = NumberFormat('#,###', 'vi_VN');
  return '${formatter.format(price)} đ';
}