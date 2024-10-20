// import local
import 'package:movemate/features/order/data/models/ressponse/order_reponse.dart';
import 'package:movemate/features/order/data/remote/order_remote/order_source.dart';
import 'package:movemate/features/order/domain/repositories/order_repository.dart';

// utils
import 'package:movemate/utils/constants/api_constant.dart';
import 'package:movemate/utils/resources/remote_base_repository.dart';

class OrderRepositoryImpl extends RemoteBaseRepository
    implements OrderRepository {
  final bool addDelay;
  final OrderSource _orderSource;

  OrderRepositoryImpl(this._orderSource, {this.addDelay = true});

  @override
  Future<OrderReponse> getBookings({
    required String accessToken,
  }) async {
    return getDataOf(
      request: () => _orderSource.getBookings(APIConstants.contentType, accessToken),
    );
  }
}
