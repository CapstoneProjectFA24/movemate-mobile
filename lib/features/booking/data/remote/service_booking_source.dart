// service_booking_source.dart

import 'package:dio/dio.dart';
import 'package:movemate/features/booking/data/models/response/booking_response.dart';
import 'package:movemate/features/booking/data/models/response/house_type_obj_response.dart';
import 'package:movemate/features/booking/data/models/response/service_obj_response.dart';
import 'package:movemate/features/booking/data/models/response/service_truck_response.dart';
import 'package:movemate/features/booking/data/models/response/truck_cate_response.dart';
import 'package:movemate/features/booking/data/models/resquest/booking_request.dart';
import 'package:movemate/features/booking/data/models/resquest/booking_valuation_request.dart';
import 'package:movemate/features/booking/data/models/resquest/cancel_booking.dart';
import 'package:movemate/features/booking/data/models/resquest/reviewer_status_request.dart';
import 'package:movemate/features/booking/data/models/resquest/valuation_price_one_of_system_service_request.dart';
import 'package:movemate/data/models/response/success_model.dart';
import 'package:retrofit/retrofit.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

// Import response models
import 'package:movemate/features/booking/data/models/response/house_type_response.dart';
import 'package:movemate/features/booking/data/models/response/services_response.dart';
import 'package:movemate/features/booking/data/models/response/services_fee_system_response.dart';
import 'package:movemate/features/booking/data/models/response/services_package_response.dart';

// Utils
import 'package:movemate/utils/constants/api_constant.dart';
import 'package:movemate/utils/providers/common_provider.dart';

part 'service_booking_source.g.dart';

@RestApi(baseUrl: APIConstants.baseUrl, parser: Parser.MapSerializable)
abstract class ServiceBookingSource {
  factory ServiceBookingSource(Dio dio, {String baseUrl}) =
      _ServiceBookingSource;

  // House Types
  @GET(APIConstants.get_house_types)
  Future<HttpResponse<HouseTypeResponse>> getHouseTypes(
    @Header(APIConstants.contentHeader) String contentType,
    @Header(APIConstants.authHeader) String accessToken,
    @Queries() Map<String, dynamic> queries,
  );
  // house types get by id
  @GET('${APIConstants.get_house_types}/{id}')
  Future<HttpResponse<HouseTypeObjResponse>> getHouseTypeById(
    @Header(APIConstants.contentHeader) String contentType,
    @Header(APIConstants.authHeader) String accessToken,
    @Path('id') int id,
  );

  // Services
  @GET(APIConstants.get_service_truck_cate)
  Future<HttpResponse<ServicesResponse>> getServices(
    @Header(APIConstants.contentHeader) String contentType,
    @Header(APIConstants.authHeader) String accessToken,
  );
  // truck  by id
  @GET('${APIConstants.get_list_truck}/{id}')
  Future<HttpResponse<ServiceObjResponse>> getServicesById(
    @Header(APIConstants.contentHeader) String contentType,
    @Header(APIConstants.authHeader) String accessToken,
    @Path('id') int id,
  );
  // truckCate detail  by id
  @GET('${APIConstants.get_truck_category}/{id}')
  Future<HttpResponse<TruckCateResponse>> getTruckDetailById(
    @Header(APIConstants.contentHeader) String contentType,
    @Header(APIConstants.authHeader) String accessToken,
    @Path('id') int id,
  );
  // get all Services truck
  @GET(APIConstants.get_list_truck_cate)
  Future<HttpResponse<ServiceTruckResponse>> getServicesTruck(
    @Header(APIConstants.contentHeader) String contentType,
    @Header(APIConstants.authHeader) String accessToken,
    @Queries() Map<String, dynamic> queries,
  );

  // System Fees
  @GET(APIConstants.get_fees_system)
  Future<HttpResponse<ServicesFeeSystemResponse>> getFeeSystems(
    @Header(APIConstants.contentHeader) String contentType,
    @Header(APIConstants.authHeader) String accessToken,
  );

  // Package Services
  @GET(APIConstants.get_service_not_type_truck)
  Future<HttpResponse<ServicesPackageResponse>> getPackageServices(
    @Header(APIConstants.contentHeader) String contentType,
    @Header(APIConstants.authHeader) String accessToken,
    @Queries() Map<String, dynamic> queries,
  );
  @GET('${APIConstants.bookings}/{id}')
  Future<HttpResponse<BookingResponse>> getBookingDetails(
    @Header(APIConstants.contentHeader) String contentType,
    @Header(APIConstants.authHeader) String accessToken,
    @Path('id') int id,
  );
//Post , put
  // Post booking service
  @POST(APIConstants.post_booking_service)
  Future<HttpResponse<BookingResponse>> postBookingservice(
    @Body() BookingRequest request,
    @Header(APIConstants.contentHeader) String contentType,
    @Header(APIConstants.authHeader) String accessToken,
  );
  // Post valuation booking service
  @POST(APIConstants.post_valuation_booking_service)
  Future<HttpResponse<BookingResponse>> postValuationBooking(
    @Body() BookingValuationRequest request,
    @Header(APIConstants.contentHeader) String contentType,
    @Header(APIConstants.authHeader) String accessToken,
  );
  // Post ValuationPriceOneOfSystemService  booking service
  @POST(APIConstants.post_valuation_booking_service)
  Future<HttpResponse<BookingResponse>> postValuationPriceOneOfSystemService(
    @Body() ValuationPriceOneOfSystemServiceRequest request,
    @Header(APIConstants.contentHeader) String contentType,
    @Header(APIConstants.authHeader) String accessToken,
  );

  @PUT('${APIConstants.confirm_review}/{id}')
  Future<HttpResponse<SuccessModel>> confirmReviewBooking(
    @Header(APIConstants.contentHeader) String contentType,
    @Header(APIConstants.authHeader) String accessToken,
    @Body() ReviewerStatusRequest request,
    @Path('id') int id,
  );
  @PUT('${APIConstants.cancel_booking}/{id}')
  Future<HttpResponse<SuccessModel>> cancelBooking(
    @Header(APIConstants.contentHeader) String contentType,
    @Header(APIConstants.authHeader) String accessToken,
    @Body() CancelBooking request,
    @Path('id') int id,
  );
}

@riverpod
ServiceBookingSource serviceBookingSource(ServiceBookingSourceRef ref) {
  final dio = ref.read(dioProvider);
  return ServiceBookingSource(dio);
}
