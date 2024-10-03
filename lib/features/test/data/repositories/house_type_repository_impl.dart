// import local
import 'package:movemate/features/test/data/models/response/house_response.dart';
import 'package:movemate/features/test/data/models/resquest/house_request.dart';
import 'package:movemate/features/test/data/remote/house_source.dart';
import 'package:movemate/features/test/domain/repositories/house_type_repository.dart';
import 'package:movemate/models/request/paging_model.dart';

// utils
import 'package:movemate/utils/constants/api_constant.dart';
import 'package:movemate/utils/resources/remote_base_repository.dart';
import 'package:retrofit/dio.dart';

class HouseTypeRepositoryImpl extends RemoteBaseRepository
    implements HouseTypeRepository {
  final bool addDelay;
  final HouseSource _houseSource;

  HouseTypeRepositoryImpl(this._houseSource, {this.addDelay = true});

  @override
  Future<HouseResponse> getHouseTypeData(
    {
    required PagingModel request,
    // required String accessToken,
  }
  ) async {
    final houseRequest = HouseRequest(
      search: request.searchContent,
      page: request.pageNumber,
      perPage: request.pageSize,
    );

    print('log filter ở đây ${houseRequest.toString()}');
    return getDataOf(
      request: () => _houseSource.getHouseType(
        APIConstants.contentType,
        // accessToken,
        houseRequest,
      ),
    );
  }
}
