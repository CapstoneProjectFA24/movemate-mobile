// service_package_controller.dart

import 'package:flutter/material.dart';
import 'package:movemate/features/booking/domain/entities/services_package_entity.dart';
import 'package:movemate/features/booking/domain/repositories/service_booking_repository.dart';
import 'package:movemate/models/request/paging_model.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'service_package_controller.g.dart';

@riverpod
class ServicePackageController extends _$ServicePackageController {
  @override
  FutureOr<void> build() {}

  @override
  Future<List<ServicesPackageEntity>> servicePackage(
    PagingModel request,
    BuildContext context,
  ) async {
    final servicesPackageRepository =
        ref.read(serviceBookingRepositoryProvider);

    try {
      // Fetch the package services from the repository
      final response = await servicesPackageRepository.getPackageServices();

      // Log the entire response
      // print('API Response: ${response.toJson()}');

      // If payload is already a List<ServicesPackageEntity>, use it directly
      final servicePackages = response.payload;

      // Log each service package in detail
      // for (var servicePackage in servicePackages) {
      //    print('Service Package: ${servicePackage.toJson()}');
      // }

      return servicePackages;
    } catch (e, stackTrace) {
      // Handle and log any errors that occur during the fetch or parsing
      print('Error fetching service packages: $e');
      print('StackTrace: $stackTrace');
      return [];
    }
  }
}
