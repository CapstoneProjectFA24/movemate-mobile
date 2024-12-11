// service_package_controller.dart

import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:movemate/features/auth/domain/repositories/auth_repository.dart';
import 'package:movemate/features/auth/presentation/screens/sign_in/sign_in_controller.dart';
import 'package:movemate/features/booking/data/models/resquest/booking_valuation_request.dart';
import 'package:movemate/features/booking/data/models/resquest/valuation_price_one_of_system_service_request.dart';
import 'package:movemate/features/booking/domain/entities/booking_response/booking_response_entity.dart';
import 'package:movemate/features/booking/domain/entities/house_type_entity.dart';
import 'package:movemate/features/booking/domain/entities/service_truck/truck_entity_response.dart';
import 'package:movemate/features/booking/domain/entities/services_package_entity.dart';
import 'package:movemate/features/booking/domain/entities/truck_category_entity.dart';
import 'package:movemate/features/booking/domain/repositories/service_booking_repository.dart';
import 'package:movemate/features/booking/presentation/providers/booking_provider.dart';
import 'package:movemate/models/request/paging_model.dart';
import 'package:movemate/utils/commons/functions/api_utils.dart';
import 'package:movemate/utils/commons/functions/shared_preference_utils.dart';
import 'package:movemate/utils/constants/api_constant.dart';
import 'package:movemate/utils/enums/enums_export.dart';
import 'package:movemate/utils/extensions/status_code_dio.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'service_package_controller.g.dart';

final bookingResponseProviderPrice =
    StateProvider<BookingResponseEntity?>((ref) => null);
final ResponseProviderOneOfSystemService =
    StateProvider<BookingResponseEntity?>((ref) => null);

@riverpod
class ServicePackageController extends _$ServicePackageController {
  BookingResponseEntity? bookingResponseEntity;
  @override
  FutureOr<void> build() {}

  Future<List<ServicesPackageEntity>> servicePackage(
    PagingModel request,
    BuildContext context,
  ) async {
    List<ServicesPackageEntity> servicePackages = [];

    state = const AsyncLoading();
    final servicesPackageRepository =
        ref.read(serviceBookingRepositoryProvider);
    final authRepository = ref.read(authRepositoryProvider);
    final user = await SharedPreferencesUtils.getInstance('user_token');

    state = await AsyncValue.guard(() async {
      final response = await servicesPackageRepository.getPackageServices(
        accessToken: APIConstants.prefixToken + user!.tokens.accessToken,
        request: request,
      );
      servicePackages = response.payload;
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

        await servicePackage(request, context);
      });
    }
    return servicePackages;
  }

//get house information
  Future<List<HouseTypeEntity>> getHouseTypes(
    PagingModel request,
    BuildContext context,
  ) async {
    List<HouseTypeEntity> houseTypeData = [];

    state = const AsyncLoading();
    final serviceBookingRepository = ref.read(serviceBookingRepositoryProvider);

    final authRepository = ref.read(authRepositoryProvider);
    final user = await SharedPreferencesUtils.getInstance('user_token');

    state = await AsyncValue.guard(() async {
      final response = await serviceBookingRepository.getHouseTypes(
        request: request,
        accessToken: APIConstants.prefixToken + user!.tokens.accessToken,
      );
      // print("HouseTypeEntity: ${response.payload.toString()}");
      houseTypeData = response.payload;
      state = AsyncData(houseTypeData);
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

        await getHouseTypes(request, context);
      });
    }

    return houseTypeData;
  }

//get house type by id
  Future<HouseTypeEntity?> getHouseTypeById(
    int id,
    BuildContext context,
  ) async {
    HouseTypeEntity? houseType;

    // state = const AsyncLoading();
    final serviceBookingRepository = ref.read(serviceBookingRepositoryProvider);
    final authRepository = ref.read(authRepositoryProvider);
    final user = await SharedPreferencesUtils.getInstance('user_token');
    // print("fcm token : ${user?.fcmToken}");

    state = await AsyncValue.guard(() async {
      final response = await serviceBookingRepository.getHouseTypeById(
        accessToken: APIConstants.prefixToken + user!.tokens.accessToken,
        id: id,
      );

      houseType = response.payload;
      // print('vinh log ${houseType?.toJson()}');
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
        await getHouseTypeById(id, context);
      });
    }

    return houseType;
  }

  //get truck cate detail by id
  Future<TruckCategoryEntity?> getTruckDetailById(
    int id,
    BuildContext context,
  ) async {
    TruckCategoryEntity? truckCateDetails;

    // state = const AsyncLoading();
    final serviceBookingRepository = ref.read(serviceBookingRepositoryProvider);
    final authRepository = ref.read(authRepositoryProvider);
    final user = await SharedPreferencesUtils.getInstance('user_token');
    // print("fcm token : ${user?.fcmToken}");

    state = await AsyncValue.guard(() async {
      final response = await serviceBookingRepository.getTruckDetailById(
        accessToken: APIConstants.prefixToken + user!.tokens.accessToken,
        id: id,
      );

      truckCateDetails = response.payload;
      print('check xe log ${truckCateDetails?.toJson()}');
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
        await getTruckDetailById(id, context);
      });
    }

    return truckCateDetails;
  }

  //get truck cate detail by price
  Future<List<Truck>> getTruckDetailPrice(
    PagingModel request,
    BuildContext context,
  ) async {
    List<Truck> truckCateDetails = [];

    state = const AsyncLoading();
    final serviceBookingRepository = ref.read(serviceBookingRepositoryProvider);
    final authRepository = ref.read(authRepositoryProvider);
    final user = await SharedPreferencesUtils.getInstance('user_token');
    // print("fcm token : ${user?.fcmToken}");

    state = await AsyncValue.guard(() async {
      final response = await serviceBookingRepository.getTruckDetailPrice(
        accessToken: APIConstants.prefixToken + user!.tokens.accessToken,
        request: request,
      );

      truckCateDetails = response.payload;
      // print("object checking ${response.payload.toString()}");
      state = AsyncData(truckCateDetails);
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
        await getTruckDetailPrice(request, context);
      });
    }

    return truckCateDetails;
  }

  //----------------------------------------------------------------

  Future<BookingResponseEntity?> postValuationBooking({
    required BuildContext context,
  }) async {
    // Kiểm tra nếu đã đang xử lý thì không làm gì cả
    if (state is AsyncLoading) {
      return null;
    }
    // state = const AsyncLoading();
    final bookingState = ref.read(bookingProvider);
    final serviceBookingRepository = ref.read(serviceBookingRepositoryProvider);
    final authRepository = ref.read(authRepositoryProvider);
    final user = await SharedPreferencesUtils.getInstance('user_token');
    final bookingValuationRequest =
        BookingValuationRequest.fromBooking(bookingState);
    BookingResponseEntity? responsePayload;

    // Debugging
    print(
        '\n tuan Booking a 0.1 Request: ${jsonEncode(bookingValuationRequest.toMap())}');

    state = await AsyncValue.guard(() async {
      final response = await serviceBookingRepository.postValuationBooking(
        request: bookingValuationRequest,
        accessToken: APIConstants.prefixToken + user!.tokens.accessToken,
      );
      // Không thiết lập lại state ở đây
      responsePayload = response.payload;
      ref.read(bookingResponseProviderPrice.notifier).state = responsePayload;
      // return responsePayload;
      print("\n tuan Booking a 0.2 Response: ${jsonEncode(responsePayload)}");
    });

    if (state.hasError) {
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
      return null;
    }

    return responsePayload;
  }

  Future<BookingResponseEntity?> postValuationPriceOneOfSystemService({
    required BuildContext context,
  }) async {
    // Kiểm tra nếu đã đang xử lý thì không làm gì cả
    if (state is AsyncLoading) {
      return null;
    }
    // state = const AsyncLoading();
    final bookingState = ref.read(bookingProvider);
    final serviceBookingRepository = ref.read(serviceBookingRepositoryProvider);
    final authRepository = ref.read(authRepositoryProvider);
    final user = await SharedPreferencesUtils.getInstance('user_token');
    final bookingValuationRequest =
        ValuationPriceOneOfSystemServiceRequest.fromBooking(bookingState);
    BookingResponseEntity? responsePayload;

    // Debugging
    print(
        ' \n tuan Booking a 1 Request Valuation Price One Of System Service : ${jsonEncode(bookingValuationRequest.toMap())}');

    state = await AsyncValue.guard(() async {
      final response =
          await serviceBookingRepository.postValuationPriceOneOfSystemService(
        request: bookingValuationRequest,
        accessToken: APIConstants.prefixToken + user!.tokens.accessToken,
      );
      // Không thiết lập lại state ở đây
      responsePayload = response.payload;
      ref.read(ResponseProviderOneOfSystemService.notifier).state =
          responsePayload;
      // return responsePayload;
      // print(
      //     " \n tuan Booking a 2  Response Valuation Price One Of System Service  ${jsonEncode(responsePayload)} ");
      print(
          " \n tuan Booking a 3  Response Valuation Price One Of System Service  ${jsonEncode(responsePayload!.bookingDetails.toString())} ");
    });

    if (state.hasError) {
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
      return null;
    }

    return responsePayload;
  }
}
