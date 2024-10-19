// booking_provider.dart

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:movemate/features/booking/domain/entities/house_type_entity.dart';
import 'package:movemate/features/booking/domain/entities/image_data.dart';
import 'package:movemate/features/booking/domain/entities/service_entity.dart';
import 'package:movemate/features/booking/domain/entities/services_fee_system_entity.dart';
import 'package:movemate/features/home/domain/entities/location_model_entities.dart';
import 'package:movemate/features/booking/domain/entities/services_package_entity.dart';
import 'package:movemate/features/booking/domain/entities/sub_service_entity.dart';
import '/features/booking/domain/entities/booking_enities.dart';

class BookingNotifier extends StateNotifier<Booking> {
  BookingNotifier()
      : super(Booking(
          totalPrice: 0.0,
          additionalServiceQuantities: [],
        ));

  void updateAdditionalServiceQuantity(int serviceIndex, int newQuantity) {
    final updatedQuantities = [...state.additionalServiceQuantities];
    updatedQuantities[serviceIndex] = newQuantity;
    state = state.copyWith(additionalServiceQuantities: updatedQuantities);
    calculateAndUpdateTotalPrice();
  }

  void updateSubServiceQuantity(SubServiceEntity subService, int newQuantity) {
    // Đảm bảo newQuantity không vượt quá quantityMax
    int finalQuantity = newQuantity;
    if (subService.quantityMax != null &&
        newQuantity > subService.quantityMax!) {
      finalQuantity = subService.quantityMax!;
    }
    List<SubServiceEntity> updatedSubServices =
        List.from(state.selectedSubServices);

    final index = updatedSubServices.indexWhere((s) => s.id == subService.id);

    if (index != -1) {
      if (finalQuantity > 0) {
        // Update existing subService's quantity
        updatedSubServices[index] =
            updatedSubServices[index].copyWith(quantity: finalQuantity);
      } else {
        // Remove subService if quantity is zero
        updatedSubServices.removeAt(index);
      }
    } else {
      if (finalQuantity > 0) {
        // Add new subService with the specified quantity
        updatedSubServices.add(subService.copyWith(quantity: finalQuantity));
      }
    }

    state = state.copyWith(selectedSubServices: updatedSubServices);
  }

  /// Updates the services fee list in the booking state
  void updateServicesFeeList(List<ServicesFeeSystemEntity> servicesFeeList) {
    state = state.copyWith(servicesFeeList: servicesFeeList);
    calculateAndUpdateTotalPrice();
  }

  void updateServicesFeeQuantity(ServicesFeeSystemEntity fee, int newQuantity) {
    List<ServicesFeeSystemEntity> updatedServicesFeeList =
        List.from(state.servicesFeeList ?? []);

    final index = updatedServicesFeeList.indexWhere((f) => f.id == fee.id);

    if (index != -1) {
      if (newQuantity > 0) {
        // Update existing fee's quantity
        updatedServicesFeeList[index] =
            updatedServicesFeeList[index].copyWith(quantity: newQuantity);
      } else {
        // Remove fee if quantity is zero
        updatedServicesFeeList.removeAt(index);
      }
    } else {
      if (newQuantity > 0) {
        // Add new fee with specified quantity
        updatedServicesFeeList.add(fee.copyWith(quantity: newQuantity));
      }
    }

    state = state.copyWith(servicesFeeList: updatedServicesFeeList);

    // Recalculate total price
    calculateAndUpdateTotalPrice();
  }

// Method to update selected vehicle
  void updateSelectedVehicle(ServiceEntity vehicle) {
    state = state.copyWith(selectedVehicle: vehicle);
    calculateAndUpdateTotalPrice();
  }

  void updateServicePackageQuantity(
      ServicesPackageEntity servicePackage, int newQuantity) {
    List<ServicesPackageEntity> updatedPackages =
        List.from(state.selectedPackages);

    final index = updatedPackages.indexWhere((p) => p.id == servicePackage.id);

    if (index != -1) {
      if (newQuantity > 0) {
        // Update existing package's quantity
        updatedPackages[index] =
            updatedPackages[index].copyWith(quantity: newQuantity);
      } else {
        // Remove package if quantity is zero
        updatedPackages.removeAt(index);
      }
    } else {
      if (newQuantity > 0) {
        // Add new package with specified quantity
        updatedPackages.add(servicePackage.copyWith(quantity: newQuantity));
      }
    }

    state = state.copyWith(selectedPackages: updatedPackages);

    // Recalculate total price
    calculateAndUpdateTotalPrice();
  }

  void calculateAndUpdateTotalPrice() {
    double total = 0.0;

    // Tổng giá của các gói dịch vụ đã chọn
    for (var package in state.selectedPackages) {
      if ((package.quantity != null && package.quantity! > 0)) {
        total += package.amount * package.quantity!;
      }
    }

    // Tổng giá của các dịch vụ phụ đã chọn với số lượng
    for (var subService in state.selectedSubServices) {
      total += subService.amount * (subService.quantity ?? 1);
    }

    // Tổng giá của các dịch vụ phí hệ thống với số lượng
    for (var fee in state.servicesFeeList ?? []) {
      total += fee.amount * (fee.quantity ?? 0);
    }

    // Thêm giá của phương tiện đã chọn
    if (state.selectedVehicle != null) {
      total += state.selectedVehicle!.amount;
    }

    // Các tính toán khác (ví dụ: chuyến đi khứ hồi)
    if (state.isRoundTrip == true) {
      total *= 2;
    }

    // Tính thuế GTGT
    double vat = total * 0.08;

    // Cập nhật tổng giá bao gồm thuế GTGT
    total += vat;
    // Cập nhật tổng giá
    state = state.copyWith(totalPrice: total);
  }

  // Replaced updateRoundTrip method
  void updateRoundTrip(bool value) {
    state = state.copyWith(isRoundTrip: value);
    calculateAndUpdateTotalPrice();
  }

  void togglePackageSelection(ServicesPackageEntity package, bool isSelected) {
    List<ServicesPackageEntity> updatedPackages =
        List.from(state.selectedPackages);
    if (isSelected) {
      updatedPackages.add(package);
    } else {
      updatedPackages.removeWhere((p) => p.id == package.id);
    }
    state = state.copyWith(selectedPackages: updatedPackages);
    calculateAndUpdateTotalPrice();
  }

  void toggleSubServiceSelection(SubServiceEntity subService, bool isSelected) {
    List<SubServiceEntity> updatedSubServices =
        List.from(state.selectedSubServices);
    if (isSelected) {
      updatedSubServices.add(subService);
    } else {
      updatedSubServices.removeWhere((s) => s.id == subService.id);
    }
    state = state.copyWith(selectedSubServices: updatedSubServices);
    calculateAndUpdateTotalPrice();
  }

  bool isPackageSelected(ServicesPackageEntity package) {
    return state.selectedPackages.any((p) => p.id == package.id);
  }

  bool isSubServiceSelected(SubServiceEntity subService) {
    return state.selectedSubServices.any((s) => s.id == subService.id);
  }

  void updateHouseType(HouseTypeEntity? houseType) {
    state = state.copyWith(houseType: houseType);
  }

  void updateReviewType(String? reviewType) {
    state = state.copyWith(reviewType: reviewType);
  }

  void updateNumberOfRooms(int rooms) {
    state = state.copyWith(numberOfRooms: rooms);
  }

  void updateNumberOfFloors(int floors) {
    state = state.copyWith(numberOfFloors: floors);
  }

  void updateTotalPrice(double totalPrice) {
    state = state.copyWith(totalPrice: totalPrice);
    calculateAndUpdateTotalPrice();
  }

  void updateNotes(String notes) {
    state = state.copyWith(notes: notes);
  }

  // Method to add image to a room
  void addImageToRoom(RoomType roomType, ImageData imageData) {
    switch (roomType) {
      case RoomType.livingRoom:
        state = state.copyWith(
          livingRoomImages: [...state.livingRoomImages, imageData],
        );
        break;
      case RoomType.bedroom:
        state = state.copyWith(
          bedroomImages: [...state.bedroomImages, imageData],
        );
        break;
      case RoomType.diningRoom:
        state = state.copyWith(
          diningRoomImages: [...state.diningRoomImages, imageData],
        );
        break;
      case RoomType.officeRoom:
        state = state.copyWith(
          officeRoomImages: [...state.officeRoomImages, imageData],
        );
        break;
      case RoomType.bathroom:
        state = state.copyWith(
          bathroomImages: [...state.bathroomImages, imageData],
        );
        break;
    }
  }

// Method to remove image to a room
  void removeImageFromRoom(RoomType roomType, ImageData imageData) {
    switch (roomType) {
      case RoomType.livingRoom:
        state = state.copyWith(
          livingRoomImages: state.livingRoomImages
              .where((img) => img.publicId != imageData.publicId)
              .toList(),
        );
        break;
      case RoomType.bedroom:
        state = state.copyWith(
          bedroomImages: state.bedroomImages
              .where((img) => img.publicId != imageData.publicId)
              .toList(),
        );
        break;
      case RoomType.diningRoom:
        state = state.copyWith(
          diningRoomImages: state.diningRoomImages
              .where((img) => img.publicId != imageData.publicId)
              .toList(),
        );
        break;
      case RoomType.officeRoom:
        state = state.copyWith(
          officeRoomImages: state.officeRoomImages
              .where((img) => img.publicId != imageData.publicId)
              .toList(),
        );
        break;
      case RoomType.bathroom:
        state = state.copyWith(
          bathroomImages: state.bathroomImages
              .where((img) => img.publicId != imageData.publicId)
              .toList(),
        );
        break;
    }
  }

  void updateChecklistValue(int index, bool value) {
    final updatedChecklistValues = List<bool>.from(state.checklistValues);
    updatedChecklistValues[index] = value;
    state = state.copyWith(checklistValues: updatedChecklistValues);
  }

  // Location methods
  void updatePickUpLocation(LocationModel location) {
    state = state.copyWith(pickUpLocation: location);
  }

  void updateDropOffLocation(LocationModel location) {
    state = state.copyWith(dropOffLocation: location);
  }

  void updateBookingDate(DateTime date) {
    state = state.copyWith(bookingDate: date);
  }

  void toggleSelectingPickUp(bool isSelecting) {
    state = state.copyWith(isSelectingPickUp: isSelecting);
  }

  double calculateVehiclePrice(int index) {
    return 300000 + (index * 50000);
  }

  double calculateTotalPrice({double? vehiclePrice, double? packagePrice}) {
    double total = 0.0;
    total += vehiclePrice ?? state.vehiclePrice;
    total += packagePrice ?? state.packagePrice;
    // Add other price components as needed
    return total;
  }

  void updateIsReviewOnline(bool isReviewOnline) {
    state = state.copyWith(isReviewOnline: isReviewOnline);
  }

  void reset() {
    state = Booking(
      totalPrice: 0.0,
      additionalServiceQuantities: [],
    );
  }
}

// The global provider that can be accessed in all screens
final bookingProvider = StateNotifierProvider<BookingNotifier, Booking>(
  (ref) => BookingNotifier(),
);

enum RoomType { livingRoom, bedroom, diningRoom, officeRoom, bathroom }
