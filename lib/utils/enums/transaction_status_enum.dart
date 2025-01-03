import 'dart:ui';

import 'package:flutter/material.dart';
// RECHARGE,
//         DEPOSIT,
//         PAYMENT,
//         RECEIVE,
//         TRANFER,
//         WITHDRAW
enum TransactionStatus {
  RECHARGE("Nạp tiền"),
  DEPOSIT("Đặt cọc"),
  PAYMENT("Thanh toán"),
  RECEIVE("Nhận tiền"),
  TRANFER("Chuyển tiền"),
  WITHDRAW("Rút tiền");

  final String vietnameseName;

  const TransactionStatus(this.vietnameseName);

  /// Phương thức trả về tên tiếng Việt tương ứng với status
  String toVietnamese() => vietnameseName;

  /// Phương thức từ chuỗi để lấy enum tương ứng
  static TransactionStatus? fromString(String value) {
    return TransactionStatus.values.firstWhere(
      (e) => e.name.toUpperCase() == value.toUpperCase(),
    );
  }
}

extension TransactionStatusExtension on TransactionStatus {
  String toVietnamese() {
    switch (this) {
      case TransactionStatus.RECHARGE:
        return "Nạp tiền";
      case TransactionStatus.DEPOSIT:
        return "Gửi tiền";
      case TransactionStatus.PAYMENT:
        return "Thanh toán";
      case TransactionStatus.RECEIVE:
        return "Nhận tiền";
      case TransactionStatus.TRANFER:
        return "Chuyển tiền";
      case TransactionStatus.WITHDRAW:
        return "Rút tiền";
    }
  }

  static TransactionStatus? fromString(String value) {
    switch (value.toUpperCase()) {
      case "RECHARGE":
        return TransactionStatus.RECHARGE;
      case "DEPOSIT":
        return TransactionStatus.DEPOSIT;
      case "PAYMENT":
        return TransactionStatus.PAYMENT;
      case "RECEIVE":
        return TransactionStatus.RECEIVE;
      case "TRANFER":
        return TransactionStatus.TRANFER;
      case "WITHDRAW":
        return TransactionStatus.WITHDRAW;
      default:
        return null;
    }
  }
}

IconData getIconForTransactionType(String type) {
  switch (type) {
    case 'DEPOSIT':
      return Icons.arrow_downward_rounded;
    case 'RECEIVE':
      return Icons.arrow_circle_right_rounded;
    case 'TRANFER':
      return Icons.swap_horiz_rounded;
    case 'RECHARGE':
      return Icons.credit_card_rounded;
    case 'PAYMENT':
      return Icons.account_balance_wallet_rounded;
    case 'WITHDRAW':
      return Icons.account_balance_wallet_rounded;
    default:
      return Icons.help_outline;
  }
}

Color getCardColor(String type) {
  switch (type) {
    case 'DEPOSIT':
      return Colors.red.shade50.withOpacity(0.7);
    case 'RECHARGE':
      return Colors.green.shade50.withOpacity(0.7);
    default:
      return Colors.orange.shade50.withOpacity(0.7);
  }
}

Color getCardColorWallet(String type) {
  switch (type) {
    case 'DEPOSIT':
      return Colors.red.shade500.withOpacity(0.7);
    case 'RECEIVE':
      return Colors.green.shade500.withOpacity(0.7);
    case 'TRANFER':
      return Colors.orange.shade300.withOpacity(0.7);
    case 'RECHARGE':
      return Colors.green.shade300.withOpacity(0.7);
    case 'PAYMENT':
      return Colors.orange.withOpacity(0.7);
    case 'WITHDRAW':
      return Colors.orange.withOpacity(0.5);
    default:
      return Colors.orange.shade50.withOpacity(0.7);
  }
}

String defineAmountPrefix(String type) {
  switch (type) {
    case 'DEPOSIT':
      return '- ';
    case 'RECEIVE':
      return '+ ';
    case 'TRANFER':
      return '- ';
    case 'RECHARGE':
      return '+ ';
    case 'PAYMENT':
      return '- ';
    case 'WITHDRAW':
      return '- ';
    default:
      return '- ';
  }
}

String defineTransactionInCome(String type) {
  switch (type) {
    case 'DEPOSIT':
      return '';
    case 'RECEIVE':
      return '';
    case 'TRANFER':
      return ' ';
    case 'RECHARGE':
      return ' ';
    case 'PAYMENT':
      return ' ';
    case 'WITHDRAW':
      return ' ';
    default:
      return ' ';
  }
}

Color getAmountColor(String type) {
  switch (type) {
    case 'DEPOSIT':
      return Colors.red.shade700;
    case 'RECHARGE':
      return Colors.green.shade700;
    default:
      return Colors.orange.shade700;
  }
}

TextStyle getTextStyleForTitle(String type) {
  const baseStyle = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.bold,
  );

  switch (type) {
    case 'DEPOSIT':
      return baseStyle.copyWith(color: Colors.red.shade700);
    case 'RECHARGE':
      return baseStyle.copyWith(color: Colors.green.shade700);
    default:
      return baseStyle.copyWith(color: Colors.orange.shade700);
  }
}

TextStyle getTextStyleForDescription(String type) {
  const baseStyle = TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.w500,
  );

  switch (type) {
    case 'DEPOSIT':
      return baseStyle.copyWith(color: Colors.red.shade600);
    case 'RECHARGE':
      return baseStyle.copyWith(color: Colors.green.shade600);
    default:
      return baseStyle.copyWith(color: Colors.orange.shade600);
  }
}
