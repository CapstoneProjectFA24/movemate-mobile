// service_source.dart

import 'package:dio/dio.dart';
import 'package:movemate/features/booking/domain/entities/services_package_entity.dart';
import 'package:retrofit/retrofit.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

// Data implementations
import 'package:movemate/features/booking/data/models/response/services_package_response.dart';


// Utils
import 'package:movemate/utils/constants/api_constant.dart';
import 'package:movemate/utils/providers/common_provider.dart';

part 'services_package_source.g.dart';

@RestApi(baseUrl: APIConstants.baseUrl, parser: Parser.MapSerializable)
abstract class ServicesPackageSource {
  factory ServicesPackageSource(Dio dio, {String baseUrl}) = _ServicesPackageSource;


  // New methods for package services
  @GET(APIConstants.get_package_services)
  Future<HttpResponse<ServicesPackageResponse>> getPackageServices(
    @Header(APIConstants.contentHeader) String contentType,
  );

  @GET('${APIConstants.get_package_services}/{id}')
  Future<HttpResponse<ServicesPackageEntity>> getPackageServiceById(
    @Header(APIConstants.contentHeader) String contentType,
    @Path('id') int id,
  );
}

@riverpod
ServicesPackageSource servicesPackageSource(ServicesPackageSourceRef ref) {
  final dio = ref.read(dioProvider);
  return ServicesPackageSource(dio);
}
