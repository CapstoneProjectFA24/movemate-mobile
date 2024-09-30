// utils
import 'package:movemate/features/testapi/data/models/house_model.dart';
import 'package:movemate/features/testapi/data/models/house_response.dart';
import 'package:movemate/features/testapi/data/remote/house_source.dart';
import 'package:movemate/features/testapi/domain/repositories/house_type_repository.dart';
import 'package:movemate/utils/constants/api_constant.dart';
import 'package:movemate/utils/resources/remote_base_repository.dart';

class HouseTypesRepoImpl extends RemoteBaseRepository
    implements HouseTypeRepository {
  final bool addDelay;

  final HouseSource _houseSource;

  HouseTypesRepoImpl(this._houseSource, {this.addDelay = true});

  @override
  Future<HouseResponse> getHousesTypesData({
    required String accessToken,
  }) {
    return getDataOf(
      request: () =>
          _houseSource.getHousesTypes(APIConstants.contentType, accessToken),
    );
  }

  //
}
