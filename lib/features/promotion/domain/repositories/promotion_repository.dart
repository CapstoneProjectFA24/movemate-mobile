// local
import 'package:movemate/features/order/data/models/ressponse/order_reponse.dart';
import 'package:movemate/features/order/data/models/ressponse/service_response.dart';
import 'package:movemate/features/order/data/models/ressponse/truck_category_obj_response.dart';
import 'package:movemate/features/order/data/models/ressponse/truck_categorys_response.dart';
import 'package:movemate/features/order/data/remote/order_remote/order_source.dart';

// system
import 'package:movemate/features/order/data/repositories/order_repository_impl.dart';
import 'package:movemate/features/promotion/data/models/response/promotion_about_user_response.dart';
import 'package:movemate/features/promotion/data/models/response/promotion_by_id_response.dart';
import 'package:movemate/features/promotion/data/models/response/promotion_object_response.dart';
import 'package:movemate/features/promotion/data/models/response/promotion_response.dart';
import 'package:movemate/features/promotion/data/models/response/voucher_response.dart';
import 'package:movemate/features/promotion/data/remote/promotion_source.dart';
import 'package:movemate/features/promotion/data/repositories/promotion_respository_impl.dart';
import 'package:movemate/models/request/paging_model.dart';
import 'package:movemate/models/response/success_model.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'promotion_repository.g.dart';

abstract class PromotionRepository {
  Future<PromotionResponse> getPromotions({
    required PagingModel request,
    required String accessToken,
    // required int userId,
  });

  Future<PromotionObjectResponse> getPromotionNoUser({
    required String accessToken,
    // required int userId,
  });

  //post voucher for user by promotion id
  Future<SuccessModel> postVouherForUser({
    required String accessToken,
    required int id,
  });
  
  //get promotion id
  Future<PromotionByIdResponse> getPromotionById({
    required String accessToken,
    required int id,
  });
}

@Riverpod(keepAlive: true)
PromotionRepository promotionRepository(PromotionRepositoryRef ref) {
  final promotionSource = ref.read(promotionSourceProvider);
  return PromotionRespositoryImpl(promotionSource);
}
