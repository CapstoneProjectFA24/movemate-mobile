// service_booking_repository_impl.dart

import 'package:movemate/features/booking/data/models/queries/truck_queries.dart';
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
import 'package:movemate/features/booking/domain/repositories/service_booking_repository.dart';
import 'package:movemate/models/request/paging_model.dart';
import 'package:movemate/models/response/success_model.dart';
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
    // Convert PagingModel to a Map of query parameters
    final Map<String, dynamic> queries = {
      'page': request.pageNumber,
      'per_page': request.pageSize,
      'SortColumn': request.sortColumn,
      // Add other parameters if needed
    };

    return getDataOf(
      request: () => _serviceBookingSource.getHouseTypes(
        APIConstants.contentType,
        accessToken,
        queries, // Pass the query parameters
      ),
    );
  }

  @override
  Future<HouseTypeObjResponse> getHouseTypeById({
    required String accessToken,
    required int id,
  }) async {
    return getDataOf(
      request: () => _serviceBookingSource.getHouseTypeById(
        APIConstants.contentType,
        accessToken,
        id,
      ),
    );
  }
  //--------------------------------------------------------------------------------

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

  //get service by id
  @override
  Future<ServiceObjResponse> getServicesById({
    required String accessToken,
    required int id,
  }) async {
    return getDataOf(
      request: () => _serviceBookingSource.getServicesById(
        APIConstants.contentType,
        accessToken,
        id,
      ),
    );
  }

  //get truck cate detail by id
  @override
  Future<TruckCateResponse> getTruckDetailById({
    required String accessToken,
    required int id,
  }) async {
    return getDataOf(
      request: () => _serviceBookingSource.getTruckDetailById(
        APIConstants.contentType,
        accessToken,
        id,
      ),
    );
  }

  @override
  Future<ServiceTruckResponse> getServicesTruck({
    required PagingModel request,
    required String accessToken,
  }) async {
    final truckQueries = TruckQueries(
      page: request.pageNumber,
      perPage: request.pageSize,
      type: request.type ?? 'truck', // Đảm bảo `type` được đặt
    ).toMap();

    return getDataOf(
      request: () => _serviceBookingSource.getServicesTruck(
          APIConstants.contentType, accessToken, truckQueries),
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
    // Convert PagingModel to a Map of query parameters
    final Map<String, dynamic> queries = {
      'page': request.pageNumber,
      'per_page': request.pageSize,
      'SortColumn': request.sortColumn,
      // Add other parameters if needed
    };
    return getDataOf(
      request: () => _serviceBookingSource.getPackageServices(
        APIConstants.contentType,
        accessToken,
        queries,
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
    required BookingValuationRequest request,
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

  @override
  Future<SuccessModel> confirmReviewBooking({
    required String accessToken,
    required ReviewerStatusRequest request,
    required int id,
  }) async {
    // print('vinh log repo : ${request.toJson()} + $id');
    return getDataOf(
      request: () => _serviceBookingSource.confirmReviewBooking(
        APIConstants.contentType,
        accessToken,
        request,
        id,
      ),
    );
  }

  // Additional methods can be added here as needed
}
