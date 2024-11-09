import 'package:dio/dio.dart';
import 'package:movemate/features/order/data/models/request/order_query_request.dart';
import 'package:movemate/features/order/data/models/request/service_query_request.dart';
import 'package:movemate/features/order/data/models/ressponse/order_reponse.dart';
import 'package:movemate/features/order/data/models/ressponse/service_response.dart';
import 'package:movemate/features/order/data/models/ressponse/truck_category_obj_response.dart';
import 'package:movemate/features/order/data/models/ressponse/truck_categorys_response.dart';
import 'package:retrofit/retrofit.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
// data impl

// utils
import 'package:movemate/utils/constants/api_constant.dart';
import 'package:movemate/utils/providers/common_provider.dart';

part 'order_source.g.dart';

@RestApi(baseUrl: APIConstants.baseUrl, parser: Parser.MapSerializable)
abstract class OrderSource {
  factory OrderSource(Dio dio, {String baseUrl}) = _OrderSource;

  @GET(APIConstants.bookings)
  Future<HttpResponse<OrderReponse>> getBookings(
    @Header(APIConstants.contentHeader) String contentType,
    @Header(APIConstants.authHeader) String accessToken,
    @Queries() OrderQueryRequest request,
  );
  @GET(APIConstants.get_all_package_services)
  Future<HttpResponse<ServiceResponse>> getAllService(
    @Header(APIConstants.contentHeader) String contentType,
    @Header(APIConstants.authHeader) String accessToken,
    @Queries() ServiceQueryRequest request,
  );
  //get list truck
  @GET(APIConstants.get_list_truck)
  Future<HttpResponse<TruckCategorysResponse>> getTruckList(
    @Header(APIConstants.contentHeader) String contentType,
    @Header(APIConstants.authHeader) String accessToken,
  );
  //get  truck by id
   @GET('${APIConstants.get_list_truck}/{id}')
  Future<HttpResponse<TruckCategoryObjResponse>> getTruckById(
    @Header(APIConstants.contentHeader) String contentType,
    @Header(APIConstants.authHeader) String accessToken,
    @Path('id') int id,
  );
}

@riverpod
OrderSource orderSource(OrderSourceRef ref) {
  final dio = ref.read(dioProvider);
  return OrderSource(dio);
}
