// import local
import 'package:movemate/features/order/data/models/request/order_query_request.dart';
import 'package:movemate/features/order/data/models/request/service_query_request.dart';
import 'package:movemate/features/order/data/models/ressponse/order_reponse.dart';
import 'package:movemate/features/order/data/models/ressponse/service_response.dart';
import 'package:movemate/features/order/data/models/ressponse/truck_category_obj_response.dart';
import 'package:movemate/features/order/data/models/ressponse/truck_categorys_response.dart';
import 'package:movemate/features/order/data/remote/order_remote/order_source.dart';
import 'package:movemate/features/order/domain/repositories/order_repository.dart';
import 'package:movemate/features/promotion/data/models/request/promotion_request.dart';
import 'package:movemate/features/promotion/data/models/response/promotion_response.dart';
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

  //post voucher for user by promotion id
  @override
  Future<SuccessModel> postVouherForUser({
    required String accessToken,
    required int id,
  }) async {
    return getDataOf(
      request: () => _promotionSource.postVouherForUser(
        APIConstants.contentType,
        accessToken,
        id,
      ),
    );
  }
}
