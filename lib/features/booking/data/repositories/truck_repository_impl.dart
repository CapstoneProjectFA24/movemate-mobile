// import local


import 'package:movemate/features/booking/data/models/response/trucks_response.dart';
import 'package:movemate/features/booking/data/models/resquest/truck_request.dart';
import 'package:movemate/features/booking/data/remote/truck_source.dart';
import 'package:movemate/features/booking/domain/repositories/truck_repository.dart';
import 'package:movemate/models/request/paging_model.dart';

// utils
import 'package:movemate/utils/constants/api_constant.dart';
import 'package:movemate/utils/resources/remote_base_repository.dart';

class TruckRepositoryImpl extends RemoteBaseRepository
    implements TruckRepository {
  final bool addDelay;
  final TruckSource _truckSource;

  TruckRepositoryImpl(this._truckSource, {this.addDelay = true});

  @override
  Future<TruckResponse> getTrucks({
    // required String accessToken,
    required PagingModel request,
  }) async {
    // mới
    final truckRequest = TruckRequest(
      // search: request.searchContent,
      page: request.pageNumber,
      perPage: request.pageSize,
    );

    print('log filter ở đây ${truckRequest.toString()}');
    return getDataOf(
      request: () => _truckSource.getTrucks(
        APIConstants.contentType,
        // accessToken,
        truckRequest,
      ),
    );
  }
}
