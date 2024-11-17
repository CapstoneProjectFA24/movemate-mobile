import 'dart:convert';

import 'package:movemate/features/booking/domain/entities/booking_enities.dart';
import 'package:movemate/features/booking/domain/entities/booking_request/service_detail.dart';

class ValuationPriceOneOfSystemServiceRequest {
  final String pickupAddress;
  final String pickupPoint;
  final String deliveryAddress;
  final String deliveryPoint;
  final String estimatedDistance;
  final int houseTypeId;
  final bool isReviewOnline;

  final String roomNumber;
  final String floorsNumber;
  final List<ServiceDetail> serviceDetails;
  final int truckCategoryId;
  final String bookingAt;
  // final String estimatedDeliveryTime;
  ValuationPriceOneOfSystemServiceRequest({
    required this.pickupAddress,
    required this.pickupPoint,
    required this.deliveryAddress,
    required this.deliveryPoint,
    required this.estimatedDistance,
    required this.houseTypeId,
    required this.isReviewOnline,

    // required this.estimatedDeliveryTime,
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
      'isReviewOnline': isReviewOnline,

      'roomNumber': roomNumber,
      'floorsNumber': floorsNumber,
      'bookingDetails': serviceDetails.map((x) => x.toMap()).toList(),
      'truckCategoryId': truckCategoryId,
      'bookingAt': bookingAt,
    };
  }

  factory ValuationPriceOneOfSystemServiceRequest.fromMap(Map<String, dynamic> map) {
    return ValuationPriceOneOfSystemServiceRequest(
      pickupAddress: map['pickupAddress'] ?? '',
      pickupPoint: map['pickupPoint'] ?? '',
      deliveryAddress: map['deliveryAddress'] ?? '',
      deliveryPoint: map['deliveryPoint'] ?? '',
      estimatedDistance: map['estimatedDistance'] ?? '0',
      houseTypeId: map['houseTypeId'] ?? 1,
      // estimatedDeliveryTime: map['estimatedDeliveryTime'] ?? '0',
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

  factory ValuationPriceOneOfSystemServiceRequest.fromJson(String source) =>
      ValuationPriceOneOfSystemServiceRequest.fromMap(json.decode(source));

  // Phương thức xử lý để tạo ValuationPriceOneOfSystemServiceRequest từ một đối tượng Booking
  factory ValuationPriceOneOfSystemServiceRequest.fromBooking(Booking booking) {
    // Khởi tạo danh sách serviceDetails
    List<ServiceDetail> serviceDetails = [
      ServiceDetail(
        serviceId: 2,
        quantity: 1,
      ),
      ServiceDetail(
        serviceId: 3,
        quantity: 1,
      ),
    ];
    List<ServiceDetail> selectedVehicle = [];
    // Thêm selectedSubServices vào serviceDetails

    // serviceDetails.addAll(booking.selectedSubServices.map((subService) {
    //   return ServiceDetail(
    //     serviceId: subService.id,
    //     quantity: subService.quantity ?? 1,
    //   );
    // }).toList());

    if (booking.selectedVehicle != null) {
      selectedVehicle.add(
        ServiceDetail(
          serviceId: booking.selectedVehicle!.id,
          quantity: 1, // Giá trị mặc định là 1
        ),
      );
    }
    serviceDetails.addAll(selectedVehicle);

    // Tính toán khoảng cách ước tính (ví dụ)
    String estimatedDistance =
        booking.estimatedDistance ?? '10'; // Có thể tính toán dựa trên tọa độ

    // Chuyển đổi thời gian đặt chỗ sang định dạng ISO8601
    String bookingAt = booking.bookingDate?.toIso8601String() ??
        DateTime.now().toIso8601String();

    return ValuationPriceOneOfSystemServiceRequest(
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
      isReviewOnline: booking.isReviewOnline,
      roomNumber: (booking.numberOfRooms ?? 1).toString(),
      floorsNumber: (booking.numberOfFloors ?? 1).toString(),
      serviceDetails: serviceDetails,
      truckCategoryId: booking.selectedVehicle?.truckCategory?.id ?? 1,
      bookingAt: bookingAt,
    );
  }
}
