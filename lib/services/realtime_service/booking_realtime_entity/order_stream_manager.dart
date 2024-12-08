import 'dart:async';

import 'package:movemate/features/booking/domain/entities/booking_response/booking_response_entity.dart';
import 'package:movemate/features/order/domain/entites/order_entity.dart';

class OrderStreamManager {
  static final OrderStreamManager _instance = OrderStreamManager.internal();

  factory OrderStreamManager() => _instance;
  OrderStreamManager.internal();

  final _jobController = StreamController<OrderEntity>.broadcast();
  Stream<OrderEntity> get jobStream => _jobController.stream;

  void updateJob(OrderEntity newJob) {
    // print(
    //     'tuan Updating order in StreamManager: ${newJob.assignments.map((e) => e.toJson())}');
    // print(
    //     'tuan Updating order in StreamManager totalReal: ${newJob.totalReal}');

    _jobController.add(newJob);
  }

  void dispose() {
    _jobController.close();
  }
}

class OrderStreamManagerResponse {
  static final OrderStreamManagerResponse _instance =
      OrderStreamManagerResponse.internal();

  factory OrderStreamManagerResponse() => _instance;
  OrderStreamManagerResponse.internal();

  final _jobController = StreamController<BookingResponseEntity>.broadcast();
  Stream<BookingResponseEntity> get jobStream => _jobController.stream;

  void updateJob(BookingResponseEntity newJob) {
    // print(
    //     'tuan Updating order in StreamManager: ${newJob.assignments.map((e) => e.toJson())}');

    _jobController.add(newJob);
  }

  void dispose() {
    _jobController.close();
  }
}
