// service_booking_repository.dart

import 'package:movemate/features/booking/data/models/response/house_type_response.dart';
import 'package:movemate/features/booking/data/models/response/services_fee_system_response.dart';
import 'package:movemate/features/booking/data/models/response/services_package_response.dart';
import 'package:movemate/features/booking/data/models/response/services_response.dart';
import 'package:movemate/features/booking/data/models/resquest/booking_requesst.dart';
import 'package:movemate/features/booking/data/remote/service_booking_source.dart';
import 'package:movemate/features/booking/data/repositories/service_booking_repository_impl.dart';
import 'package:movemate/models/request/paging_model.dart';
import 'package:movemate/models/response/success_model.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'service_booking_repository.g.dart';

abstract class ServiceBookingRepository {
  // House Type Methods
  Future<HouseTypeResponse> getHouseTypes({
    required PagingModel request,
  });

  // Services Methods
  Future<ServicesResponse> getServices({
    required PagingModel request,
  });

  // Services Fee System Methods
  Future<ServicesFeeSystemResponse> getFeeSystems({
    required PagingModel request,
  });

  // Services Package Methods
  Future<ServicesPackageResponse> getPackageServices();

  // post booking service
  Future<SuccessModel> postBookingservice({required BookingRequest request});
}

@Riverpod(keepAlive: true)
ServiceBookingRepository serviceBookingRepository(ServiceBookingRepositoryRef ref) {
  final serviceBookingSource = ref.read(serviceBookingSourceProvider);
  return ServiceBookingRepositoryImpl(serviceBookingSource);
}
