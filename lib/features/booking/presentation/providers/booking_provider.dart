//booking_provider.dart

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:movemate/features/booking/data/data_sources/booking_fake_data.dart';
import 'package:movemate/features/booking/data/models/vehicle_model.dart';

import 'package:movemate/features/booking/domain/entities/booking_enities.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class BookingNotifier extends StateNotifier<Booking> {
  // BookingNotifier() : super(Booking(totalPrice: 0.0));

  //start test

  BookingNotifier() : super(Booking(totalPrice: 0.0)) {
    // Load fake data when the notifier is initialized
    loadBookingData();
    loadAvailableVehicles();
    loadPackages();
  }

  void loadPackages() {
    final List<dynamic> jsonData = json.decode(fakeBookingJson2nd);
    final packages =
        jsonData.map((packageJson) => Package.fromJson(packageJson)).toList();
    state = state.copyWith(packages: packages);
  }

  Future<void> fetchBookingData() async {
    try {
      final response =
          await http.get(Uri.parse('https://api.example.com/booking'));
      if (response.statusCode == 200) {
        final jsonData = json.decode(response.body);
        final bookingData = Booking.fromJson(jsonData);
        state = bookingData;
      } else {
        // Handle error
        loadBookingData();
      }
    } catch (e) {
      // Handle exception
      loadBookingData();
    }
  }

  // Method to load booking data (fake data)
  void loadBookingData() {
    final jsonData = json.decode(fakeBookingJson);
    final bookingData = Booking.fromJson(jsonData);
    state = bookingData;
  }

  // Method to load available vehicles from API
  Future<void> fetchloadAvailableVehicles() async {
    try {
      final response =
          await http.get(Uri.parse('https://api.example.com/vehicles'));
      if (response.statusCode == 200) {
        final List<dynamic> jsonData = json.decode(response.body);
        final vehicles = jsonData
            .map((vehicleJson) => Vehicle.fromJson(vehicleJson))
            .toList();
        state = state.copyWith(availableVehicles: vehicles);
      } else {
        // Handle error
        loadAvailableVehicles();
      }
    } catch (e) {
      // Handle exception
      loadAvailableVehicles();
    }
  }

  // Method to load available vehicles
  void loadAvailableVehicles() {
    final List<dynamic> jsonData = json.decode(fakeVehicleJson);
    final vehicles =
        jsonData.map((vehicleJson) => Vehicle.fromJson(vehicleJson)).toList();

    state = state.copyWith(availableVehicles: vehicles);
  }

  //end test

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

  void updatePeopleCount(int count) {
    state = state.copyWith(peopleCount: count);
  }

  void updateSelectedPackageIndex(int? index) {
    state = state.copyWith(selectedPackageIndex: index);
  }

  // Update the total price calculation to include package price
  void calculateAndUpdateTotalPrice() {
    double total = 0.0;

    // Vehicle price
    total += state.vehiclePrice;

    // Package price
    if (state.selectedPackageIndex != null) {
      final selectedPackage = state.packages[state.selectedPackageIndex!];
      final packagePrice = double.parse(
          selectedPackage.packagePrice.replaceAll('.', '').replaceAll('đ', ''));
      total += packagePrice;
    }

    // Air conditioners price (assuming 200,000 per unit)
    total += state.airConditionersCount * 200000;

    // Round trip multiplier
    if (state.isRoundTrip) {
      total *= 1.7;
    }

    state = state.copyWith(totalPrice: total);
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

  // void updateSelectedVehicle(int index, double price) {
  //   state = state.copyWith(
  //     selectedVehicleIndex: index,
  //     totalPrice: state.totalPrice + price,
  //   );
  // }

  // void updateSelectedPackageIndex(int? index) {
  //   state = state.copyWith(selectedPackageIndex: index);
  //   calculateAndUpdateTotalPrice();
  // }

  void updateTotalPrice(double totalPrice) {
    state = state.copyWith(totalPrice: totalPrice);
    calculateAndUpdateTotalPrice();
  }

  void updateAirConditionersCount(int count) {
    state = state.copyWith(airConditionersCount: count);
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
