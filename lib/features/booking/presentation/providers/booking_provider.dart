import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:movemate/features/booking/domain/entities/booking_enities.dart';

class BookingNotifier extends StateNotifier<Booking> {
  BookingNotifier() : super(Booking(totalPrice: 0.0)); 

  void updateHouseType(String? houseType) {
    state = state.copyWith(houseType: houseType);
  }

  void updateNumberOfRooms(int rooms) {
    state = state.copyWith(numberOfRooms: rooms);
  }

  void updateNumberOfFloors(int floors) {
    state = state.copyWith(numberOfFloors: floors);
  }

  void updateSelectedVehicle(int index, double price) {
    state = state.copyWith(
      selectedVehicleIndex: index,
      totalPrice: state.totalPrice + price,
    );
  }

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
}

// The global provider that can be accessed in all screens
final bookingProvider = StateNotifierProvider<BookingNotifier, Booking>(
  (ref) => BookingNotifier(),
);
