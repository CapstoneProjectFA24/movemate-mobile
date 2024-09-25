import 'package:flutter/material.dart';
import 'package:movemate/features/test/data/models/house_model.dart';
import 'package:movemate/features/test/data/models/house_response.dart';
import 'package:movemate/features/test/domain/repositories/house_type_repository.dart';
import 'package:movemate/utils/commons/functions/shared_preference_utils.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:dio/dio.dart';
import 'package:auto_route/auto_route.dart';

// config
import 'package:movemate/configs/routes/app_router.dart';

// domain - data
import 'package:movemate/features/auth/data/models/request/sign_up_request/sign_up_request.dart';
import 'package:movemate/features/auth/domain/repositories/auth_repository.dart';

// utils
import 'package:movemate/utils/constants/asset_constant.dart';
import 'package:movemate/utils/commons/functions/api_utils.dart';
import 'package:movemate/utils/commons/widgets/widgets_common_export.dart';
import 'package:movemate/utils/extensions/extensions_export.dart';
import 'package:movemate/utils/constants/api_constant.dart';

part 'test_controller.g.dart';

@riverpod
class TestController extends _$TestController {
  @override
  FutureOr<void> build() {}

  // list house
  Future<List<HouseModel>> getHouses(
    BuildContext context,
  ) async {
    List<HouseModel> houses = [];
    state = const AsyncLoading();

    final houseTypeRepository = ref.read(houseTypeRepositoryProvider);
    final user = await SharedPreferencesUtils.getInstance('user_token');

    state = await AsyncValue.guard(
      () async {
        print("print lần 0 bắt đầu vô đây");
        final response = await houseTypeRepository.getHouseTypeData(
        );

        print("print lần 1 test data đê : $response");
        houses = response.payload;
      },
    );

    print("print lần 2: $houses");

    // xử lý error

    return houses;
  }
}
