import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:movemate/features/profile/presentation/screens/transaction_screen/list_transaction_screen.dart';
import 'package:movemate/utils/enums/payment_method_type.dart';

import '../../../../order/presentation/widgets/main_detail_ui/customer_info.dart';

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
  });

  @override
  Widget build(BuildContext context) {
    // Attempt to match the payment method string to the PaymentMethodType enum
    PaymentMethodType? methodType = PaymentMethodType.fromString(paymentMethod);

    // If methodType is not null, get the image and display name from the enum extension
    String paymentMethodImage =
        methodType?.imageUrl ?? ''; // Fallback to empty string if not found
    String paymentMethodName = methodType?.displayName ??
        'Unknown'; // Fallback to 'Unknown' if not found

    return Card(
      color: cardColor,
      margin: const EdgeInsets.only(bottom: 10),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: Colors.blue.shade50,
          child: Icon(icon, color: Colors.blue.shade700),
        ),
        title: Text(name, style: titleStyle),
        subtitle: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(description, style: descriptionStyle),
              const SizedBox(height: 4),
              Row(
                children: [
                  const Text('Payment Method: ',
                      style: TextStyle(fontWeight: FontWeight.bold)),
                  Expanded(
                    child: Text(paymentMethodName,
                        overflow: TextOverflow.ellipsis),
                  ),
                ],
              ),
            ],
          ),
        ),
        trailing: Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Text(
              formatPrice(amount.toInt()),
              style: TextStyle(
                color: amountColor,
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
            // if (paymentMethodImage.isNotEmpty)
            //   Padding(
            //     padding: const EdgeInsets.only(top: 8.0),
            //     child: Flexible(
            //       child:
            //           Image.network(paymentMethodImage, width: 35, height: 35),
            //     ),
            //   ),
          ],
        ),
        isThreeLine: true,
        dense: true,
      ),
    );
  }
}

// Hàm hỗ trợ để định dạng giá
String formatPrice(int price) {
  final formatter = NumberFormat('#,###', 'vi_VN');
  return '${formatter.format(price)} đ';
}

// Icon mapping based on transaction type
IconData getIconForTransactionType(String type) {
  switch (type) {
    case 'DEPOSIT':
      return Icons.arrow_downward; // Deposit icon
    case 'RECEIVE':
      return Icons.arrow_forward; // Receive icon
    case 'TRANSFER':
      return Icons.swap_horiz; // Transfer icon
    case 'RECHARGE':
      return Icons.credit_card; // Recharge icon
    case 'PAYMENT':
      return Icons.payment; // Payment icon
    default:
      return Icons.help_outline; // Default icon if type is unknown
  }
}

// Function to get card color and amount color based on transaction type
Color getCardColor(String type) {
  switch (type) {
    case 'DEPOSIT':
      return Colors.red.shade50; // Red card for Deposit
    case 'RECHARGE':
      return Colors.green.shade50; // Green card for Recharge
    default:
      return Colors.orange.shade50; // Light orange card for others
  }
}

Color getAmountColor(String type) {
  switch (type) {
    case 'DEPOSIT':
      return Colors.red; // Red for Deposit
    case 'RECHARGE':
      return Colors.green; // Green for Recharge
    default:
      return Colors.orange.shade700; // Orange for others
  }
}

TextStyle getTextStyleForTitle(String type) {
  switch (type) {
    case 'DEPOSIT':
      return const TextStyle(
          color: Colors.red,
          fontWeight: FontWeight.bold); // Bold Red for Deposit
    case 'RECHARGE':
      return const TextStyle(
          color: Colors.green,
          fontWeight: FontWeight.bold); // Bold Green for Recharge
    default:
      return TextStyle(
          color: Colors.orange.shade700,
          fontWeight: FontWeight.w600); // Orange for others
  }
}

TextStyle getTextStyleForDescription(String type) {
  switch (type) {
    case 'DEPOSIT':
      return TextStyle(
          color: Colors.red.shade700,
          fontWeight: FontWeight.w600); // Darker Red for Deposit
    case 'RECHARGE':
      return TextStyle(
          color: Colors.green.shade700,
          fontWeight: FontWeight.w600); // Darker Green for Recharge
    default:
      return TextStyle(
          color: Colors.orange.shade500,
          fontWeight: FontWeight.w600); // Orange for others
  }
}
