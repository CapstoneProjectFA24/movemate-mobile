// service_controller_test.dart

import 'package:flutter/material.dart';
import 'package:movemate/features/booking/domain/entities/service_entity.dart';
import 'package:movemate/features/booking/domain/repositories/service_booking_repository.dart';
import 'package:movemate/models/request/paging_model.dart';
import 'package:movemate/utils/constants/api_constant.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'service_controller_test.g.dart';

@riverpod
class ServiceControllerTest extends _$ServiceControllerTest {
  @override
  FutureOr<void> build() async {}

  Future<List<ServiceEntity>> getServices(
    PagingModel request,
    BuildContext context,
  ) async {
    List<ServiceEntity> serviceCateData = [];
    const accessToken =
        "eyJhbGciOiJIUzUxMiIsInR5cCI6IkpXVCJ9.eyJzdWIiOiJqb2huZG9lQGV4YW1wbGUuY29tIiwiZW1haWwiOiJqb2huZG9lQGV4YW1wbGUuY29tIiwic2lkIjoiMSIsInJvbGUiOiIxIiwianRpIjoiMTMwYTMwMzktNDdhZi00NTY2LWFlNjctZTE3ZTY4YThjNTE2IiwibmJmIjoxNzI5MjM1OTM4LCJleHAiOjIzMjkyMzU5MzgsImlhdCI6MTcyOTIzNTkzOH0.LKs7sOC0EnuYtW3K7zw_7tBrn2GZzrZTS1cue3XQryrA2JDMt03Ss3PKRlhN2ht8EI0UPVgNN6eptewxIlldJQ"; // your fake token

    state = const AsyncLoading();
    final serviceBookingRepository = ref.read(serviceBookingRepositoryProvider);

    state = await AsyncValue.guard(() async {
      final response = await serviceBookingRepository.getServices(
        accessToken: APIConstants.prefixToken + accessToken,
        request: request,
      );

      serviceCateData = response.payload;
    });

    return serviceCateData;
  }
}
