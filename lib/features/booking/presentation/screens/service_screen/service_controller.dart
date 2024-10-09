// domain - data
import 'package:movemate/features/booking/domain/entities/service_entity.dart';
import 'package:movemate/features/booking/domain/repositories/service_repository.dart';

//system
import 'package:flutter/material.dart';
import 'package:movemate/models/request/paging_model.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

// config

// utils

part 'service_controller.g.dart';

@riverpod
class ServiceController extends _$ServiceController {
  @override
  FutureOr<List<ServiceEntity>> build() async {
    return [];
  }

  Future<List<ServiceEntity>> getServices(
    PagingModel request,
    BuildContext context,
  ) async {
    List<ServiceEntity> serviceCateData = [];
    final serviceRepository = ref.read(serviceRepositoryProvider);

    state = await AsyncValue.guard(() async {
      final response = await serviceRepository.getServices(
        request: request,
      );

      serviceCateData = response.payload;

      return serviceCateData;
    });

    return serviceCateData;
  }
}
