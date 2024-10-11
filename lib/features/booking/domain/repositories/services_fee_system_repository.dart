
import 'package:movemate/features/booking/data/models/response/services_fee_system_response.dart';
import 'package:movemate/features/booking/data/remote/services_fee_system_source.dart';
import 'package:movemate/features/booking/data/repositories/services_fee_system_repository_impl.dart';
import 'package:movemate/models/request/paging_model.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'services_fee_system_repository.g.dart';

abstract class ServicesFeeSystemRepository {
  Future<ServicesFeeSystemResponse> getFeeSystems({
    // required String accessToken,
    required PagingModel request,
  });
}

@Riverpod(keepAlive: true)
ServicesFeeSystemRepository servicesFeeSystemRepository(ServicesFeeSystemRepositoryRef ref) {
  final serviceFeeSystemSource = ref.read(servicesFeeSystemSourceProvider);
  return ServicesFeeSystemRepositoryImpl(serviceFeeSystemSource);
}
