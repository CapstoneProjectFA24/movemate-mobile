// import local

import 'package:movemate/features/booking/data/models/response/services_response.dart';
import 'package:movemate/features/booking/data/models/resquest/truck_request.dart';
import 'package:movemate/features/booking/data/remote/service_source.dart';
import 'package:movemate/features/booking/domain/entities/service_entity.dart';
import 'package:movemate/features/booking/domain/entities/truck_category_entity.dart';
import 'package:movemate/features/booking/domain/repositories/service_repository.dart';

import 'package:movemate/models/request/paging_model.dart';

// utils
import 'package:movemate/utils/constants/api_constant.dart';
import 'package:movemate/utils/resources/remote_base_repository.dart';

class ServiceRepositoryImpl extends RemoteBaseRepository
    implements ServiceRepository {
  final bool addDelay;
  final ServiceSource _serviceSource;

  ServiceRepositoryImpl(this._serviceSource, {this.addDelay = true});

  @override
  Future<ServicesResponse> getServices({
    // required String accessToken,
    required PagingModel request,
  }) async {
    return getDataOf(
      request: () => _serviceSource.getServices(
        APIConstants.contentType,
        // accessToken,
        // truckRequest,
      ),
    );
  }

  @override
  Future<TruckCategoryEntity> getTrucks({required PagingModel request}) {
    // TODO: implement getTrucks
    throw UnimplementedError();
  }
}
