// service_repository.dart

import 'package:movemate/features/booking/data/models/response/services_package_response.dart';
import 'package:movemate/features/booking/data/remote/services_package_source.dart';
import 'package:movemate/features/booking/data/repositories/services_package_repository_impl.dart';
import 'package:movemate/features/booking/domain/entities/services_package_entity.dart';

import 'package:movemate/models/request/paging_model.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';


part 'services_package_repository.g.dart';

abstract class ServicesPackageRepository {
  // New methods for package services
  Future<ServicesPackageResponse> getPackageServices();
  Future<ServicesPackageEntity> getPackageServiceById( int id);
}
@Riverpod(keepAlive: true)
ServicesPackageRepository servicesPackageRepository(ServicesPackageRepositoryRef ref) {
  final servicesPackageSource = ref.read(servicesPackageSourceProvider);
  return ServicesPackageRepositoryImpl(servicesPackageSource);
}