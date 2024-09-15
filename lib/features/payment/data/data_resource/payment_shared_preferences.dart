import 'package:shared_preferences/shared_preferences.dart';

class PaymentSharedPreferences {
  // Khóa lưu trữ cho các giá trị thanh toán
  static const String _paymentAmountKey = "payment_amount";
  static const String _paymentMethodKey = "payment_method";
  static const String _couponCodeKey = "coupon_code";

  // Lưu thông tin giá trị thanh toán
  static Future<void> setPaymentAmount(double? amount) async {
    final prefs = await SharedPreferences.getInstance();
    if (amount == null) {
      await prefs.remove(_paymentAmountKey);
    } else {
      await prefs.setDouble(_paymentAmountKey, amount);
    }
  }

  // Truy xuất giá trị thanh toán
  static Future<double> getPaymentAmount() async {
    final prefs = await SharedPreferences.getInstance();
    // Trả về giá trị mặc định 1 nếu không có giá trị được lưu trữ
    return prefs.getDouble(_paymentAmountKey) ?? 1.0;
  }

  // Lưu phương thức thanh toán
  static Future<void> setPaymentMethod(String? method) async {
    final prefs = await SharedPreferences.getInstance();
    if (method == null) {
      await prefs.remove(_paymentMethodKey);
    } else {
      await prefs.setString(_paymentMethodKey, method);
    }
  }

  // Truy xuất phương thức thanh toán
  static Future<String> getPaymentMethod() async {
    final prefs = await SharedPreferences.getInstance();
    // Trả về giá trị mặc định "MoMo" nếu không có giá trị được lưu trữ
    return prefs.getString(_paymentMethodKey) ?? "MoMo";
  }

  // Lưu mã giảm giá (coupon code)
  static Future<void> setCouponCode(String? coupon) async {
    final prefs = await SharedPreferences.getInstance();
    if (coupon == null) {
      await prefs.remove(_couponCodeKey);
    } else {
      await prefs.setString(_couponCodeKey, coupon);
    }
  }

  // Truy xuất mã giảm giá
  static Future<String> getCouponCode() async {
    final prefs = await SharedPreferences.getInstance();
    // Trả về giá trị mặc định rỗng nếu không có giá trị được lưu trữ
    return prefs.getString(_couponCodeKey) ?? "";
  }

  // Xóa tất cả thông tin thanh toán
  static Future<void> clearAllPaymentData() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_paymentAmountKey);
    await prefs.remove(_paymentMethodKey);
    await prefs.remove(_couponCodeKey);
  }
}
