// import local



import 'package:movemate/features/booking/data/models/response/services_package_response.dart';

import 'package:movemate/features/booking/data/remote/services_package_source.dart';

import 'package:movemate/features/booking/domain/repositories/services_package_repository.dart';

// utils
import 'package:movemate/utils/constants/api_constant.dart';
import 'package:movemate/utils/resources/remote_base_repository.dart';

class ServicesPackageRepositoryImpl extends RemoteBaseRepository
    implements ServicesPackageRepository {
  final bool addDelay;
  final ServicesPackageSource _servicePackageSource;

  ServicesPackageRepositoryImpl(this._servicePackageSource, {this.addDelay = true});


  @override
  Future<ServicesPackageResponse> getPackageServices() async {
    return getDataOf(
      request: () => _servicePackageSource.getPackageServices(APIConstants.contentType),
    );
  }


}
