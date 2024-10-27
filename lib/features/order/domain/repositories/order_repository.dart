// local
import 'package:movemate/features/order/data/models/ressponse/order_reponse.dart';
import 'package:movemate/features/order/data/remote/order_remote/order_source.dart';

// system
import 'package:movemate/features/order/data/repositories/order_repository_impl.dart';
import 'package:movemate/models/request/paging_model.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';


part 'order_repository.g.dart';

abstract class OrderRepository {
  Future<OrderReponse> getBookings({
    required PagingModel request,
    required String accessToken,
    required int userId,
  });

}

@Riverpod(keepAlive: true)
OrderRepository orderRepository(OrderRepositoryRef ref) {
  final orderSource = ref.read(orderSourceProvider);
  return OrderRepositoryImpl(orderSource);
}
