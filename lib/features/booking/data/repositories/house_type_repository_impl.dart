// import local

import 'package:movemate/features/booking/data/models/response/house_type_response.dart';
import 'package:movemate/features/booking/data/remote/house_type_source.dart';
import 'package:movemate/features/booking/domain/repositories/house_type_repository.dart';
import 'package:movemate/models/request/paging_model.dart';

// utils
import 'package:movemate/utils/constants/api_constant.dart';
import 'package:movemate/utils/resources/remote_base_repository.dart';

class HouseTypeRepositoryImpl extends RemoteBaseRepository
    implements HouseTypeRepository {
  final bool addDelay;
  final HouseTypeSource _houseTypeSource;

  HouseTypeRepositoryImpl(this._houseTypeSource, {this.addDelay = true});

  @override
  Future<HouseTypeResponse> getHouseTypes({
    // required String accessToken,
    required PagingModel request,
  }) async {
    return getDataOf(
      request: () => _houseTypeSource.getHouseTypes(
        APIConstants.contentType,
        // accessToken,
      ),
    );
  }
}
