// Hàm hỗ trợ để định dạng giá
import 'package:intl/intl.dart';

String formatPrice(double price) {
  final formatter = NumberFormat('#,###', 'vi_VN');
  return '${formatter.format(price)} đ';
}

class PriceHelper {
  static String formatPrice(double price) {
    final formatter = NumberFormat('#,###', 'vi_VN');
    return '${formatter.format(price)} đ';
  }
}
