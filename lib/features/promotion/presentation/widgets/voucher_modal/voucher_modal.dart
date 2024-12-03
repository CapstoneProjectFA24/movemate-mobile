import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:intl/intl.dart';
import 'package:movemate/features/booking/data/models/resquest/reviewer_status_request.dart';
import 'package:movemate/features/order/domain/entites/order_entity.dart';
import 'package:movemate/features/promotion/domain/entities/voucher_entity.dart';
import 'package:movemate/utils/commons/widgets/form_input/label_text.dart';
import 'package:movemate/utils/constants/asset_constant.dart';
import 'package:movemate/utils/enums/booking_status_type.dart';

class VoucherModal extends HookConsumerWidget {
  final List<VoucherEntity> vouchers;
  final OrderEntity order;
  final List<VoucherEntity> selectedVouchers; // Thêm danh sách đã chọn
  final Function(VoucherEntity) onVoucherUsed;
  final Function(VoucherEntity) onVoucherCanceled;

  const VoucherModal({
    super.key,
    required this.vouchers,
    required this.order,
    required this.selectedVouchers, // Yêu cầu danh sách đã chọn
    required this.onVoucherUsed,
    required this.onVoucherCanceled,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Sử dụng useTextEditingController để quản lý TextEditingController
    final controller = useTextEditingController();

    final localSelectedVouchers =
        useState<List<VoucherEntity>>([...selectedVouchers]);

    // Sử dụng useState để quản lý trạng thái của nút "Áp dụng"
    final isApplyButtonEnabled = useState<bool>(false);

    // Hàm kiểm tra xem có voucher cùng promotionCategoryId đã được chọn chưa
    bool hasExistingVoucherWithSamePromotion(VoucherEntity voucher) {
      return localSelectedVouchers.value.any((selectedVoucher) =>
          selectedVoucher.promotionCategoryId == voucher.promotionCategoryId &&
          selectedVoucher.id != voucher.id);
    }

    // Sử dụng useEffect để thêm và loại bỏ listener khi widget được mount và unmount
    useEffect(() {
      void handleTextChanged() {
        isApplyButtonEnabled.value = controller.text.length >= 4;
      }

      controller.addListener(handleTextChanged);
      // Cleanup: loại bỏ listener khi widget bị dispose
      return () => controller.removeListener(handleTextChanged);
    }, [controller]);

    // Hàm để xóa TextField
    void clearTextField() {
      controller.clear();
    }

    // Hàm để áp dụng voucher
    void applyVoucher() {
      String voucherCode = controller.text;
      // Thêm logic áp dụng voucher ở đây
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Đã áp dụng mã voucher: $voucherCode'),
        ),
      );
    }

    print("object voucher length ${vouchers.length} ");
    final filteredVouchers = vouchers.where((v) => v.userId != null).toList();
    return DraggableScrollableSheet(
      expand: false,
      initialChildSize: 0.75,
      maxChildSize: 0.75,
      builder: (context, scrollController) {
        return Scaffold(
          appBar: AppBar(
            automaticallyImplyLeading: false,
            centerTitle: true,
            title: const LabelText(
              content: 'Phiếu giảm giá',
              size: AssetsConstants.labelFontSize * 1.4,
              fontWeight: FontWeight.w600,
            ),
            bottom: PreferredSize(
              preferredSize: const Size.fromHeight(60.0),
              child: Container(
                margin:
                    const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                child: Row(
                  children: [
                    // Expanded TextField để chiếm hết không gian còn lại
                    Expanded(
                      child: TextField(
                        controller: controller,
                        decoration: InputDecoration(
                          hintText: 'Nhập mã MoveMate voucher',
                          prefixIcon: const Icon(Icons.percent),
                          suffixIcon: controller.text.isNotEmpty
                              ? IconButton(
                                  icon: const Icon(Icons.clear),
                                  onPressed: clearTextField,
                                )
                              : null,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(24.0),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 8.0),
                    // Nút "Áp dụng"
                    ElevatedButton(
                      onPressed:
                          isApplyButtonEnabled.value ? applyVoucher : null,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: !isApplyButtonEnabled.value
                            ? Colors.grey.shade500
                            : Colors.orange,
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16.0,
                          vertical: 0.0,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(24.0),
                        ),
                        minimumSize:
                            const Size(0, 48), // Chiều cao bằng TextField
                      ),
                      child: Text(
                        'Áp dụng',
                        style: TextStyle(
                          color: !isApplyButtonEnabled.value
                              ? Colors.grey.shade400
                              : Colors.white,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          body: SingleChildScrollView(
            controller: scrollController,
            child: Container(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                // Sử dụng filteredVouchers thay vì vouchers
                children: List.generate(filteredVouchers.length, (index) {
                  final currentVoucher = filteredVouchers[index];
                  final isSelected = localSelectedVouchers.value
                      .any((v) => v.id == currentVoucher.id);
                  final isDisabled = !isSelected &&
                      hasExistingVoucherWithSamePromotion(currentVoucher);

                  return Card(
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
                                      'Phiếu giảm giá ${filteredVouchers[index].code}',
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
                                      Text(
                                        'Giảm đến ${formatPrice(filteredVouchers[index].price.toInt())}',
                                        style: const TextStyle(
                                          color: Colors.grey,
                                          fontSize: 14.0,
                                        ),
                                      ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 16.0),
                          Row(
                            children: [
                              const Spacer(),
                              ElevatedButton(
                                onPressed: isDisabled
                                    ? null // Disable button nếu có voucher cùng promotion đã được chọn
                                    : () {
                                        if (!isSelected) {
                                          // Thêm voucher mới
                                          localSelectedVouchers.value = [
                                            ...localSelectedVouchers.value,
                                            currentVoucher
                                          ];
                                          onVoucherUsed(currentVoucher);

                                          ScaffoldMessenger.of(context)
                                              .showSnackBar(
                                            SnackBar(
                                              backgroundColor:
                                                  Colors.orange.shade700,
                                              content: Text(
                                                'Đã sử dụng phiếu giảm giá ${index + 1}',
                                                style: const TextStyle(
                                                    color: Colors.white,
                                                    fontSize: 18,
                                                    fontWeight:
                                                        FontWeight.bold),
                                              ),
                                            ),
                                          );
                                        } else {
                                          // Hủy voucher
                                          localSelectedVouchers.value =
                                              localSelectedVouchers.value
                                                  .where((v) =>
                                                      v.id != currentVoucher.id)
                                                  .toList();
                                          onVoucherCanceled(currentVoucher);

                                          ScaffoldMessenger.of(context)
                                              .showSnackBar(
                                            SnackBar(
                                              backgroundColor:
                                                  Colors.red.shade700,
                                              content: Text(
                                                'Đã hủy phiếu giảm giá ${index + 1}',
                                                style: const TextStyle(
                                                    color: Colors.white,
                                                    fontSize: 18,
                                                    fontWeight:
                                                        FontWeight.bold),
                                              ),
                                            ),
                                          );
                                        }
                                      },
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: isSelected
                                      ? Colors.red
                                      : (isDisabled
                                          ? Colors.grey
                                          : Colors.orange),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(20.0),
                                  ),
                                ),
                                child: Text(
                                  isSelected
                                      ? 'Hủy'
                                      : (isDisabled
                                          ? 'Không khả dụng'
                                          : 'Sử dụng'),
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
                  );
                }),
              ),
            ),
          ),
        );
      },
    );
  }
}

// Hàm hỗ trợ để định dạng giá
String formatPrice(int price) {
  final formatter = NumberFormat('#,###', 'vi_VN');
  return '${formatter.format(price)} đ';
}
