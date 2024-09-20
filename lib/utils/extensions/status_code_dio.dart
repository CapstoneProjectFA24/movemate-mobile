import 'package:dio/dio.dart';

extension StatusCodeDioExtention on DioException {
  int onStatusDio() {
    return response!.statusCode!;
  }
}
