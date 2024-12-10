import 'package:intl/intl.dart';

class PriceHelper {
  static String formatPrice(double price) {
    final formatter = NumberFormat('#,###', 'vi_VN');
    return '${formatter.format(price)} đ';
  }
}
