// utils
import 'package:movemate/features/truck/data/models/request/truck_request.dart';
import 'package:movemate/features/truck/data/models/response/truck_response.dart';
import 'package:movemate/features/truck/data/remote/truck_source.dart';
import 'package:movemate/features/truck/domain/repositories/truck_repository.dart';
import 'package:movemate/models/request/paging_model.dart';
import 'package:movemate/utils/constants/api_constant.dart';
import 'package:movemate/utils/resources/remote_base_repository.dart';
import 'package:retrofit/dio.dart';

class TruckRepositoryImpl extends RemoteBaseRepository
    implements TruckRepository {
  final bool addDelay;
  final TruckSource _truckSource;

  TruckRepositoryImpl(this._truckSource, {this.addDelay = true});

  @override
  Future<TruckResponse> getTrucks({
    required PagingModel request,
  }) async {
    final truckRequest = TruckRequest(
      page: request.pageNumber,
      perPage: request.pageSize,
      search: request.searchContent,  
    );

   print('log filter ở đây ${truckRequest.toString()}');

    return getDataOf(
      request: () => _truckSource.getTrucks(
        APIConstants.contentType,
        truckRequest,
      ),
    );
  }
}
