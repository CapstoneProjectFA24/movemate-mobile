// import local

import 'package:movemate/features/test_cate_trucks/data/models/response/truck_response.dart';
import 'package:movemate/features/test_cate_trucks/data/models/resquest/truck_request.dart';
import 'package:movemate/features/test_cate_trucks/data/remote/truck_source.dart';
import 'package:movemate/features/test_cate_trucks/domain/repositories/truck_repository.dart';
import 'package:movemate/models/request/paging_model.dart';

// utils
import 'package:movemate/utils/constants/api_constant.dart';
import 'package:movemate/utils/resources/remote_base_repository.dart';
import 'package:retrofit/dio.dart';

class TruckRepositoryImpl extends RemoteBaseRepository
    implements TruckRepository {
  final bool addDelay;
  final TruckSource _truckSource;

  TruckRepositoryImpl(this._truckSource, {this.addDelay = true});

  @override
  Future<TruckResponse> getTruckCateData({
    // required String accessToken,
    required PagingModel request,
  }) async {
    // mới
    final truckRequest = TruckRequest(
      search: request.searchContent,
      page: request.pageNumber,
      perPage: request.pageSize,
    );

    print('log filter ở đây ${truckRequest.toString()}');
    return getDataOf(
      request: () => _truckSource.getTruckCate(
        APIConstants.contentType,
        // accessToken,
        truckRequest,
      ),
    );
  }
}
