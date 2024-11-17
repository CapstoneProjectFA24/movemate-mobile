import 'package:intl/intl.dart';

class PriceHelper {
  static String formatPrice(int price) {
    final formatter = NumberFormat('#,###', 'vi_VN');
    return '${formatter.format(price)} đ';
  }
}
