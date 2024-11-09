import 'dart:convert';

import 'package:movemate/features/booking/domain/entities/booking_enities.dart';
import 'package:movemate/features/booking/domain/entities/booking_request/resource.dart';
import 'package:movemate/features/booking/domain/entities/booking_request/service_detail.dart';
import 'package:movemate/features/booking/domain/entities/image_data.dart';
import 'package:movemate/features/booking/presentation/widgets/booking_screen_1st/image_button/video_data.dart';

class BookingValuationRequest {
  final String pickupAddress;
  final String pickupPoint;
  final String deliveryAddress;
  final String deliveryPoint;
  final String estimatedDistance;
  final int houseTypeId;
  final bool isReviewOnline;
  final bool isRoundTrip;
  final String roomNumber;
  final String floorsNumber;
  final List<ServiceDetail> serviceDetails;
  final int truckCategoryId;
  final String bookingAt;
  // final String estimatedDeliveryTime;
  BookingValuationRequest({
    required this.pickupAddress,
    required this.pickupPoint,
    required this.deliveryAddress,
    required this.deliveryPoint,
    required this.estimatedDistance,
    required this.houseTypeId,
    required this.isReviewOnline,

    // required this.estimatedDeliveryTime,
    required this.isRoundTrip,
    required this.roomNumber,
    required this.floorsNumber,
    required this.serviceDetails,
    required this.truckCategoryId,
    required this.bookingAt,
  });

  Map<String, dynamic> toMap() {
    return {
      'pickupAddress': pickupAddress,
      'pickupPoint': pickupPoint,
      'deliveryAddress': deliveryAddress,
      'deliveryPoint': deliveryPoint,
      'estimatedDistance': estimatedDistance,
      'houseTypeId': houseTypeId,

      // 'estimatedDeliveryTime': estimatedDeliveryTime,
      'isRoundTrip': isRoundTrip,
      'isReviewOnline': isReviewOnline,

      'roomNumber': roomNumber,
      'floorsNumber': floorsNumber,
      'bookingDetails': serviceDetails.map((x) => x.toMap()).toList(),
      'truckCategoryId': truckCategoryId,
      'bookingAt': bookingAt,
    };
  }

  factory BookingValuationRequest.fromMap(Map<String, dynamic> map) {
    return BookingValuationRequest(
      pickupAddress: map['pickupAddress'] ?? '',
      pickupPoint: map['pickupPoint'] ?? '',
      deliveryAddress: map['deliveryAddress'] ?? '',
      deliveryPoint: map['deliveryPoint'] ?? '',
      estimatedDistance: map['estimatedDistance'] ?? '0',
      houseTypeId: map['houseTypeId'] ?? 1,
      // estimatedDeliveryTime: map['estimatedDeliveryTime'] ?? '0',
      isRoundTrip: map['isRoundTrip'] ?? false,
      isReviewOnline: map['isReviewOnline'] ?? false,
      roomNumber: map['roomNumber'] ?? '0',
      floorsNumber: map['floorsNumber'] ?? '0',
      serviceDetails: map['bookingDetails'] != null
          ? List<ServiceDetail>.from(
              map['bookingDetails']?.map((x) => ServiceDetail.fromMap(x)))
          : [],
      truckCategoryId: map['truckCategoryId'] ?? 1,
      bookingAt: map['bookingAt'] ?? '',
    );
  }

  String toJson() => json.encode(toMap());

  factory BookingValuationRequest.fromJson(String source) =>
      BookingValuationRequest.fromMap(json.decode(source));

  // Phương thức xử lý để tạo BookingValuationRequest từ một đối tượng Booking
  factory BookingValuationRequest.fromBooking(Booking booking) {
    // Khởi tạo danh sách serviceDetails
    List<ServiceDetail> serviceDetails = [];
    List<ServiceDetail> selectedVehicle = [];
    // Thêm selectedSubServices vào serviceDetails

    serviceDetails.addAll(booking.selectedSubServices.map((subService) {
      return ServiceDetail(
        serviceId: subService.id,
        // isQuantity: subService.isQuantity, // Sử dụng subService.isQuantity
        quantity: subService.quantity ?? 1,
      );
    }).toList());

    // Filter servicesFeeList to include only fees with quantity > 0
    List<ServiceDetail> feeServiceDetails = booking.servicesFeeList
        .where((serviceFee) =>
            serviceFee.quantity != null && serviceFee.quantity! > 0)
        .map((serviceFee) {
      return ServiceDetail(
        serviceId: serviceFee.id,
        // isQuantity: true,
        quantity: serviceFee.quantity!,
      );
    }).toList();

    // Add filtered fees to serviceDetails
    serviceDetails.addAll(feeServiceDetails);

    if (booking.selectedVehicle != null) {
      selectedVehicle.add(
        ServiceDetail(
          serviceId: booking.selectedVehicle!.id,
          quantity: 1, // Giá trị mặc định là 1
        ),
      );
    }
    serviceDetails.addAll(selectedVehicle);

    // Add selectedPackages with quantities to serviceDetails
    serviceDetails.addAll(booking.selectedPackages
        .where((package) => package.quantity != null && package.quantity! > 0)
        .map((package) {
      return ServiceDetail(
        serviceId: package.id,
        // isQuantity:
        //     true, // Assuming that packages with quantities are isQuantity == true
        quantity: package.quantity!,
      );
    }).toList());

    // Tính toán khoảng cách ước tính (ví dụ)
    String estimatedDistance =
        booking.estimatedDistance ?? '10'; // Có thể tính toán dựa trên tọa độ

    // Tính toán thời gian giao hàng ước tính (ví dụ)
    // String estimatedDeliveryTime =
    //     '3'; // Có thể tính toán hoặc đặt giá trị phù hợp

    // Chuyển đổi thời gian đặt chỗ sang định dạng ISO8601
    String bookingAt = booking.bookingDate?.toIso8601String() ??
        DateTime.now().toIso8601String();

    return BookingValuationRequest(
      pickupAddress: booking.pickUpLocation?.address ?? 'string',
      pickupPoint: booking.pickUpLocation != null
          ? '${booking.pickUpLocation!.latitude},${booking.pickUpLocation!.longitude}'
          : '',
      deliveryAddress: booking.dropOffLocation?.address ?? 'string',
      deliveryPoint: booking.dropOffLocation != null
          ? '${booking.dropOffLocation!.latitude},${booking.dropOffLocation!.longitude}'
          : '',
      estimatedDistance: estimatedDistance,
      houseTypeId: booking.houseType?.id ?? 1,
      // estimatedDeliveryTime: estimatedDeliveryTime,
      isRoundTrip: booking.isRoundTrip,
      isReviewOnline: booking.isReviewOnline,
      roomNumber: (booking.numberOfRooms ?? 1).toString(),
      floorsNumber: (booking.numberOfFloors ?? 1).toString(),
      serviceDetails: serviceDetails,
      truckCategoryId: booking.selectedVehicle?.truckCategory?.id ?? 1,
      bookingAt: bookingAt,
    );
  }
}
