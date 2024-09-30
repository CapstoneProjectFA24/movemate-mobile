// import local
import 'package:movemate/features/test/data/models/house_response.dart';
import 'package:movemate/features/test/data/remote/house_source.dart';
import 'package:movemate/features/test/domain/repositories/house_type_repository.dart';

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

   @override
  Future<HouseResponse> getHouseTypeData() async {
    return getDataOf(
      request: () =>
          _houseSource.getHouseType( APIConstants.contentType),
    );
  }
}
