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
  }

// Method to fetch booking data from API (for future use)
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

  void updateHouseType(String? houseType) {
    state = state.copyWith(houseType: houseType);
  }

  void updateNumberOfRooms(int rooms) {
    state = state.copyWith(numberOfRooms: rooms);
  }

  void updateNumberOfFloors(int floors) {
    state = state.copyWith(numberOfFloors: floors);
  }

  // void updateSelectedVehicle(int index, double price) {
  //   state = state.copyWith(
  //     selectedVehicleIndex: index,
  //     totalPrice: state.totalPrice + price,
  //   );
  // }

  void updateSelectedPackageIndex(int? index) {
    state = state.copyWith(selectedPackageIndex: index);
  }

  void updateTotalPrice(double totalPrice) {
    state = state.copyWith(totalPrice: totalPrice);
  }

  void updateAirConditionersCount(int count) {
    state = state.copyWith(airConditionersCount: count);
  }

  void updateRoundTrip(bool isRoundTrip) {
    state = state.copyWith(isRoundTrip: isRoundTrip);
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
