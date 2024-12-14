// import local
import 'package:movemate/features/order/data/models/request/change_booking_at_request.dart';
import 'package:movemate/features/order/data/models/request/order_query_request.dart';
import 'package:movemate/features/order/data/models/request/service_query_request.dart';
import 'package:movemate/features/order/data/models/request/user_report_request.dart';
import 'package:movemate/features/order/data/models/ressponse/booking_new_response.dart';
import 'package:movemate/features/order/data/models/ressponse/order_reponse.dart';
import 'package:movemate/features/order/data/models/ressponse/service_response.dart';
import 'package:movemate/features/order/data/models/ressponse/truck_category_obj_response.dart';
import 'package:movemate/features/order/data/models/ressponse/truck_categorys_response.dart';
import 'package:movemate/features/order/data/remote/order_remote/order_source.dart';
import 'package:movemate/features/order/domain/repositories/order_repository.dart';
import 'package:movemate/models/request/paging_model.dart';
import 'package:movemate/models/response/success_model.dart';

// utils
import 'package:movemate/utils/constants/api_constant.dart';
import 'package:movemate/utils/resources/remote_base_repository.dart';

class OrderRepositoryImpl extends RemoteBaseRepository
    implements OrderRepository {
  final bool addDelay;
  final OrderSource _orderSource;

  OrderRepositoryImpl(this._orderSource, {this.addDelay = true});

  @override
  Future<OrderReponse> getBookings({
    required PagingModel request,
    required String accessToken,
    required int userId,
  }) async {
    final orderQueryRequest = OrderQueryRequest(
      search: request.searchContent,
      page: request.pageNumber,
      perPage: request.pageSize,
      UserId: userId,
    );

    print("vinh log order : ${orderQueryRequest.toJson()}");
    return getDataOf(
      request: () => _orderSource.getBookings(
        APIConstants.contentType,
        accessToken,
        orderQueryRequest,
      ),
    );
  }

  @override
  Future<ServiceResponse> getAllService({
    required PagingModel request,
    required String accessToken,
    // required int userId,
  }) async {
    final serviceQueryRequest = ServiceQueryRequest(
      search: request.searchContent,
      type: 'TRUCK',
      page: request.pageNumber,
      perPage: request.pageSize,
      // UserId: userId,
    );

    print("tuan log order : ${serviceQueryRequest.toJson()}");
    return getDataOf(
      request: () => _orderSource.getAllService(
        APIConstants.contentType,
        accessToken,
        serviceQueryRequest,
      ),
    );
  }

  @override
  Future<TruckCategorysResponse> getTruckList({
    required PagingModel request,
    required String accessToken,
  }) async {
    return getDataOf(
      request: () =>
          _orderSource.getTruckList(APIConstants.contentType, accessToken),
    );
  }

  @override
  Future<TruckCategoryObjResponse> getTruckById({
    required String accessToken,
    required int id,
  }) async {
    // print("repo log $id");
    return getDataOf(
      request: () => _orderSource.getTruckById(
        APIConstants.contentType,
        accessToken,
        id,
      ),
    );
  }

  @override
  Future<BookingNewResponse> getBookingNewById({
    required String accessToken,
    required int id,
  }) async {
    return getDataOf(
      request: () => _orderSource.getBookingNewById(
        APIConstants.contentType,
        accessToken,
        id,
      ),
    );
  }

  @override
  Future<BookingNewResponse> getBookingOldById({
    required String accessToken,
    required int id,
  }) async {
    return getDataOf(
      request: () => _orderSource.getBookingOldById(
        APIConstants.contentType,
        accessToken,
        id,
      ),
    );
  }

  @override
  Future<SuccessModel> changeBookingAt({
    required String accessToken,
    required int id,
    required ChangeBookingAtRequest request,
  }) async {
    final requestBookingAt = ChangeBookingAtRequest(
      bookingAt: request.bookingAt,
    );
    print("check date time repo1 ${request.toJson()}");
    print("check date time repo2 ${requestBookingAt.toJson()}");
    return getDataOf(
      request: () => _orderSource.changeBookingAt(
        requestBookingAt,
        APIConstants.contentType,
        accessToken,
        id,
      ),
    );
  }

  //user report
  @override
  Future<SuccessModel> postUserReport({
    required String accessToken,
    required int id,
    required UserReportRequest request,
  }) async {
    final requestBookingAt = UserReportRequest(
      description: request.description,
      estimatedAmount: request.estimatedAmount,
      isInsurance: request.isInsurance,
      location: request.location,
      point: request.point,
      // reason: request.reason,
      title: request.title,
      bookingId: id,
      resourceList: request.resourceList,
    );

    return getDataOf(
      request: () => _orderSource.postUserReport(
        APIConstants.contentType,
        accessToken,
        requestBookingAt,
      ),
    );
  }
}
