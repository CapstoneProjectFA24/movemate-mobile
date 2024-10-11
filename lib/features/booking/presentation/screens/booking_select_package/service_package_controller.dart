// service_package_controller.dart

import 'package:flutter/material.dart';
import 'package:movemate/features/booking/domain/entities/services_package_entity.dart';
import 'package:movemate/features/booking/domain/repositories/services_package_repository.dart';

import 'package:movemate/models/request/paging_model.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'service_package_controller.g.dart';

@riverpod
class ServicePackageController extends _$ServicePackageController {
  @override
  FutureOr<void> build() async {}

  // New method to get package services
  Future<List<ServicesPackageEntity>> getPackageServices(
    PagingModel request,
    BuildContext context,
  ) async {
    List<ServicesPackageEntity> packageServices = [];
    final servicesPackageRepository =
        ref.read(servicesPackageRepositoryProvider);

    state = await AsyncValue.guard(() async {
      final response = await servicesPackageRepository.getPackageServices();
      packageServices = response.payload;
     
    });

    return packageServices;
  }

  // New method to get a package service by ID
  Future<ServicesPackageEntity?> getPackageServiceById(
    int id,
    PagingModel request,
    BuildContext context,
  ) async {
    ServicesPackageEntity? packageService;
    state = const AsyncLoading();
    final servicesPackageRepository =
        ref.read(servicesPackageRepositoryProvider);

    state = await AsyncValue.guard(() async {
      packageService =
          await servicesPackageRepository.getPackageServiceById(id);

    });

    return packageService;
  }
}
