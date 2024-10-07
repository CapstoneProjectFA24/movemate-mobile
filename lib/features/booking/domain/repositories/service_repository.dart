import 'package:movemate/features/booking/data/models/response/services_response.dart';
import 'package:movemate/features/booking/data/remote/service_source.dart';
import 'package:movemate/features/booking/data/repositories/service_repository_impl.dart';
import 'package:movemate/features/booking/domain/entities/service_entity.dart';
import 'package:movemate/features/booking/domain/entities/truck_category_entity.dart';
import 'package:movemate/models/request/paging_model.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'service_repository.g.dart';

abstract class ServiceRepository {
  Future<ServicesResponse> getServices({
    // required String accessToken,
    required PagingModel request,
  });
  Future<TruckCategoryEntity> getTrucks({
    // required String accessToken,
    required PagingModel request,
  });
}

@Riverpod(keepAlive: true)
ServiceRepository serviceRepository(ServiceRepositoryRef ref) {
  final serviceSource = ref.read(serviceSourceProvider);
  return ServiceRepositoryImpl(serviceSource);
}
