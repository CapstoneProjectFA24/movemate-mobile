import 'package:flutter/material.dart';
import 'package:movemate/features/test_booking/domain/entities/booking_entities.dart';
import 'package:movemate/features/test_booking/domain/repositories/booking_repository.dart';

import 'package:riverpod_annotation/riverpod_annotation.dart';

// config

// domain - data

// utils

part 'booking_controller.g.dart';

@riverpod
class BookingController extends _$BookingController {
  @override
  FutureOr<void> build() {}

  Future<List<BookingEntities>> getBookings(BuildContext context) async {
    List<BookingEntities> bookingData = [];

    state = const AsyncLoading();
    print("first call");

    final bookingRepository = ref.read(bookingRepositoryProvider);

    state = await AsyncValue.guard(() async {
      print("2 call");
      final response = await bookingRepository.getBookingData();
      print("res $response");
      bookingData = response.payload;
      print("3 call");
      // return bookingData;
    });

    return bookingData;
  }

  //
}
