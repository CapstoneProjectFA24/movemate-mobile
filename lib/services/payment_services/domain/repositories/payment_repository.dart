// local
import 'package:movemate/models/response/success_model.dart';
import 'package:movemate/services/payment_services/data/repositories/payment_repository_impl.dart';
import 'package:movemate/services/payment_services/data/models/request/payment_request.dart';
import 'package:movemate/services/payment_services/data/models/response/payment_response.dart';
import 'package:movemate/services/payment_services/data/remote/payment_source.dart';

// system
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'payment_repository.g.dart';

abstract class PaymentRepository {
  Future<PaymentResponse> createPaymentBooking({
    required String accessToken,
    required PaymentRequest request,
  });

  Future<PaymentResponse> createPaymentDeposit({
    required String accessToken,
    required PaymentRequest request,
  });

  Future<SuccessModel> paymentBookingCash({
    required String accessToken,
    required int id,
  });
}

@Riverpod(keepAlive: true)
PaymentRepository paymentRepository(PaymentRepositoryRef ref) {
  final paymentSource = ref.read(paymentSourceProvider);
  return PaymentRepositoryImpl(paymentSource);
}
