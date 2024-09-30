import 'package:flutter/material.dart';
import 'package:movemate/features/testapi/data/models/house_model.dart';
import 'package:movemate/features/testapi/domain/repositories/house_type_repository.dart';
import 'package:movemate/utils/commons/functions/shared_preference_utils.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

// config

// domain - data

// utils
import 'package:movemate/utils/constants/api_constant.dart';

part 'test_controller.g.dart';

// @riverpod
// class TestController extends _$TestController {
//   @override
//   FutureOr<void> build() {
// //list house

//     Future<List<HouseModel>> getHouses(BuildContext context) async {
//       List<HouseModel> houses = [];

//       state = const AsyncLoading();

//       final houseTypeRepository = ref.read(houseTypeRepositoryProvider);

//       final user = await SharedPreferencesUtils.getInstance("user_token");

//       state = await AsyncValue.guard(
//         () async {
//           final response = await houseTypeRepository.getHousesTypesData(
//             accessToken: APIConstants.prefixToken + user!.tokens.accessToken,
//           );
//           houses = response.houses;
//         },
//       );

//       return houses;
//     }
//   }
// }
@riverpod
class TestController extends _$TestController {
  @override
  FutureOr<void> build() {
    // Initialize any state if necessary
  }

  // Move 'getHouses' outside of 'build' to make it a class method
  Future<List<HouseModel>> getHouses(BuildContext context) async {
    List<HouseModel> houses = [];

    state = const AsyncLoading();

    final houseTypeRepository = ref.read(houseTypeRepositoryProvider);

    final user = await SharedPreferencesUtils.getInstance("user_token");

    state = await AsyncValue.guard(
      () async {
        final response = await houseTypeRepository.getHousesTypesData(
          accessToken: APIConstants.prefixToken + user!.tokens.accessToken,
        );
        houses = response.houses;
      },
    );

    return houses;
  }
}
