// service_booking_repository.dart

import 'package:movemate/features/booking/data/models/response/booking_response.dart';
import 'package:movemate/features/booking/data/models/response/house_type_obj_response.dart';
import 'package:movemate/features/booking/data/models/response/house_type_response.dart';
import 'package:movemate/features/booking/data/models/response/service_obj_response.dart';
import 'package:movemate/features/booking/data/models/response/service_truck_response.dart';
import 'package:movemate/features/booking/data/models/response/services_fee_system_response.dart';
import 'package:movemate/features/booking/data/models/response/services_package_response.dart';
import 'package:movemate/features/booking/data/models/response/services_response.dart';
import 'package:movemate/features/booking/data/models/response/truck_cate_response.dart';
import 'package:movemate/features/booking/data/models/resquest/booking_request.dart';
import 'package:movemate/features/booking/data/models/resquest/booking_valuation_request.dart';
import 'package:movemate/features/booking/data/models/resquest/reviewer_status_request.dart';
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
    required String accessToken,
  });
  // House Type Methods get by id
  Future<HouseTypeObjResponse> getHouseTypeById({
    required String accessToken,
    required int id,
  });

  // Truck Services 
    Future<ServiceTruckResponse> getServicesTruck({
    required String accessToken,
    required PagingModel request,
  });

  // Services Methods
  Future<ServicesResponse> getServices({
    required PagingModel request,
    required String accessToken,
  });
  // Services Methods by id 
  Future<ServiceObjResponse> getServicesById({
    required String accessToken,
    required int id,
  });
  // Services Methods by id 
  Future<TruckCateResponse> getTruckDetailById({
    required String accessToken,
    required int id,
  });

  // Services Fee System Methods
  Future<ServicesFeeSystemResponse> getFeeSystems({
    required PagingModel request,
    required String accessToken,
  });

  // Services Package Methods
  Future<ServicesPackageResponse> getPackageServices({
    required PagingModel request,
    required String accessToken,
  });

  // post booking service
  Future<BookingResponse> postBookingservice({
    required BookingRequest request,
    required String accessToken,
  });

  Future<BookingResponse> getBookingDetails({
    required String accessToken,
    required int id,
  });
  Future<BookingResponse> postValuationBooking({
    required BookingValuationRequest request,
    required String accessToken,
  });

    Future<SuccessModel> confirmReviewBooking({
    required String accessToken,
    required ReviewerStatusRequest request,
    required int id,
  });
}

@Riverpod(keepAlive: true)
ServiceBookingRepository serviceBookingRepository(
    ServiceBookingRepositoryRef ref) {
  final serviceBookingSource = ref.read(serviceBookingSourceProvider);
  return ServiceBookingRepositoryImpl(serviceBookingSource);
}
