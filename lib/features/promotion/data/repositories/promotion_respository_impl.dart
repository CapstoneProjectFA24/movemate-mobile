// import local
import 'package:intl/intl.dart';
import 'package:movemate/features/order/data/models/request/order_query_request.dart';
import 'package:movemate/features/order/data/models/request/service_query_request.dart';
import 'package:movemate/features/order/data/models/ressponse/order_reponse.dart';
import 'package:movemate/features/order/data/models/ressponse/service_response.dart';
import 'package:movemate/features/order/data/models/ressponse/truck_category_obj_response.dart';
import 'package:movemate/features/order/data/models/ressponse/truck_categorys_response.dart';
import 'package:movemate/features/order/data/remote/order_remote/order_source.dart';
import 'package:movemate/features/order/domain/repositories/order_repository.dart';
import 'package:movemate/features/promotion/data/models/request/promotion_request.dart';
import 'package:movemate/features/promotion/data/models/request/promotion_sort_request.dart';
import 'package:movemate/features/promotion/data/models/response/promotion_about_user_response.dart';
import 'package:movemate/features/promotion/data/models/response/promotion_object_response.dart';
import 'package:movemate/features/promotion/data/models/response/promotion_response.dart';
import 'package:movemate/features/promotion/data/models/response/voucher_response.dart';
import 'package:movemate/features/promotion/data/remote/promotion_source.dart';
import 'package:movemate/features/promotion/domain/repositories/promotion_repository.dart';
import 'package:movemate/models/request/paging_model.dart';
import 'package:movemate/models/response/success_model.dart';

// utils
import 'package:movemate/utils/constants/api_constant.dart';
import 'package:movemate/utils/resources/remote_base_repository.dart';

class PromotionRespositoryImpl extends RemoteBaseRepository
    implements PromotionRepository {
  final bool addDelay;
  final PromotionSource _promotionSource;

  PromotionRespositoryImpl(this._promotionSource, {this.addDelay = true});

  @override
  Future<PromotionResponse> getPromotions({
    required PagingModel request,
    required String accessToken,
    // required int userId,
  }) async {
    final promotionQueryRequest = PromotionQueryRequest(
      search: request.searchContent,
      page: request.pageNumber,
      perPage: request.pageSize,
      //  sortColumn: request.sortColumn,
      // UserId: userId,
    );

    // print(" log order : ${promotionQueryRequest.toJson()}");
    return getDataOf(
      request: () => _promotionSource.getPromotions(
        APIConstants.contentType,
        accessToken,
        promotionQueryRequest,
      ),
    );
  }

  @override
  Future<PromotionObjectResponse> getPromotionNoUser({
    required String accessToken,
  }) async {
    // Lấy thời gian hiện tại
    DateTime now = DateTime.now();

    // Định dạng thời gian theo dạng mm/dd/yyyy
    String dateNow = DateFormat('MM/dd/yyyy').format(now);

    // Tạo request với thời gian hiện tại
    final request = PromotionSortRequest(
      dateNow: dateNow, // Truyền thời gian đã được định dạng vào request
    );

    // Gọi API để lấy dữ liệu
    return getDataOf(
      request: () => _promotionSource.getPromotionNoUser(
        APIConstants.contentType,
        accessToken,
        request,
      ),
    );
  }

  //post voucher for user by promotion id
  @override
  Future<SuccessModel> postVouherForUser({
    required String accessToken,
    required int id,
  }) async {
    print("checking test repo $id");
    return getDataOf(
      request: () => _promotionSource.postVouherForUser(
        APIConstants.contentType,
        accessToken,
        id,
      ),
    );
  }
}
