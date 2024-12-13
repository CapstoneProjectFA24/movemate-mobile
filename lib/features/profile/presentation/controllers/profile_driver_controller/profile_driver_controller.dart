import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:movemate/features/auth/domain/repositories/auth_repository.dart';
import 'package:movemate/features/auth/presentation/screens/sign_in/sign_in_controller.dart';
import 'package:movemate/features/profile/domain/entities/staff_profile_entity.dart';
import 'package:movemate/features/profile/domain/repositories/profile_repository.dart';
import 'package:movemate/utils/commons/functions/api_utils.dart';
import 'package:movemate/utils/commons/functions/shared_preference_utils.dart';
import 'package:movemate/utils/constants/api_constant.dart';
import 'package:movemate/utils/enums/status_code_type.dart';
import 'package:movemate/utils/extensions/extensions_export.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

// config

// domain - data

// utils

part 'profile_driver_controller.g.dart';

@riverpod
class ProfileDriverController extends _$ProfileDriverController {
  @override
  FutureOr<void> build() {}

  Future<StaffProfileEntity?> getProfileDriverInforById(
    int id,
    BuildContext context,
  ) async {
    StaffProfileEntity? profileDriverInfor;
//flag
    print(
        "----------------------------controller flag-------------------------------");
    state = const AsyncLoading();
    final profileRepository = ref.read(profileRepositoryProvider);
    final authRepository = ref.read(authRepositoryProvider);
    final user = await SharedPreferencesUtils.getInstance('user_token');

    state = await AsyncValue.guard(() async {
      // print("controlle 2 flag");
      final response = await profileRepository.getProfileDriverInforById(
        accessToken: APIConstants.prefixToken + user!.tokens.accessToken,
        id: id,
      );
      profileDriverInfor = response.payload;
      print("controller account  ${profileDriverInfor?.email}");
      // print("controller passwork  ${profileDriverInfor}");
    });

    if (state.hasError) {
      state = await AsyncValue.guard(() async {
        final statusCode = (state.error as DioException).onStatusDio();
        await handleAPIError(
          statusCode: statusCode,
          stateError: state.error!,
          context: context,
          onCallBackGenerateToken: () async => await reGenerateToken(
            authRepository,
            context,
          ),
        );

        if (state.hasError) {
          await ref.read(signInControllerProvider.notifier).signOut(context);
        }

        if (statusCode != StatusCodeType.unauthentication.type) {}
      });
    }
    return profileDriverInfor;
  }
}
