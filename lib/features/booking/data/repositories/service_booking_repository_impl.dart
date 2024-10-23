// service_booking_repository_impl.dart

import 'package:movemate/features/booking/data/models/response/booking_response.dart';
import 'package:movemate/features/booking/data/models/response/house_type_response.dart';
import 'package:movemate/features/booking/data/models/response/services_fee_system_response.dart';
import 'package:movemate/features/booking/data/models/response/services_package_response.dart';
import 'package:movemate/features/booking/data/models/response/services_response.dart';
import 'package:movemate/features/booking/data/models/resquest/booking_requesst.dart';
import 'package:movemate/features/booking/data/remote/service_booking_source.dart';
import 'package:movemate/features/booking/domain/repositories/service_booking_repository.dart';
import 'package:movemate/models/request/paging_model.dart';
import 'package:movemate/utils/constants/api_constant.dart';
import 'package:movemate/utils/resources/remote_base_repository.dart';

class ServiceBookingRepositoryImpl extends RemoteBaseRepository
    implements ServiceBookingRepository {
  final bool addDelay;
  final ServiceBookingSource _serviceBookingSource;

  ServiceBookingRepositoryImpl(this._serviceBookingSource,
      {this.addDelay = true});

  @override
  Future<HouseTypeResponse> getHouseTypes({
    required PagingModel request,
    required String accessToken,
  }) async {
    return getDataOf(
      request: () => _serviceBookingSource.getHouseTypes(
          APIConstants.contentType, accessToken),
    );
  }

  @override
  Future<ServicesResponse> getServices({
    required PagingModel request,
    required String accessToken,
  }) async {
    return getDataOf(
      request: () => _serviceBookingSource.getServices(
          APIConstants.contentType, accessToken),
    );
  }

  // Services Fee System Methods
  @override
  Future<ServicesFeeSystemResponse> getFeeSystems({
    required PagingModel request,
    required String accessToken,
  }) async {
    return getDataOf(
      request: () => _serviceBookingSource.getFeeSystems(
          APIConstants.contentType, accessToken),
    );
  }

  // Services Package Methods
  @override
  Future<ServicesPackageResponse> getPackageServices({
    required PagingModel request,
    required String accessToken,
  }) async {
    return getDataOf(
      request: () => _serviceBookingSource.getPackageServices(
        APIConstants.contentType,
        accessToken,
      ),
    );
  }

  @override
  Future<BookingResponse> postBookingservice({
    required BookingRequest request,
    required String accessToken,
  }) {
    return getDataOf(
      request: () => _serviceBookingSource.postBookingservice(
          request, APIConstants.contentType, accessToken),
    );
  }

  @override
  Future<BookingResponse> getBookingDetails({
    required String accessToken,
    required int id,
  }) async {
    return getDataOf(
      request: () => _serviceBookingSource.getBookingDetails(
          APIConstants.contentType, accessToken, id),
    );
  }
  @override
  Future<BookingResponse> postValuationBooking({
    required BookingRequest request,
    required String accessToken,
  }) {
    return getDataOf(
      request: () => _serviceBookingSource.postValuationBooking(
        request,
        APIConstants.contentType,
        accessToken,
      ),
    );
  }

  // Additional methods can be added here as needed
}
