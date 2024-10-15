import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:movemate/features/booking/data/models/resquest/services_detail_request.dart';
import 'package:movemate/features/booking/domain/entities/vinh/booking_entity.dart';
import 'package:movemate/features/booking/domain/entities/vinh/house_type_entity.dart';
import 'package:movemate/features/booking/domain/entities/vinh/service_entity.dart';

class BookingNotifier extends StateNotifier<BookingEntity> {
  BookingNotifier() : super(initialState);

  static final initialState = BookingEntity(
    pickupAddress: '',
    pickupPoint: '',
    deliveryAddress: '',
    deliveryPoint: '',
    estimatedDistance: '',
    houseTypeId: 0,
    note: '',
    estimatedDeliveryTime: '',
    isRoundTrip: false,
    isManyItems: false,
    roomNumber: '',
    floorsNumber: '',
    truckCategoryId: 0,
    bookingAt: DateTime.now(),
    serviceDetails: [],
    totalPrice: 0.0,
    houseType: null,
    services: [],
  );

  /// Cập nhật các trường cơ bản của booking
  void update({
    String? pickupAddress,
    String? pickupPoint,
    String? deliveryAddress,
    String? deliveryPoint,
    String? estimatedDistance,
    int? houseTypeId,
    String? note,
    String? estimatedDeliveryTime,
    bool? isRoundTrip,
    bool? isManyItems,
    String? roomNumber,
    String? floorsNumber,
    int? truckCategoryId,
    DateTime? bookingAt,
    HouseTypeEntity? houseType,
    List<ServicesDetailRequest>? serviceDetails,
    List<ServiceEntity>? services,
  }) {
    state = state.copyWith(
      pickupAddress: pickupAddress,
      pickupPoint: pickupPoint,
      deliveryAddress: deliveryAddress,
      deliveryPoint: deliveryPoint,
      estimatedDistance: estimatedDistance,
      houseTypeId: houseTypeId,
      note: note,
      estimatedDeliveryTime: estimatedDeliveryTime,
      isRoundTrip: isRoundTrip,
      isManyItems: isManyItems,
      roomNumber: roomNumber,
      floorsNumber: floorsNumber,
      truckCategoryId: truckCategoryId,
      bookingAt: bookingAt,
      serviceDetails: serviceDetails ?? state.serviceDetails,
      services: services ?? state.services,
      houseType: houseType ?? state.houseType,
    );
  }

/// Cập nhật một dịch vụ (chọn một dịch vụ)
void addSingleService(ServiceEntity service) {
  // Nếu dịch vụ đã có trong danh sách, không làm gì cả
  if (state.services?.contains(service) == true) {
    return; // Dịch vụ đã tồn tại, không thêm
  }

  // Nếu không có trong danh sách, tạo danh sách mới với dịch vụ đã chọn
  final updatedServices = [service]; // Chỉ cho phép một dịch vụ duy nhất

  state = state.copyWith(
    services: updatedServices,
    totalPrice: calculateTotalPrice(updatedServices),
  );
}

/// Thêm hoặc xóa dịch vụ (chọn nhiều dịch vụ)
void toggleMultipleService(ServiceEntity service) {
  final currentServices = List<ServiceEntity>.from(state.services ?? []); // Kiểm tra null

  // Nếu dịch vụ đã tồn tại, xóa nó khỏi danh sách
  if (currentServices.contains(service)) {
    currentServices.remove(service);
  } else {
    // Nếu không có, thêm dịch vụ vào danh sách
    currentServices.add(service);
  }

  state = state.copyWith(
    services: currentServices,
    totalPrice: calculateTotalPrice(currentServices),
  );
}

  double calculateTotalPrice(List<ServiceEntity>? services) {
    if (services == null || services.isEmpty) return 0.0; // Trả về 0.0 nếu danh sách rỗng hoặc null

    double totalPrice = 0.0;

    for (var service in services) {
      if (service.type == 'TRUCK' && service.inverseParentService.isNotEmpty) {
        totalPrice +=
            service.inverseParentService.first.truckCategory?.price ?? 0; // Trả về 0 nếu không có giá
      } else {
        totalPrice += service.inverseParentService
            .fold(0.0, (sum, inverseService) => sum + inverseService.amount);
      }
    }

    return totalPrice; // Trả về giá trị tổng
  }
}

final bookingProvider =
    StateNotifierProvider<BookingNotifier, BookingEntity>((ref) {
  return BookingNotifier();
});

final totalPriceProvider = Provider<double>((ref) {
  return ref.watch(bookingProvider.select((state) => state.totalPrice ?? 0.0)); // Đảm bảo không trả về null
});
