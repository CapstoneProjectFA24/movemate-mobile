import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:movemate/features/profile/domain/entities/transaction_entity.dart';
import 'package:movemate/features/profile/presentation/widgets/transaction/transaction_detail_dialog.dart';
import 'package:movemate/utils/enums/payment_method_type.dart';
import 'package:movemate/utils/enums/transaction_status_enum.dart';

class TransactionItem extends StatelessWidget {
  final IconData icon;
  final String name;
  final String description;
  final double amount;
  final String date;
  final String paymentMethod;
  final String imageUrl;
  final Color cardColor;
  final Color amountColor;
  final TextStyle titleStyle;
  final TextStyle descriptionStyle;
  final TransactionEntity transaction;
  const TransactionItem({
    super.key,
    required this.icon,
    required this.name,
    required this.description,
    required this.amount,
    required this.date,
    required this.paymentMethod,
    required this.imageUrl,
    required this.cardColor,
    required this.amountColor,
    required this.titleStyle,
    required this.descriptionStyle,
    required this.transaction,
  });

  @override
  Widget build(BuildContext context) {
    // hàm để định dạng ngày tháng
    final formattedDateReviewAt =
        DateFormat('dd-MM-yyyy').format(DateTime.parse(date.toString()));
    final formattedTimeReviewAt =
        DateFormat('HH:mm').format(DateTime.parse(date.toString()));

    // Attempt to match the payment method string to the PaymentMethodType enum
    PaymentMethodType? methodType = PaymentMethodType.fromString(paymentMethod);

    // Chuyển đổi trạng thái sang enum
    final transactionStatus = TransactionStatus.fromString(name);

    // Lấy tên tiếng Việt
    final statusVietnamese =
        transactionStatus?.toVietnamese() ?? 'Không xác định';

    // If methodType is not null, get the image and display name from the enum extension
    String paymentMethodImage =
        methodType?.imageUrl ?? ''; // Fallback to empty string if not found
    String paymentMethodName = methodType?.displayName ??
        'Unknown'; // Fallback to 'Unknown' if not found
    final status = TransactionStatus.DEPOSIT.toVietnamese();

    String amountPrefix = '';
    if (transactionStatus == TransactionStatus.DEPOSIT ||
        transactionStatus == TransactionStatus.PAYMENT ||
        transactionStatus == TransactionStatus.TRANFER) {
      amountPrefix = '- ';
    } else if (transactionStatus == TransactionStatus.RECHARGE ||
        transactionStatus == TransactionStatus.RECEIVE) {
      amountPrefix = '+ ';
    }

    print("object $status ");
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Container(
        decoration: BoxDecoration(
          color: cardColor,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.1),
              spreadRadius: 1,
              blurRadius: 10,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(16),
          child: Material(
            color: Colors.transparent,
            child: InkWell(
              onTap: () {
                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return TransactionDetailDialog(transaction: transaction);
                  },
                );
              },
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Row(
                  children: [
                    // Left side - Transaction Icon with gradient background
                    Container(
                      width: 56,
                      height: 56,
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                          colors: [
                            amountColor.withOpacity(0.1),
                            amountColor.withOpacity(0.2),
                          ],
                        ),
                        borderRadius: BorderRadius.circular(14),
                      ),
                      child: Icon(
                        icon,
                        color: amountColor,
                        size: 24,
                      ),
                    ),
                    const SizedBox(width: 16),

                    // Middle - Transaction Details
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Expanded(
                                child: Text(
                                  statusVietnamese,
                                  style: titleStyle.copyWith(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w700,
                                  ),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                              const SizedBox(width: 8),
                              Text(
                                "$amountPrefix${formatPrice(amount.toInt())}",
                                style: TextStyle(
                                  color: amountColor,
                                  fontWeight: FontWeight.w700,
                                  fontSize: 16,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 6),
                          Text(
                            description,
                            style: descriptionStyle.copyWith(
                              fontSize: 14,
                              color: Colors.grey[600],
                            ),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                          const SizedBox(height: 8),
                          // Payment Method and Date Row
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              // Payment Method with Icon
                              Expanded(
                                child: Row(
                                  children: [
                                    if (paymentMethodImage.isNotEmpty) ...[
                                      ClipRRect(
                                        borderRadius: BorderRadius.circular(6),
                                        child: CachedNetworkImage(
                                          imageUrl: paymentMethodImage,
                                          width: 24,
                                          height: 24,
                                          fit: BoxFit.cover,
                                          placeholder: (context, url) =>
                                              Container(
                                            color: Colors.grey[200],
                                            child: const Icon(
                                              Icons.payment,
                                              size: 16,
                                              color: Colors.grey,
                                            ),
                                          ),
                                          errorWidget: (context, url, error) =>
                                              Container(
                                            color: Colors.grey[200],
                                            child: const Icon(
                                              Icons.error_outline,
                                              size: 16,
                                              color: Colors.grey,
                                            ),
                                          ),
                                        ),
                                      ),
                                      const SizedBox(width: 8),
                                    ],
                                    Expanded(
                                      child: Text(
                                        paymentMethod,
                                        style: TextStyle(
                                          color: Colors.grey[700],
                                          fontSize: 13,
                                          fontWeight: FontWeight.w500,
                                        ),
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              // Date
                              Text(
                                formattedDateReviewAt,
                                style: TextStyle(
                                  color: Colors.grey[600],
                                  fontSize: 12,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

// Utility functions remain the same
String formatPrice(int price) {
  final formatter = NumberFormat('#,###', 'vi_VN');
  return '${formatter.format(price)} đ';
}
