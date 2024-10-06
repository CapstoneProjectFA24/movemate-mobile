//booking_provider.dart

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:movemate/features/booking/data/data_sources/booking_fake_data.dart';
import 'package:movemate/features/booking/data/models/vehicle_model.dart';
import 'package:movemate/features/booking/domain/entities/booking_enities.dart';
import 'package:movemate/features/booking/domain/entities/package_entities.dart';

import 'dart:convert';

import 'package:movemate/features/home/domain/entities/location_model_entities.dart';

class BookingNotifier extends StateNotifier<Booking> {
  // BookingNotifier() : super(Booking(totalPrice: 0.0));
  BookingNotifier()
      : super(Booking(
            totalPrice: 0.0, additionalServiceQuantities: [], packages: [])) {
    loadBookingData();

    loadAvailableVehicles();
    loadPackages();
  }

  void loadPackages() {
    final List<dynamic> jsonData = json.decode(fakeBookingJson3nd);
    final packages = jsonData.map((e) => Package.fromJson(e)).toList();
    state = state.copyWith(packages: packages);
  }

  void updateAdditionalServiceQuantity(int serviceIndex, int newQuantity) {
    final updatedQuantities = [...state.additionalServiceQuantities];
    updatedQuantities[serviceIndex] = newQuantity;
    state = state.copyWith(additionalServiceQuantities: updatedQuantities);
    calculateAndUpdateTotalPrice();
  }

  void updateQuantity(int packageIndex, int serviceIndex, int quantity) {
    final packages = [...state.packages];
    final services = [...packages[packageIndex].services];

    services[serviceIndex] =
        services[serviceIndex].copyWith(quantity: quantity);

    packages[packageIndex] =
        packages[packageIndex].copyWith(services: services);

    state = state.copyWith(packages: packages);

    calculateAndUpdateTotalPrice();
  }

  // Method to load booking data (fake data)
  void loadBookingData() {
    final jsonData = json.decode(fakeBookingJson);
    final bookingData = Booking.fromJson(jsonData);
    state = bookingData;
  }

  //end test

  // Method to load available vehicles
  void loadAvailableVehicles() {
    final List<dynamic> jsonData = json.decode(fakeVehicleJson);
    final vehicles =
        jsonData.map((vehicleJson) => Vehicle.fromJson(vehicleJson)).toList();

    state = state.copyWith(availableVehicles: vehicles);
  }

  void calculateAndUpdateTotalPrice() {
    double total = 0.0;
    if (state.selectedPackageIndex != null) {
      final selectedPackage = state.packages[state.selectedPackageIndex!];
      // Directly use packagePrice if it's already a double
      total += selectedPackage.packagePrice;
    }
    total += state.airConditionersCount * 200000;
    state = state.copyWith(totalPrice: total);
  }

  // Methods to toggle expanded state
  void toggleHandlingExpanded() {
    state = state.copyWith(isHandlingExpanded: !state.isHandlingExpanded);
  }

  void toggleDisassemblyExpanded() {
    state = state.copyWith(isDisassemblyExpanded: !state.isDisassemblyExpanded);
  }

  void setHandlingExpanded(bool value) {
    state = state.copyWith(isHandlingExpanded: value);
  }

  void setDisassemblyExpanded(bool value) {
    state = state.copyWith(isDisassemblyExpanded: value);
  }

  void updateHouseType(String? houseType) {
    state = state.copyWith(houseType: houseType);
    calculateAndUpdateTotalPrice();
  }

  void updateNumberOfRooms(int rooms) {
    state = state.copyWith(numberOfRooms: rooms);
    calculateAndUpdateTotalPrice();
  }

  void updateNumberOfFloors(int floors) {
    state = state.copyWith(numberOfFloors: floors);
    calculateAndUpdateTotalPrice();
  }

  void updateTotalPrice(double totalPrice) {
    state = state.copyWith(totalPrice: totalPrice);
    calculateAndUpdateTotalPrice();
  }

  void updateRoundTrip(bool isRoundTrip) {
    state = state.copyWith(isRoundTrip: isRoundTrip);
    calculateAndUpdateTotalPrice();
  }

  void updateNotes(String notes) {
    state = state.copyWith(notes: notes);
  }

  // Method to add image to a room
  void addImageToRoom(RoomType roomType, String imagePath) {
    switch (roomType) {
      case RoomType.livingRoom:
        state = state.copyWith(
          livingRoomImages: [...state.livingRoomImages, imagePath],
        );
        break;
      case RoomType.bedroom:
        state = state.copyWith(
          bedroomImages: [...state.bedroomImages, imagePath],
        );
        break;
      case RoomType.diningRoom:
        state = state.copyWith(
          diningRoomImages: [...state.diningRoomImages, imagePath],
        );
        break;
      case RoomType.officeRoom:
        state = state.copyWith(
          officeRoomImages: [...state.officeRoomImages, imagePath],
        );
        break;
      case RoomType.bathroom:
        state = state.copyWith(
          bathroomImages: [...state.bathroomImages, imagePath],
        );
        break;
    }
    calculateAndUpdateTotalPrice();
  }

  // Method to remove image from a room
  void removeImageFromRoom(RoomType roomType, String imagePath) {
    switch (roomType) {
      case RoomType.livingRoom:
        state = state.copyWith(
          livingRoomImages:
              state.livingRoomImages.where((img) => img != imagePath).toList(),
        );
        break;
      case RoomType.bedroom:
        state = state.copyWith(
          bedroomImages:
              state.bedroomImages.where((img) => img != imagePath).toList(),
        );
        break;
      case RoomType.diningRoom:
        state = state.copyWith(
          diningRoomImages:
              state.diningRoomImages.where((img) => img != imagePath).toList(),
        );
        break;
      case RoomType.officeRoom:
        state = state.copyWith(
          officeRoomImages:
              state.officeRoomImages.where((img) => img != imagePath).toList(),
        );
        break;
      case RoomType.bathroom:
        state = state.copyWith(
          bathroomImages:
              state.bathroomImages.where((img) => img != imagePath).toList(),
        );
        break;
    }
    calculateAndUpdateTotalPrice();
  }

  // Method to update selected vehicle
  void updateSelectedVehicle(int index) {
    final selectedVehicle = state.availableVehicles[index];
    double price = selectedVehicle.price;

    state = state.copyWith(
      selectedVehicleIndex: index,
      vehiclePrice: price,
      totalPrice: calculateTotalPrice(vehiclePrice: price),
    );
  }

  void updateChecklistValue(int index, bool value) {
    final updatedChecklistValues = List<bool>.from(state.checklistValues);
    updatedChecklistValues[index] = value;
    state = state.copyWith(checklistValues: updatedChecklistValues);
  }

//location
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

////
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
}

// The global provider that can be accessed in all screens
final bookingProvider = StateNotifierProvider<BookingNotifier, Booking>(
  (ref) => BookingNotifier(),
);

enum RoomType { livingRoom, bedroom, diningRoom, officeRoom, bathroom }
