// import local


import 'package:movemate/features/booking/data/models/response/services_fee_system_response.dart';
import 'package:movemate/features/booking/data/remote/services_fee_system_source.dart';
import 'package:movemate/features/booking/domain/repositories/services_fee_system_repository.dart';
import 'package:movemate/models/request/paging_model.dart';

// utils
import 'package:movemate/utils/constants/api_constant.dart';
import 'package:movemate/utils/resources/remote_base_repository.dart';

class ServicesFeeSystemRepositoryImpl extends RemoteBaseRepository
    implements ServicesFeeSystemRepository {
  final bool addDelay;
  final ServicesFeeSystemSource _serviceFeeSystemSource;

  ServicesFeeSystemRepositoryImpl(this._serviceFeeSystemSource, {this.addDelay = true});

  @override
  Future<ServicesFeeSystemResponse> getFeeSystems({
    // required String accessToken,
    required PagingModel request,
  }) async {
    return getDataOf(
      request: () => _serviceFeeSystemSource.getFeeSystems(
        APIConstants.contentType,
        // accessToken,
      ),
    );
  }
}
