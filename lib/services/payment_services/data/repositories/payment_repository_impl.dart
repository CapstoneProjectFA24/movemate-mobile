// import local

import 'package:movemate/services/payment_services/data/models/request/payment_request.dart';
import 'package:movemate/services/payment_services/data/models/response/payment_response.dart';
import 'package:movemate/services/payment_services/data/remote/payment_source.dart';
import 'package:movemate/services/payment_services/domain/repositories/payment_repository.dart';

// utils
import 'package:movemate/utils/resources/remote_base_repository.dart';
import 'package:movemate/utils/constants/api_constant.dart';

class PaymentRepositoryImpl extends RemoteBaseRepository
    implements PaymentRepository {
  final bool addDelay;
  final PaymentSource _paymentSource;

  PaymentRepositoryImpl(this._paymentSource, {this.addDelay = true});

  @override
  Future<PaymentResponse> createPaymentBooking({
    required String accessToken,
    required PaymentRequest request,
  }) async {
    return getDataOf(
      request: () => _paymentSource.paymentBooking(
          APIConstants.contentType, accessToken, request),
    );
  }

  @override
  Future<PaymentResponse> createPaymentBookingByWallet({
    required String accessToken,
    required PaymentRequest request,
  }) async {
    return getDataOf(
      request: () => _paymentSource.paymentBooking(
          APIConstants.contentType, accessToken, request),
    );
  }

  @override
  Future<PaymentResponse> createPaymentDeposit({
    required String accessToken,
    required PaymentRequest request,
  }) async {
    return getDataOf(
      request: () => _paymentSource.paymentDeposit(
          APIConstants.contentType, accessToken, request),
    );
  }


}
