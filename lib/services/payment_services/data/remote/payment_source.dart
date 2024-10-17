import 'package:dio/dio.dart';
import 'package:movemate/utils/constants/asset_constant.dart';
import 'package:retrofit/retrofit.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

// data impl
import 'package:movemate/services/payment_services/data/models/response/payment_response.dart';
import 'package:movemate/services/payment_services/data/models/request/payment_request.dart';

// utils
import 'package:movemate/utils/constants/api_constant.dart';
import 'package:movemate/utils/providers/common_provider.dart';

part 'payment_source.g.dart';

@RestApi(baseUrl: APIConstants.baseUrl, parser: Parser.MapSerializable)
abstract class PaymentSource {
  factory PaymentSource(Dio dio, {String baseUrl}) = _PaymentSource;

  @POST(APIConstants.paymentsBooking)
  Future<HttpResponse<PaymentResponse>> paymentBooking(
    @Header(APIConstants.contentHeader) String contentType,
    @Header(APIConstants.authHeader) String accessToken,
    @Queries() PaymentRequest request,
  );

  @POST(APIConstants.paymentsDeposit)
  Future<HttpResponse<PaymentResponse>> paymentDeposit(
    @Header(APIConstants.contentHeader) String contentType,
    @Header(APIConstants.authHeader) String accessToken,
    @Queries() PaymentRequest request,
  );
}

@riverpod
PaymentSource paymentSource(PaymentSourceRef ref) {
  final dio = ref.read(dioProvider);
  return PaymentSource(dio);
}
