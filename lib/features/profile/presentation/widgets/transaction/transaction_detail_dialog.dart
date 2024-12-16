import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:movemate/features/booking/presentation/widgets/booking_screen_2th/booking_package/sub_service_tile.dart';
import 'package:movemate/features/profile/domain/entities/transaction_entity.dart';
import 'package:movemate/utils/commons/widgets/format_price.dart';
import 'package:movemate/utils/enums/payment_method_type.dart';
import 'package:movemate/utils/enums/transaction_status_enum.dart';

class TransactionDetailDialog extends StatelessWidget {
  final TransactionEntity transaction;

  const TransactionDetailDialog({super.key, required this.transaction});

  @override
  Widget build(BuildContext context) {
    // Function to format date and time
    final formattedDateReviewAt = DateFormat('dd-MM-yyyy')
        .format(DateTime.parse(transaction.createdAt.toString()));
    final formattedTimeReviewAt = DateFormat('HH:mm')
        .format(DateTime.parse(transaction.createdAt.toString()));
    final name = transaction.transactionType;
    // Chuyển đổi trạng thái sang enum
    final transactionStatus = TransactionStatus.fromString(name);

    // Lấy tên tiếng Việt
    final statusVietnamese =
        transactionStatus?.toVietnamese() ?? 'Không xác định';
    String status = '';
    PaymentMethodType? methodType =
        PaymentMethodType.fromString(transaction.paymentMethod);

    String paymentMethodName = methodType?.displayName ??
        'Unknown'; // Fallback to 'Unknown' if not found

    if (transaction.status.toString() == 'SUCCESS') {
      status = 'Thanh toán thành công';
    } else {
      status = 'Thanh toán thất bại'; // Bạn có thể thêm trường hợp khác nếu cần
    }
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16.0),
      ),
      backgroundColor: Colors.white,
      child: ConstrainedBox(
        constraints: BoxConstraints(
          // Adjust the max height as needed
          maxHeight: MediaQuery.of(context).size.height * 0.85,
        ),
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            // Removed mainAxisSize.min to allow flexibility with scrolling
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Row(
                children: [
                  Icon(Icons.receipt, color: Colors.deepOrange, size: 28),
                  SizedBox(width: 12),
                  Text(
                    'Chi tiết giao dịch',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.deepOrange,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              _buildDetailRow('Mã giao dịch', transaction.transactionCode),
              _buildDetailRow('Loại giao dịch', statusVietnamese),
              _buildDetailRow(
                  'Số tiền', formatPrice(transaction.amount.toDouble())),
              _buildDetailRow('Trạng thái', status ?? ''),
              _buildDetailRow('Phương thức thanh toán', paymentMethodName),
              _buildDetailRow('Ngày giao dịch', formattedDateReviewAt ?? ''),
              // Add more detail rows if necessary
              const SizedBox(height: 24),
              Align(
                alignment: Alignment.centerRight,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.deepOrange,
                    iconColor: Colors.white,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 24,
                      vertical: 12,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(24.0),
                    ),
                  ),
                  child: const Text(
                    'Đóng',
                    style: TextStyle(fontSize: 18, color: Colors.white),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            flex: 2,
            child: Text(
              label,
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
                color: Colors.grey,
              ),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            flex: 3,
            child: Text(
              value,
              style: const TextStyle(fontSize: 14, color: Colors.black87),
              maxLines: 3,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }
}
